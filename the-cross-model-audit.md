# The cross-model audit

*Written 2026-07-30.*

**Claim:** transcripts can tell you when your model changed. They cannot
tell you whether its work was bad. For that, re-check the suspect period's
claims against the code — using a different model. "The output is worse"
and "the supervision costs more" are different problems with different
fixes, and mixing them up benches models for the wrong reason.

## The incident

A week felt slow. Commits halved. Two writeups about unverified claims
landed in three days. I suspected the newly adopted model was simply worse
than the old one, and switched back.

Session transcripts record the model on every message. Mining them gave the
timeline in minutes: the old model's last day, the new model's first day,
and the fact that the slow week ran almost entirely on the suspect. That
part has precedent (see below). What the timeline cannot answer: was the
shipped work actually bad?

## The method

1. **Timeline.** Mine the model ids from the transcripts. Line them up with
   commit rate and known incidents.
2. **Window.** Mark the suspect period. List everything that merged in it.
3. **Audit with a different model.** Read-only review agents on another
   model re-check the window's claims against the code: every decision
   record, every "done" note, every commit-message claim, every recorded
   root cause. Do not let the suspect grade its own homework — this is the
   one place model diversity is not optional.
4. **Re-run the checks.** Every test count and pass/fail figure recorded in
   the window gets reproduced by an actual run, not trusted.
5. **Two verdicts, not one.** Output quality: did anything shipped fail the
   re-check? Supervision cost: how many corrections did the human make,
   counted from the transcripts?

In my case: zero code defects across ~60 re-checked claims, every recorded
number reproduced, and all confirmed problems were documentation drift. The
model's output was fine. What had gone up was my correction load per
change. Those two findings call for different responses, and without the
audit I would have made the wrong call for the wrong reason.

## Prior art

- Stella Laurenzo, anthropics/claude-code#42796 (~2026-04). Mined 6,852
  session files, built a dated regression timeline, correlated it with a
  58% commit-rate drop. The strongest precedent for the mining half. Uses
  behavioral signals rather than the per-message model id.
- lucemia/claude-session-analyzer. Turns that mining approach into a
  reusable tool.
- Model comparison benchmarks. They compare models on synthetic tasks, not
  on a real project's already-shipped work.

**What I think is new:** closing the loop — re-checking the suspect
window's claims with a different model, so the verdict separates output
quality from supervision cost.
