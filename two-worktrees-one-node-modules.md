# Share node_modules between two git worktrees and a passing test gets reported as failed

Anywhere you copy `node_modules` instead of installing it, you can inherit
another directory's build state and get a wrong answer from it.

The common ways to end up doing that: git worktrees (each needs its own
`node_modules`, and installing per tree is slow, so people copy or hardlink it
— every guide on running coding agents in parallel discusses this), and CI
caching (`actions/cache` on `node_modules`, restored into a fresh checkout).
Both are discussed purely as disk-and-speed decisions.

They're also correctness decisions. Two paste-able demos, no repo to clone — the
first needs no configuration at all, the second needs one common tsconfig
setting that I flag where it matters.

## 1. A passing test reported as failed

No configuration: vitest's cache location is its own default, nothing here sets
`cacheDir`, and nothing is deleted at any point. Two worktrees get cut from the
same project — one before a failure elsewhere, one after.

```bash
cd "$(mktemp -d)" && echo "working in $PWD"   # self-contained; paste as often as you like

mkdir -p A/src && cd A
npm init -y >/dev/null && npm i vitest
cat > src/seed.test.js <<'EOF'
// Padding keeps this the larger file, which fixes only the FIRST run's order:
// vitest breaks a cold-cache tie by file size. Nothing later depends on it.
import { writeFileSync } from 'node:fs'
import { test, expect } from 'vitest'
const spin = (ms) => { const t = Date.now(); while (Date.now() - t < ms); return 1 }
test('seed writes the fixture', () => {
  expect(spin(200)).toBe(1)
  writeFileSync('fixture.json', '{"ready":true}')
})
EOF
cat > src/use.test.js <<'EOF'
import { readFileSync } from 'node:fs'
import { test, expect } from 'vitest'
test('use needs the fixture', () => {
  expect(JSON.parse(readFileSync('fixture.json','utf8')).ready).toBe(true)
})
EOF
npx vitest run --no-file-parallelism           # 2 passed

cd .. && mkdir -p B1/src                       # worktree cut BEFORE
cp A/package.json B1/ && cp A/src/*.test.js B1/src/
cp -r A/node_modules B1/node_modules           # a plain copy
cd B1; npx vitest run --no-file-parallelism    # 2 passed

cd ../A                                        # break a test in A ONLY
cat > src/use.test.js <<'EOF'
import { test, expect } from 'vitest'
test('use needs the fixture', () => { expect(1).toBe(2) })
EOF
npx vitest run --no-file-parallelism           # 1 failed

cat node_modules/.vite/vitest/*/results.json    # A's cache. B2 inherits this.

cd .. && mkdir -p B2/src                       # worktree cut AFTER, byte-identical to B1
cp B1/package.json B2/ && cp B1/src/*.test.js B2/src/
cp -r A/node_modules B2/node_modules
cd B2; npx vitest run --no-file-parallelism    # 1 failed
```

B1 and B2 are byte-identical — `diff -r B1/src B2/src` is empty. Both are fresh
checkouts of a suite that passes, each with its own private copy of
`node_modules`. B1 is green and B2 is red, and the only thing separating them is
that B2 was copied after an unrelated failure in a third directory. B1 stays
green however often you re-run it; B2 stays red.

B2's failure isn't even A's failure. A's is `expected 1 to be 2`, the defect you
planted. B2's is:

```
Error: ENOENT: no such file or directory, open 'fixture.json'
```

which is `use` running before `seed` had written the fixture. And the `cat`
shows why. A's cache, the copy B2 is made from, reads:

```json
{"version":"4.1.10","results":[[":src/seed.test.js",{"duration":201,"failed":false}],
                               [":src/use.test.js",{"duration":3.5,"failed":true}]]}
```

`"failed":true` for `use.test.js` — and B2's copy of that file is intact and
passes. B2 inherits A's verdict about A's broken file. (B1, copied before any of
this, has its own clean copy saying `"failed":false`, which is why it stays
green.)

