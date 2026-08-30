---
name: deep-research-cheaper
description: Use when the user wants a deep, multi-source, fact-checked research report AND wants the fan-out to run on cheaper models to save cost. Same harness as deep-research (fan-out web searches, fetch sources, adversarially verify claims, synthesize a cited report) but only the scope and synthesize steps use the session model; search runs on Haiku, fetch and verify run on Sonnet. BEFORE invoking, if the question is underspecified, ask 2-3 clarifying questions to narrow scope, then weave the answers into the research question.
---

# Deep Research (cheaper variant)

A fork of Claude Code's built-in `deep-research` workflow: same five
stages — Scope → Search → Fetch → 3-vote adversarial Verify →
Synthesize — with the fan-out pinned to cheaper models, the verify cap
at 25 claims, and a claim whose verifier agents errored reported as
*unverified* instead of counted as *refuted*.

| Stage | Calls | Model |
|-------|-------|-------|
| Scope | 1 | session model (inherited) |
| Search | 5 | Haiku |
| Fetch | ≤15 | Sonnet |
| Verify | ≤75 | Sonnet |
| Synthesize | 1 | session model (inherited) |

Verify is ~77% of the agents, so pinning it to Sonnet is where the saving comes
from. Report quality lives in Synthesize, which stays on the session model.

## When to use

- The user wants a deep-research report but flags cost, or is running the session
  on an expensive model (e.g. Opus) and does not want ~95 verify/fetch calls on it.
- Prefer the built-in `deep-research` when you specifically want the whole harness
  on the session model (e.g. a hard question where even verify should be top-tier).

## How to run

The workflow script lives beside this file. Launch it by path, forwarding the
research question as `args`:

```
Workflow({
  scriptPath: "<path-to-this-folder>/deep-research-cheaper.js",
  args: "<the research question — refined and self-contained>"
})
```

`scriptPath` runs that file directly, so the pinned models take effect. The run
streams progress under `/workflows`; you are notified on completion.

## Tuning

The models and limits are plain constants at the top of the script — edit
`MODEL_SEARCH` / `MODEL_FETCH` / `MODEL_VERIFY` to re-tier, or `MAX_VERIFY_CLAIMS`
(default 25) to cut the number of verify votes (3 per claim). `VOTES_PER_CLAIM`
cannot go below 3 without breaking the "≥2 of 3 refutes to kill" quorum.

From production use: verified findings concentrate on ~2-3 claim
clusters per run regardless of how many sub-questions the brief lists —
ranking spends the verify slots on whichever angle produced the
crispest primary-text claims. Scope each run to 3-4 clusters; a cap of
16 held up well at that scope.
