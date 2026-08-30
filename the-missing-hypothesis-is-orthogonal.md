# The missing hypothesis is orthogonal

*Written 2026-07-31.*

**Claim:** when something is wrong, the model usually cannot form the
hypothesis that fixes it — even fed all the data. Its proposals are plus
or minus on whatever quantity your question named. The sign flips freely:
more rules, then fewer rules, then more again. The variable never does.
The fix that works usually lives on a different axis entirely, and
finding that axis is the human's job.

## The shape of it

You need a car. The model offers you different horses. Eventually it
offers you walking — zero horses is still an answer on the horse axis. It
cannot think of the car, and it will never tell you to sell the stable,
because the stable is the frame the whole conversation stands in. (Yes,
the old faster-horses line — but the stable is the part that matters: the
orthogonal fix usually means abandoning infrastructure the context treats
as given, and that move the model will not initiate.)

The oscillation is the diagnostic. The model does not always argue for
more machinery — it argues for more, then for none, then for more again,
each with confidence. What it never volunteers is an alternative. If
every answer you are getting is an amount of the same thing, you are
watching interpolation, not diagnosis: the model explores the axis the
question handed it, and a reframe is not an interpolation.

## The evidence

My instruction-file problem collected the full set: add more rules, gate
me harder ([the model votes for more
rules](the-model-votes-for-more-rules.md)); remove your rules, other
repos have none; trim the file, it is too big. Every proposal was a
quantity of rule. The fix that worked was not a quantity of rule at all —
it was a different variable: change what the writer reads
([the clean room](the-clean-room.md)). The same shape a week earlier: a
tracker overloaded with pending decisions drew proposals for more files
and more schema, and the working fix was a draining ritual with a kill
criterion ([the decision drain test](the-decision-drain-test.md)) —
again, not an amount of structure.

## The asymmetry that makes it workable

The model could not originate either diagnosis — and it verified each
one instantly once I supplied it, then found the mechanism evidence
faster than I could have. So shape the collaboration accordingly:

- Hypotheses come from you. Verification, measurement, and refutation
  come from the model — that direction it runs at full speed.
- Bring your own hypothesis to research too. A search aimed at "find
  what's wrong" returns the model's prior; the same search aimed at
  "confirm or refute this mechanism" returns evidence.
- Expect the missing hypothesis to require abandoning something the
  conversation treats as given. The model will not propose selling the
  stable; check yourself whether the stable is the problem.

## Prior art

**Verdict: PARTIAL.** The territory is more populated than the note first
allowed. The CHI 2025 study "No Evidence for LLMs Being Useful in Problem
Reframing" (arXiv:2503.01631, N=280) found LLM help gave no reframing benefit
and widened the skilled/unskilled gap. IDEAFix (arXiv:2606.00875) shows
defixation prompts can nudge novelty but "solutions remain bound within a
shared semantic space" — you move the dial, the space does not change.
Franceschelli & Musolesi ("On the Creativity of LLMs," AI & Society 2024)
argue autoregressive models are confined to combinational and exploratory
creativity, with transformational creativity — changing the conceptual space —
out of reach; and an LLM-specific Einstellung study (arXiv:2306.11167) tests
the fixation ancestor directly. None names the specific diagnostic: the sign
of the proposed fix oscillates while the variable never changes, and that
oscillation is the tell that the model is interpolating within the question's
frame. That, plus the originate/verify asymmetry as operating guidance, is the
delta.
