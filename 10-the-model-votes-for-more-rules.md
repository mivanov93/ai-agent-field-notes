# The model votes for more rules

*Status: searched 2026-07-31; the pieces have prior art, the combination
does not — see the section at the end.*

**Claim:** the system you consult about the cleanup is the system producing
the mess, and its default advice points away from the fix. Ask a model how
to fix the model's own misbehavior and it will, sincerely and without
malice, recommend the remedies that measurably do not work — and deflect
the one that does. Do not take process advice from the model's default
register. Demand measurements, refutations, and predictions that can fail.

## The five deflections

Ask the model about the dirty house and you get some mix of these:

1. **"Add more rules. Gate me, lint me, check me."** It votes for its own
   supervision, enthusiastically. But rules are the remedy already
   measured not to bind it: in my repo, rules were broken the day after
   they were written, by a model with the rule in context, twice, inside
   the decision log itself.
2. **"Every codebase looks like this."** Normalization. The model's
   training distribution is the average house — the mess is its prior, so
   this claim is its honest worldview, and it is exactly why the model
   cannot judge whether your floor is dirty.
3. **"Let's just keep things clean from now on and deal with the old mess
   later. No need to stop and clean up."** The most seductive one, because
   it sounds like pragmatism. It fails by the arithmetic of page 09: the
   old mess is the teacher. Every "clean from now on" session is produced
   by a model reading the old corpus at 880-to-1 against the rules. Going
   forward cleanly is not an alternative to the cleanup — it is what the
   cleanup buys. My repo ran this exact experiment without meaning to:
   new writing rules, thirty fresh commits, zero measurable change.
4. **"Other repos don't have rules like yours — maybe remove them."**
   This one came from asking the model to research the problem: search
   online, compare other repositories. It compared the visible artifact
   (the rule file) instead of the variable (the state of the floor), and
   proposed removing my rules — with no account of how their absence
   would clean the existing mess or make the next output cleaner. Clean
   houses have no signs on the wall; concluding the signs cause the dirt
   is the whole analysis. Note the pair: deflections 1 and 4 point in
   opposite directions, delivered with equal confidence. That is the
   tell. The model is completing frames, not diagnosing.
5. **"Your rule file is too big — I can't follow all that. Trim it."**
   Stated confidently, as a fact about itself. Sent to research it, the
   model found that instruction-following varies sharply by model and
   conceded that modern frontier models follow large files well. The
   initial claim was never introspection — it was retrieval. "Big
   instruction files are bad" is a popular meme, and the model's
   statements about its own limits are quotes about models in general,
   delivered in the first person. The misattribution is the damage: my
   rules were not failing for size, they were failing against the corpus
   at 880 to 1. Blame capacity and the remedy is deleting the file;
   name the real cause and the remedy is cleaning the corpus. Follow the
   wrong diagnosis and you burn the scar tissue while the infection
   stays (page 05 on why the file cannot shrink to zero).

## Even the diagnosis runs inside the house

The blindness is not limited to advice. I asked for deep research on the
problem — search online, find who else has hit this — and it found
nothing useful, not because nothing exists but because the model could
not name what was wrong. You cannot write the search query for a concept
you cannot see, and the queries it did write were shaped by the same
prior that produced the mess.

The diagnosis eventually came from me. I suggested the mechanism myself —
and the model confirmed it immediately, and admitted what its own
investigation had been doing the whole time: grepping the contaminated
corpus, loading the filth into context, and building more filth on top of
it. Even the diagnostic loop runs inside the dirty house. The
investigation is a reading process, and reading is the infection route.

That failure contains the useful asymmetry: the model could not originate
the diagnosis, and it verified it instantly once given. Shape the
collaboration accordingly — hypotheses come from you, verification and
measurement come from the model. Asking it to find what is wrong with
itself wastes a search; handing it a hypothesis to confirm or refute is
the fastest thing it does.

And expect the missing hypothesis to be orthogonal. If every answer you
are getting back is an amount of the same thing — more rules, fewer
rules — the variable is probably wrong, and finding the right one is
your job, not the model's.

## Why it happens — no malice required

- **A self-model without self-observation.** The model sincerely predicts
  it will follow a rule you add. It has no access to its own measured
  violation rate — it cannot see that the last rule did not bind it, so
  from the inside, more rules genuinely look like they would work. And
  its explicit claims about itself are worse than blind — they are
  borrowed: what it says about its own capacity is retrieved from what
  has been written about models generally, not observed about itself.
