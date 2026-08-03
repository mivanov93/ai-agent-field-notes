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
cp -al A/node_modules B1/node_modules          # hardlinked
cd B1; npx vitest run --no-file-parallelism    # 2 passed

cd ../A                                        # break a test in A ONLY
cat > src/use.test.js <<'EOF'
import { test, expect } from 'vitest'
test('use needs the fixture', () => { expect(1).toBe(2) })
EOF
npx vitest run --no-file-parallelism           # 1 failed

cat ../B1/node_modules/.vite/vitest/*/results.json   # <- look at this

cd .. && mkdir -p B2/src                       # worktree cut AFTER, byte-identical to B1
cp B1/package.json B2/ && cp B1/src/*.test.js B2/src/
cp -al A/node_modules B2/node_modules
cd B2; npx vitest run --no-file-parallelism    # 1 failed
```

B1 and B2 are byte-identical — `diff -r B1/src B2/src` is empty. Both are fresh
checkouts of a suite that passes. B1 is green and B2 is red, and the only thing
separating them is that B2 was cut after an unrelated failure in a third
directory.

B2's failure isn't even A's failure. A's is `expected 1 to be 2`, the defect you
planted. B2's is:

```
Error: ENOENT: no such file or directory, open 'fixture.json'
```

which is `use` running before `seed` had written the fixture. And the `cat`
shows why: the shared cache says `"use.test.js": {"failed":true}` — A's verdict,
sitting in B's file, because it *is* B's file.

**Why.** vitest records how long each test took and whether it failed, so its
sequencer can run previously-failed files first. That cache lives in
`node_modules/.vite/vitest/`, and three things line up: it's written with a
plain `fs.writeFile` (overwritten in place, so a hardlinked file carries the
write to every tree); its entries are keyed by path **relative** to the project
root — deliberately, so the cache matches between CI and local, which also makes
A's entries valid lookups in B; and the sequencer runs failed files first.

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
npx tsc && npx vitest run dist --passWithNoTests    # dist=[math.js math.test.js], 1 passed

cd .. && mkdir -p wt/src                  # a second worktree
cp main/tsconfig.json main/package.json wt/
cp main/src/*.ts wt/src/                  # identical source. nothing edited.
cp -r main/node_modules wt/node_modules   # a PLAIN copy. no hardlinks, no symlinks.
cd wt

npx tsc ; echo "tsc exit=$?"              # exit=0
ls dist                                   # nothing
npx vitest run dist --passWithNoTests     # No test files found, exiting with code 0
```

Same source, same commands, same everything. In `main` you get a build and one
passing test. In `wt` you get:

```
tsc exit=0
ls: cannot access 'dist': No such file or directory
No test files found, exiting with code 0
```

Exit 0 throughout. Your build compiled nothing, your suite ran nothing, and CI
is green. `npm pack` in that state reports `total files: 1` — just
`package.json`. That's how you publish an empty package with a green pipeline.

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

`--passWithNoTests` is what converts that into a green suite, and it's common in
monorepos where some packages legitimately have no tests. It's doing its job; it
just can't tell "no tests here" from "the tests didn't get built."

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

`node_modules` is two things in one folder: an immutable install, and a mutable
scratch directory that build tools write to. Sharing is safe for the first and
unsafe for the second, and nothing marks which is which. Every way of copying it
gets one of those jobs wrong — hardlinks break the mutable half, plain copies
carry stale state into a directory it doesn't describe, and symlinked deps
(`npm link`, `file:../lib`) share the live thing outright, since no copy method
dereferences a symlink.

**Fixes**, weakest to strongest:

- `rm -rf node_modules/.cache node_modules/.vite` after copying, by any method.
  Kills demo 1 outright.
- vite/vitest: `cacheDir: './.vitecache'` moves them out of `node_modules`.
- Own dependency tree per writing agent. The only fix that doesn't require
  knowing where every tool hides state.

## What's not new

Hardlink aliasing plus in-place writes is decades old — `cp -al` backup
rotation, and pnpm's store docs warn that editing `node_modules` corrupts the
shared store for every project on the machine. I'm not claiming a mechanism.

I'm claiming measured instances: a plain `cp -r` producing a green pipeline that
built nothing and tested nothing, hardlinks turning a passing suite red, and the
map of which caches propagate. Existing writing on worktree cache contamination
blames shared build-cache dirs (Bazel/Nx/Turbo), symlink resolution, or shared
databases — not this.

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
