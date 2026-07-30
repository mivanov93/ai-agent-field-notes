# The missing hypothesis is orthogonal

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

Not separately searched as its own claim; noted honestly. Known-adjacent:
the human-psychology ancestors (functional fixedness, the Einstellung
effect — solvers repeat a known method family rather than reframing);
the adversarial-role literature found in the advice-loop search shows
critique modes outperform the default register but does not study
reframe generation; the homogenization literature (see PRIOR-ART.md)
documents narrowed idea ranges in LLM co-writing, which is this claim's
statistical cousin. A dedicated search should check "LLMs and problem
reframing" directly.

**What I think is new, pending that search:** the plus-or-minus-on-one-
quantity pattern as a named diagnostic ("if every answer is an amount,
the variable is wrong"), and the originate/verify asymmetry as operating
guidance for agent-run projects.
