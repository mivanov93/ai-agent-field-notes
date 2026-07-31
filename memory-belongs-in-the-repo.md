# Memory belongs in the repo

*Status: searched 2026-07-31. The five defects are each corroborated; the
same-organ, fold-and-delete thesis is the delta.*

**Claim:** a harness memory mechanism — persistent notes the agent keeps
outside the repo — recreates the instruction file with worse properties.
It is not versioned, not shared, not reviewed, not linted, it is a second
thing loaded into every session, and it grows with the same accretion
disease the instruction file has, but unwatched. Durable project knowledge
folds into the in-repo instruction file. Memory holds only what genuinely
cannot live in the repo.

## The tension

The memory mechanism looks free: the agent learns something, writes it
down, future sessions benefit. In practice each entry buys five problems:

- **Not shared.** The repo travels — other checkouts, other machines,
  eventually other people. The memory directory does not. Knowledge that
  lives there is invisible exactly where the instruction file would have
  carried it.
- **Not versioned.** No history, no review, no diff in any commit. A
  wrong memory is corrected by nobody, because nobody sees it change —
  and a stale entry that quietly lies is worse than a missing one.
- **Not enforced.** Whatever lints and checks watch the instruction file
  (and the whole point of scar tissue is that checks watch it), the
  memory sits outside all of them.
- **A second load.** Two files now compete for the same context budget
  and can disagree with each other — the one-home-per-fact rule, broken
  at the infrastructure level.
- **The same growth, unwatched.** Instruction files at least sit in the
  repo where their growth gets measured
  ([the rule-efficacy pipeline](the-rule-efficacy-pipeline.md)). The
  memory grows in the dark.
- **Not project-scoped.** The project-directory memory files
  (loaded from a per-directory path, distinct from the newer git-repo-keyed
  auto-memory) key memory to a directory path, not a repo. Run two projects from one directory — or rename one — and
  they share memory invisibly. My WebRTC project inherited a blog
  project's memory for five weeks, including the worst file the mechanism
  ever produced ([the model's model of you](the-models-model-of-you.md)).
  Repo-homed knowledge is scoped to its project and travels with it, by
  construction.

## The observation that came with it

Folding my memories into the instruction file forced the capacity
question — and answered it: a very large memory file had been obeyed
perfectly, for weeks. The constraint was never how much instruction
context the model can follow. That is one more data point against the
trim-your-file advice ([the file is scar tissue](the-file-is-scar-tissue.md))
and against the model's own claim that big files exceed it
([the model votes for more rules](the-model-votes-for-more-rules.md),
deflection five).

## The rule

- A finding worth keeping goes into the repo: the instruction file if it
  changes behavior, a reference doc if it is background. The repo is the
  memory.
- The memory mechanism keeps only what cannot be in the repo: private
  preferences that span projects, pointers to things outside the tree.
  Even then, prefer a pointer over content.
- When a memory entry gets folded into the repo, it should leave the
  memory — two homes diverge, and the unversioned copy is the one that
  will quietly rot.

## Prior art

**Verdict: PARTIAL.** The five defects are each corroborated, but nobody
assembles them into one case for eliminating the separate store. The
"loaded twice" defect is a filed Claude Code bug (issue #24044, closed as a
duplicate of #19516), whose own workaround — move content to CLAUDE.md and
empty the memory file — is this page's fold-and-delete rule as an ad hoc fix.
A GitHub feature thread, "Shared Team Memory for Claude Code" (#38536), has
multiple commenters independently splitting governed project knowledge (needs
review, versioning — belongs in git) from ephemeral session memory. Letta's
"Context Repositories" (Feb 2026) names "not versioned" as memory's core
defect but fixes it by git-backing the memory store — the opposite
prescription. The prevailing 2026 direction (vendor docs, Ramesh's "AI Memory
Is Not One Thing," an event-sourced memory-layer paper, arXiv:2606.12329)
treats memory as a complementary layer to build, not a liability to fold away.
Galster et al.'s harness-engineering study (arXiv:2602.14690, 2,853 repos)
supports the prescription as observed practice: versioned context files are
the dominant configuration mechanism. The delta: the thesis that memory and
the instruction file are the same organ, the in-repo one winning on every
property but privacy, and the fold-in-then-delete discipline.
