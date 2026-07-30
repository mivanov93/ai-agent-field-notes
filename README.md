# Agent field notes

Notes on making AI coding agents behave. They come from months of running a
real project — a WebRTC project in Go with a TypeScript web client — almost
entirely through AI coding sessions. Each note started as a real incident:
something went wrong even though the right guidance was in the model's
context. Each note ends with something enforceable — a check, a lint, a
ritual — not just advice.

Each finding is one I could not find published prior art for — in whole,
or in the precise part the page claims. Each page cites the closest work I
found and says exactly what I think is new. The full search is in
[PRIOR-ART.md](PRIOR-ART.md).

**One rule for this repo:** "I have not found prior art" does not mean
"first". The searches were a handful of research agents over public
2024–2026 material. If you know earlier work for any claim, open an issue.
The claim becomes a citation. That is how this repo is supposed to work —
and it applies to me too: page 8 partially corrects page 6, because I
measured my own repo and half of my original claim did not survive.

## The findings

| # | Finding | One line |
|---|---------|----------|
| 1 | [The decision drain test](01-the-drain-test.md) | Collect the human's pending decisions behind one tag and ask them in one batch per session. If the batch grows instead of shrinking, the process failed — stop adding structure. |
| 2 | [The hardlink hazard](02-hardlinked-node-modules-hazard.md) | Sharing `node_modules` between agent worktrees with hardlinks breaks isolation: build caches share storage, so parallel agents corrupt each other's runs. |
| 3 | [The link rule](03-the-link-rule.md) | When an agent says "X shows Y", X is usually a real measurement. The error is in the jump from X to Y. Checking that jump usually takes one command. |
| 4 | [The cross-model audit](04-cross-model-audit.md) | Transcripts tell you when your model changed. To learn whether its work was actually bad, re-check the claims with a different model. |
| 5 | [The rule-efficacy pipeline](05-rule-efficacy-pipeline.md) | Instruction files only grow. Transcripts can show which rules the current model still breaks, so pruning becomes data instead of guessing. |
| 6 | [Vocabulary control](06-vocabulary-control.md) | Ban the model's metaphors where they collide with your domain terms. Check new terms for collisions. When a rule is broken while in context, turn it into a lint. Scoped to meaning bugs — page 8 says why. |
| 7 | [The demonstration reflex](07-the-demonstration-reflex.md) | Ask an agent a question about its tools and it may answer by running the tools, at full cost. A question deserves prose; a demo needs a price and a yes. |
| 8 | [Bans rotate the vocabulary](08-bans-rotate-the-vocabulary.md) | Ban an AI's invented words and new ones appear within days. The words are compression devices, and the instruction file's own rules are the mint. Fix the pressure; enforce mechanically. |
| 9 | [The dirty house and the clean room](09-the-dirty-house.md) | Whatever your corpus does, the model will do more of — mine outweighs its rules 880 to 1. Cleaning it needs a reader/writer barrier: the writer never reads the text being replaced, and the checker may see both sides because judging doesn't write. Designed, not yet run. |
| 10 | [The model votes for more rules](10-the-model-votes-for-more-rules.md) | Ask the model how to fix the model and it recommends what doesn't work: more rules on itself, "every codebase looks like this", "clean from now on, old mess later". No malice — it can't see its own violation rate. Demand measurements and refutations, not advice. |

## Where these came from

The method behind all of them is simple. When work ships wrong despite
green checks, ask why the checks missed it — not why the bug happened.
Then turn the answer into a new check. The method itself is not new: Google
SRE says fix the system, not the people; QA calls it escaped-defect
analysis; Mitchell Hashimoto's AGENTS.md is a famous failure log. These
notes are what fell out of applying it hard for a month and then checking
what the field already knew.

## Neighbors

This repo sits beside — and cites — HumanLayer's 12-Factor Agents, Martin
Fowler's "Patterns for Reducing Friction in AI-Assisted Development", the
Ghostty failure-log pattern, METR's task-horizon work, and the 2025–26
field-notes genre. What is different here: each practice comes with the
incident that caused it, a way to enforce it, and the prior art I found.

---

Mihail Ivanov, first public draft, 2026-07-30. [MIT license](LICENSE).
