# Extension of Broekx: the shared git index

*Extends Ruben Broekx, "AI Agents Need Their Own Desk, and Git Worktrees Give
Them One" (Towards Data Science, 2026-04-18), which named the problem this
note builds on. Read his piece first.*

**Claim:** Broekx's "desk" is right, and the hazard reaches one layer deeper
than his telling. He shows that you and the agent sharing one working
directory is dangerous — the agent edits while you edit, then reverts the
changes it does not recognize — and that a git worktree, with its own branch
and its own ports, gives each of you a separate desk. The layer underneath
is the git staging area: even at one desk you share a single index, and an
unscoped commit sweeps your half-staged work into the agent's commit. A
worktree fixes the working tree; it does not fix a plain "commit everything."

## What Broekx already established

The desk metaphor, and the human-versus-agent framing (not agent-versus-
agent): a human making small edits while the agent runs, and the agent
overwriting or reverting them because it has no memory of them. His fix is a
worktree per agent — a second window on the same project, locked to its own
branch — plus a per-worktree port offset so two dev servers do not fight over
one port. All of that is his, and it is correct.

## The part this adds — the shared index

The staging area is shared even within a single checkout, and it is not what
a worktree isolates. The incident: I was staging my own changes by hand for a
separate, half-finished commit while a session worked in the same tree. The
session ran a plain "commit everything currently staged," and my staged work
went into its commit alongside its own. Nothing warned either of us. This is
not a dirty-working-tree edit or a branch switch — the failure paths Broekx's
worktrees prevent — it is the index itself, and an unscoped commit reaches it
whether or not you are on separate desks.

## The rule

Take Broekx's worktree as the baseline, then add two things it does not
cover:

- Commit with explicit file lists — `git commit -- path/to/file` — never
  "commit everything" or `git add -A`, whenever a human might be staging in
  the same index.
- Keep your own processes on ports the agent will not reuse (his port-offset
  logic handles the agent's side; make sure yours is out of its range too).

The through-line is his, one step further: treat anything you and the agent
both touch as shared, changeable state — the working tree, the index, the
ports — and the agent will not warn you, because from inside the session it
has the desk to itself.

## Prior art

Ruben Broekx, "AI Agents Need Their Own Desk…" (Towards Data Science,
2026-04-18) — the direct parent, verified: the desk framing, human-versus-
agent, worktrees, and per-worktree ports are all his. Two Claude Code
incident reports (GitHub anthropics/claude-code #37888 and #55024) show the
same "acts as if alone, overwrites, no warning" dynamic through
`git checkout -- .`, a different destructive path than the index sweep. A
steipete gist prescribes explicit-file commits, framed for agent-to-agent
coordination. Not found in the sweep: the shared-staging-index sweep between
a human hand-staging and an agent's unscoped commit, as distinct from the
shared working tree — the one increment this note claims on top of Broekx.
Connects to [the session has no concurrency model](../the-session-has-no-concurrency-model.md):
the other worker sharing your state can be you.
