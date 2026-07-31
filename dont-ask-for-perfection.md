# Don't ask for perfection

*Status: searched 2026-07-31. The over-engineering effect is documented; the
causal-versus-correlational framing and the convert-or-delete rule are the
deltas.*

**Claim:** asking a model for perfection makes the work worse. "Highest
quality", "impeccable", "extreme performance" produce over-engineered
solutions and ornate prose — because quality words are causal for a human
and correlational for a model. A human routes "perfection" through taste.
The model routes it through association, and in its training data the
vocabulary of maximal quality co-occurs with maximal ceremony.

## The asymmetry

Ask a senior human for their highest-quality work and you get their
judgment applied harder: often simpler code, fewer moving parts, the
right thing stripped of the unnecessary — because their model of quality
is causal, a theory of what makes software good. Ask a model and the
quality words shift its output toward what "highest quality" sounds like:
more abstraction layers, more defensive machinery, more configuration,
more patterns, more superlatives in the prose. It performs thoroughness.
The request selects the aesthetic of quality, not the substance —
intuition trained on humans transfers exactly wrong.

The deeper reason is that "perfection" is a symlink to a target that exists
only in your head — the full specification of what good means for this
project. You can dereference that pointer; the model cannot. Hand it the
symlink and it resolves to the generic file its training says "perfection"
points at: ceremony, layers, ornament. So you cannot just tell it what you
want — you have to pour the requirements out. The thing the word points to
never leaves your skull unless you write it down.

## The incident

My harness's memory profile rendered my engineering bar as superlatives —
"perfection", "impeccable", "impenetrable", "extreme" — and loaded them
into every session for weeks
([the model's model of you](the-models-model-of-you.md)). The measurable
result was not higher quality. It was over-engineering and ornate prose:
speculative hardening that became an attack surface, invented machinery,
dense writing. The evidence is written into my instruction file as its
entire corrective half: "quality is subtractive here — corrections remove
code", "more machinery is not more quality", and a scar list of deleted
model-built systems — a 64KB "graceful" drain buffer that was a CPU-abuse
vector, a hand-rolled rate limiter, a whole subsystem nobody asked for.
Every one of those was the model being maximal at me, as requested.

## The rule

Every quality adjective converts to a constraint, a budget, or a test —
or it gets deleted:

- "Impeccable security" → validate inputs, fail closed, tear down on
  malformed. Decidable.
- "Extreme performance" → zero allocations on the measured hot path;
  simplest correct thing everywhere else. Measurable, and bounded — the
  second half matters as much as the first.
- "Perfect reliability" → the specific failure modes handled, and a
  deliberately-absent list for the ones accepted. Enumerable.
- The test for any remaining quality word: can a session tell whether it
  complied? If not, the word is register, and register is what gets
  mirrored ([the dirty house](the-dirty-house.md)) — not obeyed.

The deliberately-absent list deserves special mention: writing down what
the project intentionally does NOT do ("no clustering, no video, no
speculative hardening") turns out to restrain a model far better than any
superlative motivates it — it is the one place where quality can be
stated as a boundary instead of an aspiration.

## Prior art

**Verdict: PARTIAL.** The effect is documented and the fix has vendor
convergence. Max Woolf's "write better code" experiment (2025) — this page's
existing neighbor, now verified — shows Claude 3.5 spontaneously going
"enterprise," adding cutting-edge optimizations and redundant machinery when
iteratively asked to improve. OpenAI's GPT-5 prompting guide (2025)
independently prescribes the fix: convert a superlative ("world-class") into a
self-authored rubric before executing, and it cites Cursor's production finding
that unconstrained quality instructions produced worse output, fixed by an
enumerated constraint rather than a better adjective. The persona-prompting
line (arXiv:2512.05858) confirms expert personas don't reliably help;
verbosity/length bias in the LLM-as-judge literature is the mechanism-level
reason quality and ceremony co-occur in training data. What no source states:
the causal-for-humans / correlational-for-models framing of quality words, the
generalization to standing-instruction superlatives baked into a memory or
config file, and the convert-or-delete rule with the deliberately-absent list
as the one place quality can be a boundary. Those are the deltas.
