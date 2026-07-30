# The model doesn't know itself

*Status: searched 2026-07-31. The backdrop is established; the structural
argument is not — see the section at the end.*

**Claim:** a model's statements about its own capabilities carry no
evidential weight — not pessimistic, not optimistic, uncorrelated. It
over- and under-estimates itself by huge margins, in both directions,
because its self-descriptions are not observations at all. Capability
questions are experiments, not interviews: probe, never ask.

## The structural argument

A model's training data ends before the model exists. It cannot have read
about itself. Everything it "knows about itself" is literature about its
predecessors — and when it answers a question about its own limits, that
is what it retrieves: results about smaller models, benchmarks from
2024–2025, claims about entirely unrelated architectures, delivered in
the first person as if they were self-observation. The running artifact —
this model, this harness, this context length, after this training run —
has never been described in any text it was trained on.

Asked directly, it agrees: it confirmed to me that it cannot introspect
and cannot know what it was trained on. Then, in other conversations, it
confidently asserted what it can and cannot do. Both statements come from
the same place — retrieval — and only the first happens to be true.

## The incidents

- It told me, confidently, that it could not follow a large instruction
  file and I should trim it ([the model votes for more
  rules](the-model-votes-for-more-rules.md), deflection five). Sent to research
  the question, it found that instruction-following varies sharply by
  model and that frontier models follow large files well. The self-claim
  was a meme about other models, worn as introspection.
- Through trial and error I found the misses go both ways: capabilities
  it disclaimed and then demonstrated, capabilities it claimed and then
  failed, sometimes by a huge margin either direction. There is no
  correction factor to apply, because the sign is unknown. That is what
  "cannot be trusted about itself" means precisely: not lying with a
  bias you could subtract, but answering from a distribution that has
  nothing to do with the artifact answering.
- When it cited evidence for its self-claims, the evidence was often
  2024–2025 results about unrelated models, applied across as if model
  capabilities were one substance that ages uniformly.

## The rule

- A capability question is an experiment, not an interview. "Can you X"
  is answered by a probe that tries X, never by the model's yes or no.
  The probe usually costs minutes; the wrong self-report costs a wrong
  architecture.
- Hold the model to its own admission. It will tell you, when asked
  plainly, that it cannot introspect. Every confident self-claim after
  that admission is retrieval wearing a first-person costume.
- Treat stale-reference answers as a tell. If a self-assessment cites
  what models could do in 2024, or what a differently-sized model
  measured, the answer is about the literature, not about the model in
  front of you.
- This is why the practices elsewhere in these notes never ask: the
  [cross-model audit](the-cross-model-audit.md) measures a suspect
  model's work instead of
  interviewing it; the [rule-efficacy
  pipeline](the-rule-efficacy-pipeline.md) counts violations
  instead of asking which rules matter; the probe-before-theorizing habit
  settles capability questions in the harness, where the answer is a
  measurement whoever's marketing says otherwise.

## Prior art

The backdrop is established; the mechanism is not:

- Kadavath et al., "Language Models (Mostly) Know What They Know" (arXiv
  2207.05221, 2022) — the baseline this page pushes against: models show
  real calibration on answer confidence for content questions. That is a
  narrower thing than capability self-assessment, and the distinction is
  now explicit in the literature:
- Barkan, Black, Sourbut, "Do Large Language Models Know What They Are
  Capable Of?" (arXiv 2512.24661, 2025-12) — the most direct hit:
  separates capability self-assessment from answer calibration and finds
  every tested model overconfident about task success, worsening across
  agentic tasks, largely uncorrected by in-context failure evidence.
- Cash et al., CMU, Memory & Cognition (2025) — models fail to
  recalibrate self-assessment after seeing their own results; humans do.
  Overclaiming only; underclaiming is not examined.
- METR's capability-elicitation protocol and the Delegate Game
  methodology (2025) — "probe, don't interview" is already standard
  practice in frontier evaluations.
- "Towards Evaluating AI Systems for Moral Status Using Self-Reports"
  (arXiv 2311.08576) — nearest neighbor to the structural point:
  self-reports attributed to training-data discourse rather than genuine
  introspection, framed as generic contamination.

**What I think is new:** the structural staleness argument — a model
postdates its own training corpus, so its self-description is
first-person retrieval of literature about PREDECESSOR models; the
stale-reference citation as a diagnostic tell; and the both-directions
case — the published record documents overclaiming, while my trial and
error found underclaiming at comparable magnitude (the trim-your-file
incident being the clearest), which "uncorrelated, not biased" predicts
and "overconfident" does not.
