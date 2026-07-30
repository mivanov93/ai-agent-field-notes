# Memory belongs in the repo

*Status: not separately searched; the agent-memory genre is large and the
closest neighbors are noted at the end.*

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

Not separately searched. The agent-memory genre is enormous
(MemGPT/Letta, memory MCPs, every harness's built-in mechanism) and
universally treats memory as a feature to add rather than a liability to
scope; the "stale entries quietly lie" finding from the agent-repo
literature (see PRIOR-ART.md) is the nearest published caution. The
argument here — that memory mechanisms and instruction files are the same
organ, and the in-repo one wins on every property except privacy — I have
not seen stated; a dedicated search should check it.
