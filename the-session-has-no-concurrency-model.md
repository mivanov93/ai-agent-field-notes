# The session has no concurrency model

*Status: not separately searched; the neighbors found in the delegation
sweep are noted at the end.*

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
  ([the hardlink hazard](the-hardlink-hazard.md)).

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

Not separately searched; from the earlier delegation sweep: the
worktree-for-parallel-agents guides document HOW to isolate — written as
instructions for the human to set up, which is itself the tell — and
none state that the session will not do this unprompted. The
frozen-snapshot-for-readers rule came back not-found in that sweep. The
claim to check in a dedicated search: the session-as-orchestrator having
no shared-state model, and wait-versus-act as a systematic bias.
