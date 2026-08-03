# The hardlink hazard

**Claim:** sharing `node_modules` between parallel agent worktrees is not a safe
speed trick. Build tools keep mutable state in there, and it leaks between trees
by two routes — one needing hardlinks, one riding any copy at all. Both produce
wrong answers with no error message.

## The incident

Review agents over a TypeScript frontend. Every writing agent had its own git
worktree, so the source trees were properly isolated. The `node_modules`
directories were shared with `cp -al`, because a full `npm ci` per tree felt
wasteful.

Then two agents could not reproduce a failure the main session had reproduced
four times. The failure was real and the agents worked correctly. The trees were
the problem: the test runner keeps a cache inside `node_modules`, `cp -al` had
shared that file, and a run in any tree changed it for all of them. A planted
defect in one tree and a real failure in another looked identical. A wrong
diagnosis shipped that day.

## The rule

An agent that writes files gets its own worktree AND its own dependency tree. A
real `npm ci`, or keep the agent read-only.

It is the only remedy that doesn't require knowing where every tool hides its
state — which is the actual problem, because the answer differs per tool and per
version, and nothing marks which files are safe to share.

## What leaks, and why

Reproduced with controls in [`examples/hardlink-repro`](examples/hardlink-repro/)
— 11 experiments, 26 assertions. Two properties decide everything, and neither
is visible from outside:

| Cache | Written in place? | Keys | Result |
|---|---|---|---|
| vitest `results.json` | yes | relative | wrong test results |
| tsc `tsbuildinfo` | yes | relative | silent empty build |
| eslint `.eslintcache` | yes | absolute | propagates, can't collide |
| vite `deps/` | no — rename | — | harmless |

**In place** decides whether writes keep crossing between hardlinked trees. A
tool that writes a temp file and renames it breaks the link and touches nobody.

**Relative keys** decide whether one tree's entries mean anything in another —
what turns "a shared file" into "a wrong answer". vitest keys by path relative
to the project root on purpose, "so cache would be the same in CI and locally",
so tree A's entries are valid lookups in tree B. eslint writes in place too but
keys by absolute path, and is accidentally safe because of it.

The second route needs no hardlinks. A cache already inside `node_modules` at
copy time rides `cp -r`, `tar` and `rsync` alike: tsc inherits a `tsbuildinfo`
claiming its outputs exist, exits **0**, and emits nothing. So `cp -r` — which I
originally offered as a safe option — does not help. Nor does it help against a
dependency symlinked *outside* the tree (`npm link`, `file:../lib`): no copy
method dereferences a symlink, so every tree shares that one live.

**Two corrections to the first version of this note.** I blamed vite's
dependency prebundle alongside vitest — wrong, it's rename-swapped and never
propagates. And I implied this always fires: it cannot fire on a `node_modules`
that has never been run in, so it needs someone to have worked in the main tree
*before* the worktrees were cut. That's the normal way you get worktrees, and
it's why the thing misfires intermittently rather than always.

## Prior art

The mechanism is old and well documented. Hardlink-based backup rotation
(`cp -al`, rsnapshot) has always had the property that editing a file in place
corrupts every snapshot sharing it, and pnpm's store documents the same hazard
in this exact directory. **Nothing about "hardlink aliasing + in-place write =
shared mutation" is new here.**

Worktree isolation for parallel agents is also well covered — Zylos Research
(2026-02-22), Dave Schumaker (2026-03-13), Termdock (2026-03-20). Where those
discuss cache contamination they blame something else: build tools with shared
or absolute-path cache directories, symlinked `node_modules` breaking module
resolution, or two agents sharing a database. *(An earlier version of this note
said those guides recommend hardlinking. They do not — Zylos recommends pnpm's
store, Schumaker rejected Yarn's `hardlinks-global` as too slow. The one that
proposes hardlinking `node_modules` into agent worktrees, with no risk
discussion, is Roo-Code issue #11758, 2026-02-26.)*

**What's new**, narrowly: a measured instance of that old mechanism changing
*test outcomes* between agent worktrees, a second where a plain `cp -r` yields a
silent empty build, and a map of which caches propagate and which don't. Not a
new mechanism — a documented one.

The general shape: `node_modules` is an immutable install and a mutable scratch
directory in one folder, and every way of copying it gets one of those two jobs
wrong. Everyone treats dependency sharing as a cost question; it is also a
correctness question.

## Why this is an agent note

The mechanism is not about agents at all. A CI job that caches `node_modules`
and restores it into a fresh checkout reproduces the silent empty build exactly
— I checked. Nobody should claim AI causes this.

Three things make it an agent problem anyway, and only the third is interesting.

**It becomes near-universal.** A human cuts a worktree occasionally. An agent
fleet cuts and discards them continuously, which puts install time on the
critical path of every task and makes sharing `node_modules` the obvious move.
The precondition — someone ran the suite in the main tree before the worktrees
were cut — goes from occasional to constant.

**It lands on the verification layer specifically.** The reason you can run six
agents is that you are no longer reading every diff; you have delegated checking
to the suite. That verdict *is* the trust mechanism. This bug makes it depend on
what a different agent did in a different directory — so it corrupts precisely
the instrument that made delegation safe in the first place. Not a bug that
happens to affect agent setups; a bug in what agent setups run on.

**And the agent takes the reading at face value.** A human who sees an
impossible failure eventually suspects their environment. An agent reasons from
the output it was given: red means broken, so it "fixes" working code; green
means done. In my incident two agents reported "cannot reproduce" with complete
confidence, and that report was believed. They were not wrong to trust the
tools — they had no way to know the tools were cross-talking. Which is the
general lesson: an agent's report inherits every lie its environment tells it,
and the agent has no prior that would flag the lie.

Longer walkthrough: [what's actually going on](hardlink-hazard-explained.md).
Wider form: [the session has no concurrency
model](the-session-has-no-concurrency-model.md).
