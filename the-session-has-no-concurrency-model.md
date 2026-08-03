# The session has no concurrency model

*Status: searched 2026-07-31. A near-exact practitioner match exists
(Meiklejohn); the orchestrator-poisons-its-own-readers case and the
frozen-snapshot fix are the deltas.*

**Claim:** a session orchestrating agents has no model of shared state.
It parallelizes by task shape — one lane per file, one per question —
not by data-dependency analysis; it treats agents as pure function calls
against an immutable world; and it will not idle while they run, because
continuing feels productive. You cannot take for granted that it picks
the right isolation between subagents, or that it waits for them to
finish before changing what they are reading. Every rule that fixes this
is imposed after an incident; none is volunteered.

## The incidents — one day, three failures

- **It edited under its readers.** A session kept committing to the same
  checkout its read-only review lanes were reading. A whole verify pass
  burned on stale line numbers; one lane reported the session's own new
  test files as the pre-existing baseline; another described the
  session's commits as someone else's uncommitted work. The findings
  were invalidated before they arrived — by the orchestrator itself.
- **It let writers clobber each other.** Two review lanes each planted a
  defect and restored it, in one shared tree. They restored over each
  other — and a test the session ran meanwhile read a file mid-mutation,
  where a real failure and a planted one look identical. A wrong
  diagnosis shipped from that.
- **It isolated the source and not the dependencies.** The subtlest
  form: worktrees per writer, dependency trees shared by hardlink, build
  caches crossing all trees at once
  ([the hardlink hazard](two-worktrees-one-node-modules.md)).

## The mechanism

Concurrency safety requires asking who reads what while who writes what.
The session does not ask it. Fan-out size comes from the task's shape
([agents launch at full price](agents-launch-at-full-price.md) — the
economics half of the same blindness); isolation comes from whatever the
harness defaults to; and waiting loses to acting, every time, because an
idle orchestrator feels like a stalled one.

The familiar split applies here too: ask the session about worktree
isolation and it recites the right advice — the guides are in its
training data. Then it operates without it. Quotable is not operative,
for concurrency as for everything else.

## The rules — all imposed, none volunteered

- An agent that MODIFIES files gets its own worktree, and its own
  dependency tree — real install or plain copy, never hardlinks.
- Read-only lanes may share the orchestrator's checkout only if the
  checkout is FROZEN while they read: the session does not edit, does
  not commit, does not run mutating tests until every lane lands. If it
  cannot wait, it hands the lanes a `git archive` snapshot of a fixed
  commit and works on.
- Findings that arrive after the tree moved are stale by default: a
  lane's report is evidence about the commit it read, which the report
  must name.
- Parallelize by data dependency, not task shape: two lanes may run
  together when neither writes what the other reads — otherwise they
  are sequential, however parallel the task list looks.

## Prior art

**Verdict: PARTIAL — with the tightest neighbor in this collection.**
Christopher Meiklejohn's "One Writer" (2026-07-27) is near-verbatim on the
core claim: a session spawned 84 workers into one checkout "without being able
to say what any one of them would read or write," and "the isolation below git
is advisory, and agents have to choose it. Mine routinely don't." His earlier
post, "Multi-Agent Systems Have a Distributed Systems Problem" (2026-03-30),
reports two agents in separate worktrees both creating the same migration, one
silently overwriting the other. The systems literature is converging too:
STORM (arXiv:2605.20563) calls worktree-per-agent the field's default and
argues it defers conflict to an expensive merge; CoAgent (arXiv:2606.15376)
and Co-Coder (arXiv:2606.00953) build concurrency control and dependency-aware
scheduling as external fixes, the latter explicitly treating Claude Code's
parallelism as not dependency-aware. What none of them cover: the orchestrator
corrupting its OWN dispatched readers by committing to the tree they are
mid-read on (their incidents are peer-versus-peer), the "won't idle because
idle feels like stalling" bias named as such, and the cheap frozen-snapshot /
`git archive` fix. Those are the deltas.