**Why.** vitest records how long each test took and whether it failed, so its
sequencer can run previously-failed files first. That cache lives in
`node_modules/.vite/vitest/`, so it travels with any copy of `node_modules`.
Its entries are keyed by path **relative** to the project root — deliberately,
so the cache matches between CI and local, which also makes A's entries valid
lookups in B2. The sequencer then runs failed files first.

**`cp -al` makes it worse, not different.** Hardlink the tree instead of copying
it and there is only one cache file with several names, written in place, so the
poisoning is live and permanent in both directions — every tree, forever, not
just the ones cut after the failure. I used a plain `cp -r` above because it is
the weaker assumption and it still fails.

So A's failure reorders B2's suite, and any order coupling in your tests becomes
a false red. That precondition is real and I'll state it plainly: fully
independent tests just get shuffled harmlessly. Order coupling is also extremely
common — one spec seeding a database, writing a setup file, or leaving a global
another reads.

This is the one that cost me a day: two agents couldn't reproduce a failure the
main session had reproduced four times, and a wrong diagnosis shipped.

## 2. A green build that builds nothing, and a green suite that runs nothing

```bash
cd "$(mktemp -d)" && echo "working in $PWD"   # self-contained; paste as often as you like

mkdir -p main/src && cd main
npm init -y >/dev/null && npm i typescript vitest
cat > tsconfig.json <<'EOF'
{ "compilerOptions": { "incremental": true, "outDir": "dist", "rootDir": "./src",
    "tsBuildInfoFile": "node_modules/.cache/tsbuildinfo" }, "include": ["src"] }
EOF
cat > src/math.ts <<'EOF'
export const add = (a: number, b: number) => a + b
EOF
cat > src/math.test.ts <<'EOF'
import { test, expect } from 'vitest'
import { add } from './math.js'
test('add works', () => { expect(add(2, 2)).toBe(4) })
EOF
node -e 'p=require("./package.json");p.main="dist/math.js";p.files=["dist"];
  require("fs").writeFileSync("package.json",JSON.stringify(p,null,2))'
npx tsc && npx vitest run dist --passWithNoTests    # dist=[math.js math.test.js], 1 passed
npm pack --dry-run 2>&1 | grep "total files"        # total files: 3

cd .. && mkdir -p wt/src                  # a second worktree
cp main/tsconfig.json main/package.json wt/
cp main/src/*.ts wt/src/                  # identical source. nothing edited.
cp -r main/node_modules wt/node_modules   # a PLAIN copy. no hardlinks, no symlinks.
cd wt

npx tsc ; echo "tsc exit=$?"              # exit=0
ls dist                                   # nothing
npx vitest run dist --passWithNoTests     # No test files found, exiting with code 0
npm pack --dry-run 2>&1 | grep "total files"   # total files: 1
```

Same source, same commands, same everything. In `main` you get a build and one
passing test. In `wt` you get:

```
tsc exit=0
ls: cannot access 'dist': No such file or directory
No test files found, exiting with code 0
```

Exit 0 throughout. Your build compiled nothing, your suite ran nothing, and CI
is green. Run `npm pack --dry-run` here and it reports `total files: 1` — just
`package.json`, against the 3 it packed in `main`. That is how you publish an
empty package with a green pipeline.

**First, the caveat, because it matters.** tsc's *default* buildinfo location is
`./tsconfig.tsbuildinfo` in the project root — not `node_modules`. This demo
needs `tsBuildInfoFile` pointed into `node_modules`, which is a widely
recommended practice (it keeps `dist` clean for publishing, and `node_modules`
is already gitignored) but is opt-in. If you haven't done that, you are not
exposed to this one. Check your own tsconfig before worrying.

That location isn't incidental, either — it's the whole mechanism. The failure
needs the build record copied while `dist` isn't, and that only happens when the
record lives inside `node_modules`.

