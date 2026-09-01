# The model can't taste stale research

*Written 2026-09-01.*

*Scope: one incident, my own session, 2026-09, in Claude Code on a
current 2026 model that had today's date in context and used it
correctly. The mechanism is my reading of it; the fact is what the model
did with the 2023 sources.*

**Claim:** a model cannot judge whether an old finding is still valid.
Ask it a research question in a fast-moving field and it will pull a
result from years back — correctly dated, correctly cited — and fold it
into a present-day analysis as current fact, *while knowing the date is
2026 and knowing the finding is old*. The failure is not the calendar;
it has the calendar right. The failure is that staleness is a judgment
it cannot make. It weights a source by whether it exists, not by whether
what it describes still does. It reads the date on the bread and eats it
anyway, because staleness is a taste it does not have.

## The incident

I was writing about AI watermarking and researching it with the model.
It reached for work from 2023 — watermarking and detection results about
the language models of that year — and applied them to the 2026 question
in front of me as standing fact. But in this field the subject moved out
from under the research. A 2023 result about detecting a 2023 model's
output can be void for a 2026 model: the models changed, so the finding
describes a system that no longer exists. The model cited it anyway,
confidently, as though it were timeless.

And it knew the year. The date was in its context and it used 2026
correctly elsewhere in the same session. This was not [the model's clock
stopped at its cutoff](the-models-clock.md) — it was not searching the
wrong year or recalling a stale version. It had the date right and
reached for the dead result anyway.

## Not the clock

The distinction is the whole point, because the two look alike from the
outside — both end in "old thing treated as current." [The model's
clock](the-models-clock.md) is a wrong *now*: the model's operative date
defaults to its training era, so it searches last year and recalls old
versions, and the fix is to convert the injected date into behavior
("today is X; check publication dates"). None of that applies here. The
date was correct, quoted, and used. The gap is one step downstream: given
a source it *knows* is from 2023, the model cannot discount it for
obsolescence. The clock is the wrong now; this is the wrong *still-true*.
Date injection, the clock note's whole remedy, does nothing for it —
there is no date to fix.

## Why it happens

A citation's existence reads, to the model, as its validity. The model
has no sense of a finding's half-life — no internal variable for "this
was true about a system that no longer exists." Age, to it, is a fact
about the paper, not a discount on the claim. In a slow field that is
often fine; a 1994 result in pure math still holds. In a field whose
subject is the models themselves, the half-life is short and the discount
should be steep, and the model applies none.

There is a recursive edge to it. The model is the field's own product,
trained on that literature, and it is therefore the reader least equipped
to notice the field moved past the paper — the stale result and the
thing reading it were baked in the same oven. It cannot taste its own
staleness, so it cannot taste the source's.

## The rule

- **Obsolescence is the human's judgment; the model will not volunteer
  it.** For any source older than a year or two in a fast-moving field,
  ask outright: does this still hold for current systems, or is its
  subject gone? The model can answer that when asked — it just never
  asks itself.
- **Date the epoch, not the paper.** What matters is not "published
  2023" but "about the 2023 model generation." Anchor a finding to the
  systems it describes, and discount it when those systems are
  superseded.
- **A citation is not a fresh finding.** That the model can name a real,
  correctly-dated source says nothing about whether the source still
  bears weight. Treat citability and current-validity as separate
  columns — the model collapses them.
- **In a fast-moving field, make the discount a standing instruction.**
  "Sources about model behavior older than the current generation are
  suspect until re-confirmed against a current model" turns a judgment
  the model can't originate into one it can follow.

## Prior art

**Verdict: PARTIAL — searched 2026-09-01** (a deep-research fan-out;
its citations were triple-fetched by the run's own verifiers, and I will
hand-confirm the load-bearing two by direct fetch before leaning on them,
since WebFetch was down here). The phenomenon is documented — but almost
entirely in medicine, and the piece I needed most is there: it has been
cleanly separated from the cutoff.

Two purpose-built medical benchmarks isolate the exact failure.
TempoMed-Bench ("Large Language Models Lack Temporal Awareness of Medical
Knowledge," arXiv:2605.13045, 2026) frames the task as knowing *when* a
fact is correct rather than recalling it with a date, and pits the
current guideline against the superseded one: accuracy on the superseded
direction runs only 25–54% of accuracy on current knowledge. "Facts Fade
Fast" / MedChangeQA (arXiv:2509.04304, Findings of EMNLP 2025) takes 512
medical questions whose verdict flipped and finds most models score
*worse* against the updated answer than the overturned one — and it
makes this note's argument for me: the effect is not the cutoff, because
the correct updates predate every model's 2023 cutoff, so a stale
training date cannot explain a preference for the old answer on older
material. That is the "Not the clock" section, independently arrived at,
with numbers.

In the general domain the nearest thing is "nostalgia bias" (FreshBench,
"Is Your LLM Outdated?," arXiv:2405.08460, NAACL 2025): models skew
toward historical training data. But it is framed as a generation-time
bias, not as a judgment a model makes about whether a specific,
correctly-dated finding still holds — which is the gap this note names.

So the delta, NOT FOUND: the failure named *outside* medicine, in a
fast-moving field where the subject changed underneath the research (a
2023 result about a 2023 model applied to a 2026 one), framed as a
source-validity / half-life judgment the model cannot make — distinct
from generation-time nostalgia and from the calendar. Two sub-claims the
sweep tried and could not stand up — that the decline is linear rather
than a step, and that repetition in pre-training drives which verdict is
kept — I am not relying on. Adjacent in this repo: [the model's clock
stopped at its cutoff](the-models-clock.md) (the wrong *now*; this is the
wrong *still-true*), [the model doesn't know
itself](the-model-doesnt-know-itself.md) (the cutoff applied to the self;
this is it applied to the field the model came from), and [it can't be
done is usually out of date](it-cant-be-done-is-usually-out-of-date.md)
(a capability bound to a version; this, a finding bound to a model
generation).
