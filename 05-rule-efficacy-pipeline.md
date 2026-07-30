# The rule-efficacy pipeline

*Status: method described; first measurement run pending. This page makes
the smallest claim of the seven.*

**Claim:** instruction files accrete rules and only ever grow — but session
transcripts contain enough evidence to measure **which rules' failure modes
still fire, per model**, turning rule pruning from vibes into data.

## The problem

The failure-log pattern for instruction files is now well known: every rule
traceable to an incident. What nobody closes is the other half of the loop.
Rules accumulate; instruction-following degrades measurably as files grow
(the compliance cliff is benchmarked — see prior art); and a rule written
for one model's failure mode may be a pure salience tax on its successor.
The only pruning method in circulation is asking the model which rules it
notices — self-report, from the system being measured.

I hit the motivating case directly: a week of suspected model regression
produced several new defensive rules, and the natural question — "can these
be removed now that the model changed back?" — had no data behind it. Worse,
I could show at least one rule being violated *while it sat in the model's
context*, which is precisely the evidence exhortation-based rule-keeping
cannot see.

## The method

1. Archive session transcripts append-only, including subagent traces —
   they are the ground truth of what the model actually did, and they decay
   (harnesses garbage-collect them) unless deliberately kept.
2. For each instruction-file rule, define its violation signature — the
   greppable/classifiable trace a violation leaves (a banned word in output,
   a forbidden command shape, a gate claim without the gate's run).
3. Sweep transcripts per model era; count firings per rule.
4. Rules that never fire for the current model move to a reference doc with
   their incident links intact — retrievable, no longer spending the
   instruction budget. Rules that still fire stay, with fresh evidence.

## Prior art

- Mitchell Hashimoto's Ghostty AGENTS.md and the "failure log" pattern
  (ShipWithAI writeup, 2026-04) — the accretion half, incident-tagged
  rules, widely imitated.
- Distyl AI's IFScale benchmark (NeurIPS 2025 workshop) — instruction
  compliance degrading with rule count; the reason pruning matters.
- Informal pruning by model self-report appears in the CLAUDE.md-curation
  genre; no measurement pipeline over saved transcripts was found.

**The delta:** the measurement loop — violation signatures, per-model
firing rates from archived transcripts, evidence-based pruning. First data
from this project's archive is the obvious next page.