**Why it fires.** `--incremental` writes a record of what it built. Copy `node_modules` and the new
directory inherits a record of a build that happened *somewhere else*, claiming
outputs that exist over there and not here. tsc trusts the record over the
filesystem, so it skips the work and exits 0. Delete
`node_modules/.cache/tsbuildinfo` and it builds correctly.

Two things have to line up for the *suite* half. The tests are run against the
compiled output (`vitest run dist`) rather than against `src` — common when you
ship compiled tests or test the built artifact, but if you run vitest on `src`
your tests still run and only the build is empty. And `--passWithNoTests` turns
"I found nothing" into a pass, which is common in monorepos where some packages
legitimately have no tests. It's doing its job; it just can't tell "no tests
here" from "the tests didn't get built."

To be clear about the limits: tsc keys on file *contents*, so if you edit a
source file it recompiles and reports errors correctly. I tried to sneak a real
type error past it and couldn't. The failure is missing output, not wrong
output.

**And this one isn't about worktrees, or agents.** Swap the `cp -r` for
`tar -czf node_modules.tgz node_modules` in one job and `tar -xzf` in the next,
and it fails identically — which is precisely what caching `node_modules`
between CI jobs does. I checked; same empty `dist`, same exit 0. No agents, no
worktrees, no hardlinks required.

## Which caches do this is not guessable

I measured four:

| | writes in place | keys | result |
|---|---|---|---|
| vitest `results.json` | yes | relative | false red |
| tsc `tsbuildinfo`\* | yes | relative | silent empty build |
| eslint `.eslintcache` | yes | **absolute** | shared file, entries can't collide — harmless |
| vite `deps/` | **no**, temp+rename | — | harmless |

Writing in place decides whether hardlinks carry it. Relative keys decide
whether another tree's entries mean anything — which is what turns "a shared
file" into "a wrong answer". eslint writes in place exactly like vitest and is
harmless anyway, because it stores absolute paths no other tree will look up.
vite's dependency cache is the big scary-looking one and is completely safe,
because it happens to rebuild into a temp directory and rename.

\* only when you've pointed `tsBuildInfoFile` into `node_modules`; tsc's default
is the project root. vite and vitest default into `node_modules` on their own.

None of that is documented and any of it could change in a patch release. Don't
trust the table — measure your own stack.

## The root cause

`node_modules` is two things in one folder: an install output you'd like to
share, and a mutable scratch directory that build tools write to and that
describes one specific directory. Nothing marks which is which — so no way of
copying it gets both jobs right *by default*. Hardlinks break the mutable half
permanently; plain copies carry stale state into a directory it doesn't
describe. Both are fixable once you know (see below), which is the point: you
have to know.

Symlinked deps (`npm link`, `file:../lib`) are a separate problem rather than a
third copy method — no copy method dereferences a symlink, so every tree shares
that one live no matter how you copy.

**Fixes**, weakest to strongest:

- `rm -rf node_modules/.cache node_modules/.vite` after copying, by any method.
  Kills demo 1 outright.
- vite/vitest: `cacheDir: './.vitecache'` moves them out of `node_modules`.
- **An agent that writes files gets its own worktree AND its own dependency
  tree** — a real `npm ci`, or keep it read-only. The only fix that doesn't
  require knowing where every tool hides its state, which is the actual problem:
  the answer differs per tool and per version, and nothing marks which files are
  safe to share.

## Why this is an agent problem, and where it isn't

The mechanism has nothing to do with AI. A CI job that caches `node_modules` and
restores it into a fresh checkout reproduces the silent empty build exactly.
Nobody should claim agents cause this.

Three things make it an agent problem anyway, and only the third is interesting.

**It becomes near-universal.** A human cuts a worktree occasionally. An agent
fleet cuts and discards them continuously, which puts install time on the
critical path of every task and makes sharing `node_modules` the obvious move.
The precondition — someone ran the suite in the main tree before the worktrees
were cut — goes from occasional to constant.

