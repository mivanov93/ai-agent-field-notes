# The hardlink hazard

**Claim:** sharing `node_modules` between parallel agent worktrees with
hardlinks (`cp -al` or similar) is not a safe speed trick. Build tools
write caches inside `node_modules`. Hardlinked files share storage. So one
agent's test run silently changes the caches of every other tree.

## The incident

A session was running review agents over a TypeScript frontend. Every agent
that wrote files had its own git worktree — the source trees were properly
isolated. The `node_modules` directories were copied with `cp -al`, the
standard trick from the worktree guides, because a full `npm ci` per tree
felt wasteful.

Then two agents could not reproduce a test failure the main session had
reproduced four times. The failure was real. The agents worked correctly.
The trees were the problem: vite and vitest keep caches inside
`node_modules`, `cp -al` had shared those files, and every test run in any
tree changed the caches for all of them. A planted defect in one tree and a
real failure in another looked identical. A wrong diagnosis shipped the
same day.

## The rule

An agent that writes files gets its own worktree AND its own dependency
tree. Fine: a real `npm ci`, a plain `cp -r`, or keeping the agent
read-only. Not fine: `cp -al`, or anything else that shares storage with a
tree a test run will touch.

The general form: any tool that writes state into the dependency directory
— vite, vitest, webpack's cache, turborepo, jest — turns shared
`node_modules` into a hidden channel between your "isolated" agents. The
corruption is silent and intermittent, and it looks exactly like flaky
tests. For a setup whose whole point is trustworthy parallel checking, that
is the worst possible failure mode.

## Reproducing it

Two worktrees of any vite project. `cp -al` the `node_modules` across. Run
tests in tree A while tree B holds a source change. Tree B's runs now mix
stale and fresh cache entries. Takes five minutes.

## Prior art

Worktrees for parallel agents are heavily written about (Zylos Research
2026-02-22, Dave Schumaker 2026-03-13, many more), and those guides do
recommend hardlinks or pnpm's shared store — as a speed and disk
optimization. I found no source that flags the cache-corruption problem,
and no incident report of it.

**What I think is new:** everyone treats this as a cost question. It is a
correctness question, and the incident above is what it costs when it
fires.
