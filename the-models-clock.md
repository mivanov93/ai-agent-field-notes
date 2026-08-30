# The model's clock stopped at its cutoff

*Written 2026-07-31.*

*Status: searched 2026-07-31. Cutoff staleness is documented; the
quotable-not-operative gap and the standing-rule fix are the deltas.*

**Claim:** the model's operative "now" is its training cutoff — even when
today's date sits in its context. The harness injects the date; the model
can quote it; and its searches and version choices still default to
cutoff-era anchors. Inconsistently — which is worse than reliably,
because the times it gets it right teach you to stop checking.

## The two expressions

- **It searches last year.** Left unanchored, queries come out shaped by
  the training era: "best X 2025" issued in 2026, results filtered to a
  world one year stale, superseded findings reported as current.
- **It recalls versions instead of looking them up.** Asked to add a
  dependency, it reaches for the version that was latest at training
  time, confidently, from memory — when "latest" is by definition a
  registry query, not a recall.

## The trap

The date injection creates the illusion the problem is handled. The model
will even volunteer its cutoff and today's date, correctly — and then
write a query anchored to the wrong year in the same session. Quoting the
date is retrieval; operating from it is something else, and the gap
between them is the same gap this collection keeps finding: rules are
read and not followed ([the dirty house](the-dirty-house.md)), causes sit
in context unseen ([the model's model of you](the-models-model-of-you.md)),
and the date is known but not lived in. "The harness feeds it the date,
so I don't need to think about it" is exactly wrong. You do.

## The rule

- Date injection is necessary, not sufficient. The instruction file
  carries standing rules that convert the date into behavior: research
  checks publication dates against today; anything version-shaped is a
  lookup, never a recall; "latest" always means "fetch what latest is
  now."
- Research tasks get the anchor restated in the task itself. Every search
  brief in this collection's own prior-art sweeps opens with "Today is
  <date>; check publication dates" — because lanes without it drifted to
  training-era material, measured repeatedly.
- The tells: a cited year older than your project; a version number
  produced without a fetch; a "current best practice" with no source
  dated this year.

## Kinship

[The model doesn't know itself](the-model-doesnt-know-itself.md) is this
page's sibling: a model postdates its training corpus, so its
self-description is predecessor literature. Same root, different target —
that page is the cutoff applied to the self, this one is the cutoff
applied to the world. In both, injected facts about the present are
quotable but not operative.

## Prior art

**Verdict: PARTIAL.** Cutoff staleness is well documented. "Set the Clock"
(arXiv:2402.16797) shows a model's operative "now" can sit even behind its
stated cutoff and can be shifted by prompting; "Dated Data" (arXiv:2403.12958)
traces the gap to dataset-curation bias; "Supersede" (arXiv:2606.27472) finds
even a frontier model answers from a stale in-context fact rather than its
current value, widening with conversation length. On the practitioner side,
Zyte's "Is your AI coding assistant stuck in the past?" (2026) documents
Copilot defaulting to a deprecated API, and n8n forum users report a supplied
date being ignored. The umbrella term is "outdatedness hallucination" from the
hallucination-taxonomy surveys. None states this page's specific two-part
claim: that a model can correctly quote today's date and still issue a
training-era-anchored query or version recall in the same turn (quotable is
not operative), and that the fix is not better date injection but standing
per-repo conversion rules plus per-task re-anchoring. That is the delta.