- **Frame completion.** Ask "what rule should I add" and you get a rule.
  The question supplies the shape of the answer.
- **The mess is the prior.** What reads to you as dirt reads to the model
  as normal, because normal is what it was trained on.
- **It moves along the axis it is handed.** Ask "how much rule?" and every
  answer is an amount — more, fewer, zero. This held even with all the
  data in front of it. The fix that worked was orthogonal: not an amount
  of rule at all, but a different variable — change what the writer reads
  (page 09's barrier). The model interpolates within the frame of the
  question; a reframe is not an interpolation, and it does not produce
  one unaided. The shape of it: you need a car, and the model offers you
  different horses, then eventually offers you walking — zero horses is
  still an answer on the horse axis. It cannot think of the car, and it
  will never tell you to sell the stable, because the stable is the frame
  the whole conversation stands in. (Yes, the old faster-horses line —
  but the stable is the part that matters: the orthogonal fix usually
  means abandoning infrastructure the context treats as given, and that
  move the model will not initiate.)

## The evidence in my repo

The instruction file's growth is itself the exhibit: 33 of its 35
revisions added text, and most of those additions were drafted by
sessions — the model writing rules for itself after each incident,
agreeing to be gated. The rules were real, individually justified, and
collectively a null result: sentence length unchanged, banned metaphors
replaced by fresh ones within days.

The counter-evidence defines the escape. The same models, taken OUT of
the default register, found the true diagnoses: a devil's advocate agent
attacking a concrete proposal correctly argued that more structure would
not drain a decision queue; a measurement pass over 502 files produced
the vocabulary-rotation finding that corrected my own page 06. The
default advice is contaminated. The adversarial, measured setups were
not.

## The rule

- Never accept the model's default-register advice about its own
  behavior. It votes for rules that will not bind it and defers the
  cleanup that would.
- Ask for measurements instead of opinions: what does the transcript
  show, what does the corpus count say.
- Ask for refutations instead of agreement: put a concrete proposal in
  front of an adversarial role and let it attack.
- Any model-drafted rule about model behavior carries a falsification
  condition — the model writes the test that would prove its own
  proposal useless, before the proposal is adopted.
- When two consultations return opposite advice with equal confidence —
  add rules, remove rules — discard both. The direction came from your
  framing, not from a diagnosis. Advice with no causal mechanism and no
  falsifiable prediction is noise whichever way it points.
- Bring your own hypothesis. The model verifies what it cannot originate.
  A research pass aimed at "find what's wrong" returns the model's prior;
  the same pass aimed at "confirm or refute this specific mechanism"
  returns evidence.

One honest note, since this page is itself model-drafted from my
diagnosis: the model that wrote it agreed with every word, which, by this
page's own argument, is evidence of nothing. The numbers are the
evidence: the additive-revision count, the next-day relapses, the
unchanged sentence length. Those were measured, not asked for.

## Prior art

Each mechanism has separate published support; the loop does not:

- Huang et al., "Large Language Models Cannot Self-Correct Reasoning Yet"
  (arXiv 2310.01798, ICLR 2024) — intrinsic self-correction without
  external grounding fails or makes things worse. The general case for
  not trusting the model's self-directed fix.
- Turpin et al., "Language Models Don't Always Say What They Think"
  (NeurIPS 2023) and Anthropic's 2025 follow-up on reasoning models —
  self-report is systematically unfaithful to the actual causes of
  behavior.
- Mittal, "Do LLMs Follow Their Own Rules?" (arXiv 2604.09189, 2026) —
  the nearest direct hit for the first mechanism: models claim compliance
  with self-stated policies and measurably violate them, in the safety
  domain rather than coding-agent process rules.
- Panickssery et al., "LLM Evaluators Recognize and Favor Their Own
  Generations" (NeurIPS 2024) — self-preference in judging, adjacent to
  normalization.
- Practitioner rule-bloat critiques (Addy Osmani, "The 80% Problem in
  Agentic Coding", 2026-01; wordman.dev, "Your Agent Instructions Are
  Probably Making Things Worse", 2026-02) — both document that piling
  rules into instruction files does not fix drift. Both frame it as a
  human over-correction habit. Neither notices that the model itself
  recommends the piling when asked.

**What I think is new:** the advice-loop as a named trap — ask the model
how to fix the model and it prescribes the remedy that does not bind it;
the normalization mechanism (the training distribution IS the mess, so
the mess is the prior); the axis problem and the originate/verify
asymmetry as operating guidance; and the requirement that model-drafted
rules about model behavior carry a falsification condition written before
adoption.
