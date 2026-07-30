# Agent field notes

Practices for making AI coding agents behave, derived from months of running a
real project — a WebRTC project in Go with a TypeScript web client — almost
entirely through AI coding sessions. Every practice here is traceable to a
dated incident where something went wrong despite the guidance in context, and
each terminates in a mechanism (a lint, a ritual, a check), not an exhortation.

This repo contains the six findings I could not locate prior art for, each
written up with its nearest published neighbors cited and the claimed delta
stated precisely — plus a seventh failure-mode writeup added after the sweep.
The full sweep is in [PRIOR-ART.md](PRIOR-ART.md).

**The honesty rule:** "I have not found prior art" is not "first". The sweep
was four parallel research agents over 2024–2026 public material on one
afternoon (2026-07-30). If you know earlier work for any claim, please open an
issue — the claim gets downgraded to a citation, which is how this repo is
supposed to work.

## The findings

| # | Finding | One line |
|---|---------|----------|
| 1 | [The decision drain test](01-the-drain-test.md) | Batch the pending human rulings behind one greppable tag, ask them in one pass per session — and build the process's own falsification condition in: if the batch grows, stop adding structure. |
| 2 | [The hardlink hazard](02-hardlinked-node-modules-hazard.md) | Hardlink-shared `node_modules` between parallel agent worktrees is a correctness hazard, not an optimization: build-tool caches share inodes and un-isolate every tree at once. |
| 3 | [The link rule](03-the-link-rule.md) | When an agent reports "X shows Y", the measurement X is usually real — the failure lives in the unchecked inference to Y, and auditing that link is usually one command. |
| 4 | [The cross-model audit](04-cross-model-audit.md) | To separate "the new model ships worse code" from "the new model costs more supervision", re-derive the suspect window's claims against the code using a different model. |
| 5 | [The rule-efficacy pipeline](05-rule-efficacy-pipeline.md) | Instruction files accrete rules; transcripts can measure which rules' failure modes still fire per model, so pruning becomes data, not vibes. |
| 6 | [Vocabulary control](06-vocabulary-control.md) | Ban the model's pet metaphors where they collide with domain terms, collision-check new coinages, govern the glossary with decision records — and escalate to lint the first time a rule is violated while sitting in context. |
| 7 | [The demonstration reflex](07-the-demonstration-reflex.md) | Asked a question *about* its machinery, an agent tends to answer *with* the machinery, at full price — a conceptual question deserves prose, and a demo is a purchase that needs a stated price. *(Post-sweep addition; no prior-art pass yet.)* |

## Where these came from

The method behind all of them: when work ships wrong despite green gates, the
retro asks why the *gates* missed it, not why the bug happened — and every
lesson must become a machine check or explicitly name the trigger it waits
for. That doctrine has ancestors (Google SRE's automation-over-behavior,
QA's escaped-defect analysis, Mitchell Hashimoto's failure-log AGENTS.md
pattern) — the findings above are what fell out of applying it hard for a
month and then checking which pieces the field already had.

## Neighbors

This repo sits beside — and cites — HumanLayer's 12-Factor Agents, Martin
Fowler's "Patterns for Reducing Friction in AI-Assisted Development", the
Ghostty AGENTS.md failure-log pattern, METR's task-horizon work, and the
2025–26 field-notes genre. The differentiator here is narrow: incidents
attached, mechanisms enforced, prior art named per claim.

---

First public draft, 2026-07-30. No license chosen yet.