**It lands on the verification layer specifically.** The reason you can run six
agents is that you are no longer reading every diff; you have delegated checking
to the suite. That verdict *is* the trust mechanism. This makes it depend on what
a different agent did in a different directory — so it corrupts precisely the
instrument that made delegation safe. Not a bug that happens to affect agent
setups; a bug in what agent setups run on.

**And the agent takes the reading at face value.** A human who sees an
impossible failure eventually suspects their environment. An agent reasons from
the output it was given: red means broken, so it "fixes" working code; green
means done. In the incident behind this post, two agents reported "cannot
reproduce" with complete confidence and that report was believed. They were not
wrong to trust the tools — they had no way to know the tools were cross-talking.
An agent's report inherits every lie its environment tells it, and it has no
prior that would flag the lie.

## What's new, and what's known

**New — what I'm actually claiming.**

1. **Two measured wrong verdicts**, not a theory: a plain `cp -r` yielding a
   pipeline that compiled nothing, ran zero tests, exited 0 and would publish an
   empty package; and a shared cache turning a passing suite red in a directory
   nobody touched. Both reproduce from an empty directory in about a minute.
2. **The propagation map.** Whether a cache is dangerous turns on two properties
   nobody documents — written in place vs. temp-and-rename, and keys relative
   vs. absolute. Measured across four caches, and *not guessable from the
   outside*: vite's dependency cache is the big conspicuous one and is the only
   one of the four that is completely safe, while the small forgettable ones
   cause both failures above.
3. **That it reaches CI, not just worktrees.** The same copy-time failure fires
   from an `actions/cache` restore of `node_modules` into a fresh checkout.
   Verified.

I found nobody connecting cache state resident in `node_modules` to a wrong
verdict in a different directory. Existing writing on worktree contamination
blames shared build-cache dirs (Bazel/Nx/Turbo), symlink resolution, or shared
databases. Zylos Research (2026-02-22), Dave Schumaker (2026-03-13) and Termdock
(2026-03-20) all cover worktree isolation for parallel agents without it.

**Known — cite these; I'm not claiming them.**

Hardlink aliasing plus in-place writes is decades old: hardlink-based backup
rotation (`cp -al`, rsnapshot) has always had the property that editing a file in
place corrupts every snapshot sharing it, and pnpm's store documents the same
hazard in this exact directory — edit a file in `node_modules` and you corrupt
the shared store for every project on the machine. That tsc trusts its build
record over the filesystem is also known; people hit it by deleting `dist/` by
hand. **The mechanisms are old. What I'm claiming is that they produce wrong
answers in a setup a lot of people are adopting right now, and a map of when.**

One correction I owe: an earlier version of this claimed the worktree guides
recommend hardlinking `node_modules`. They don't — Zylos recommends pnpm's
store, and Schumaker tried Yarn's `hardlinks-global` and rejected it as too
slow. The one that does propose hardlinking `node_modules` into agent worktrees,
with no risk discussion at all, is Roo-Code issue #11758 (2026-02-26).

Verified on TypeScript 5.9.3 **and** 7.0.2 (the native port — `npm i typescript`
gives you 7 today, and it fails identically), vitest 4.1.10, vite 8.2.0, eslint
9.39.5, node 24.16.0, Linux.

Full reproduction — 11 experiments with control groups — plus a detector that
points two worktrees at your own project and lists what leaked: [examples/hardlink-repro](examples/hardlink-repro/)

One note on that detector. Its first version hardlinked your real `node_modules`
into the tree it then ran your build in, committing the exact bug it looks for,
while its header claimed it was read-only. Its second version fixed the design
but "verified" safety with a check that silently measured nothing on any project
big enough to matter, and cheerfully printed *untouched*. The first was caught by
review; the second only by running it. A check that passes without evidence is
indistinguishable from a check that passes — which is the whole subject.
