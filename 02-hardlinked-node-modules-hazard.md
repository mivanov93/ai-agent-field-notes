# The hardlink hazard

**Claim:** sharing `node_modules` between parallel agent worktrees via
hardlinks (`cp -al`, and by extension any inode-sharing scheme) is a
*correctness* hazard, not the disk/speed optimization the worktree guides
describe: modern build tools write caches inside `node_modules`, hardlinks
share inodes, and every cache write silently crosses all trees at once.

## The incident

A session was orchestrating review agents over a TypeScript frontend. The
source trees were properly isolated — each writing agent in its own git
worktree. The dependency trees were "isolated" with `cp -al`, the standard
trick from the worktree-for-agents guides, because a full `npm ci` per tree
felt wasteful.

The session then could not get two lanes to reproduce a test failure it had
itself reproduced four times. The failure was real. The lanes were honest.
The trees were lying: vite and vitest keep their caches under
`node_modules/.vite` and friends, `cp -al` had shared those directories by
inode, and every test run in any tree mutated the caches of all of them. A
planted defect in one tree and a real failure in another became
indistinguishable; a wrong diagnosis shipped the same day.

## The rule

An agent that modifies files gets its own worktree **and its own dependency
tree**. Acceptable: a real `npm ci`, a plain `cp -r`, or keeping the lane
read-only (a read-only lane may share the primary checkout — provided
nothing edits that checkout under it while it reads). Not acceptable:
`cp -al`, or any "instant clone" that shares inodes with a tree a test run
will touch.

The general form: **any tool that writes state into the dependency
directory** — vite, vitest, webpack's filesystem cache, turborepo, jest's
haste maps — converts shared-inode dependency trees into a covert channel
between supposedly isolated agents. The corruption is silent, intermittent,
and presents as flaky or irreproducible tests, which is the worst possible
failure signature for a system whose entire purpose is trustworthy parallel
verification.

## Reproducing it

Two worktrees of any vite project; `cp -al` the `node_modules` across; run
the suite in tree A while tree B holds a source mutation; watch tree B's
runs interleave stale and fresh transform-cache entries. Five minutes.

## Prior art

The git-worktree-for-parallel-agents pattern is heavily documented
(2025–26: Zylos Research 2026-02-22, Dave Schumaker 2026-03-13, many
others), and dependency sharing via hardlinks or pnpm's store appears in
those writeups **as a performance lever**. I found no source flagging the
cache-corruption failure mode, and no incident report of it.

**The delta:** the entire published discussion frames this as a cost
problem. It is a correctness problem, and the incident above is what it
costs when it fires.
