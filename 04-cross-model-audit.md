# The cross-model audit

**Claim:** when you suspect a new model made your project worse, transcript
mining gives you the timeline — but only a re-audit of the suspect window's
shipped work, performed **by a different model**, separates "the output is
worse" from "the supervision cost more". They need different responses, and
conflating them is how a model gets benched for the wrong reason.

## The incident

A week felt slow. Commit rate had halved; two retros about unverified claims
had landed in three days; I suspected the newly adopted model
was simply worse than its predecessor and switched back.

Session transcripts carry a per-message model id. Mining them produced the
timeline in minutes: the old model's last day, the new model's first, and
the fact that the slow week ran almost entirely on the suspect. So far this
has precedent (see prior art). The question the timeline cannot answer: was
the *shipped work* actually bad?

## The method

1. **Timeline** — mine per-message model ids from session transcripts;
   correlate with commit rate and documented incidents.
2. **Window** — bound the suspect period; enumerate what merged in it.
3. **Cross-model audit** — read-only review lanes run on a *different*
   model re-derive the window's claims against the code: every ADR
   assertion, tracker DONE note, commit-body claim, and recorded
   root-cause, checked claim-by-claim with evidence. (Same-model audit has
   an obvious conflict; the audit of the suspect is the one place model
   diversity is non-negotiable.)
4. **Re-run the gates** — every test-count and pass/fail figure the window
   recorded gets re-produced by an actual run, not inherited.
5. **Verdict in two parts** — output quality (did anything shipped fail
   re-verification?) and supervision cost (how many corrections did the
   human supply, visible in transcripts and retros?).

In the incident, the audit came back: zero code defects across ~60
re-derived claims; every gate figure reproduced; all confirmed findings
were record drift. The suspect model's *output* was exonerated — the real
cost had been human supervision per shipped change. That distinction
changed the decision from "the model is bad" to "the model is expensive to
supervise", which prices differently.

## Prior art

- Stella Laurenzo, anthropics/claude-code#42796 (~2026-04) — mined 6,852
  session files, built a date-stamped regression timeline, correlated with
  a 58% commit-rate drop. The strongest precedent for the mining half
  (using behavioral proxies rather than the literal model-id field).
- lucemia/claude-session-analyzer — generalizes that mining as a tool.
- Model A/B evaluation literature — benchmarks compare models on synthetic
  tasks, not on a real project's already-shipped window.

**The delta:** no found source closes the loop — re-deriving the suspect
window's claims against the code with a different model, so the verdict
separates output quality from supervision cost.
