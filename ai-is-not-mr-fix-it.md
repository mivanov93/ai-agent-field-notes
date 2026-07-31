# AI is not Mr. Fix-IT

**Claim:** there is no incantation that makes a model solve anything.
"Fix it," repeated in a loop, does not converge on a solution to an
arbitrary problem — it produces a new, confident, wrong answer each pass,
and when you bolt expensive machinery onto the loop (deep research, a bigger
model, more agents) it produces the same non-answer at many times the price.
Some problems the model cannot solve no matter how you phrase the ask. The
parts it structurally cannot supply — the decomposition, the missing fact,
the reframe, the check — are yours. It is a powerful tool, not a contractor
you can hand the whole job.

## The incident

When my project's writing had gone to mush, I tried to research my way out.
A large deep-research pass came back with a complete catalogue of confident,
wrong advice: every project has this problem; remove your rules; add more
rules; clean up later; add more checks. Every answer was an amount of
something I had already tried — none of them was the cause. The pass cost a
great deal and moved nothing. The insight that actually fixed it came from
me, and once I had the hypothesis the confirmation was already lying in the
data. The research had been circling the question, not leaving it.

Same shape, smaller: a bug that "fix it, try again" will not close. Each run
is confident and different, and none is right, because nothing tells the
model when it is right ([a gate you can fail](a-gate-you-can-fail.md)).
Looping the ask does not add the missing information. It just spends.

## Why the loop doesn't converge

"Fix it" assumes the gap is effort. Usually it is not. The gap is a
hypothesis the model keeps orbiting and never lands on
([the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)),
a fact that lives nowhere in its context, a check it has no way to run, or a
limit of the model itself
([the model doesn't know itself](the-model-doesnt-know-itself.md)). None
of those is closed by asking again, louder, or with a more expensive model.
Money spent on the same request buys more confident restatements of the same
non-answer — sometimes an enormous amount of it.

## The rule

Treat the model as a tool with an edge, not an oracle. The job is the part
it cannot do for itself: state the real problem, supply the missing
knowledge, hand it a reframe when it is stuck on the wrong axis, and build
the check that tells it when it is right. Nearly every "you can't just ask
the model to ___" in this repo is a special case of this one — you can't ask
it to be cheaper ([you can't ask for cheaper](you-cant-ask-for-cheaper.md)),
to grade itself, to know its own limits, to find the hypothesis it is
missing. When a loop stops converging, stop looping: change the problem, not
the number of attempts.

## Prior art

**Verdict: PARTIAL.** The narrow result is KNOWN — intrinsic self-correction
fails without external feedback (Huang et al., arXiv:2310.01798; Kamoi survey,
arXiv:2406.01297). Each other prong has separate support: a CHI 2025 study,
"No Evidence for LLMs Being Useful in Problem Reframing" (arXiv:2503.01631),
directly backs the reframe prong (and this repo's
[missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md));
a "$47K autonomous-loop" postmortem (2025) is the money-burn incident — more
agents made it worse, not better; "intelligence does not compose linearly"
practitioner writing covers the bigger-model prong. The delta: the four-part
taxonomy of what only the human supplies — decomposition, missing fact,
reframe, the check — stated as one irreducible set, and "more money or
machinery doesn't substitute" across all three escalation axes (deeper
research, bigger model, more agents) as a single principle. This is the
umbrella; much of the rest of this repo is its instances.
