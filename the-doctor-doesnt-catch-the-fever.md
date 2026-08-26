# The doctor doesn't catch the fever

*Status: DRAFT — not yet walked through for publication; prior-art
searched 2026-08-26. One run, one corpus, from my own records; the end verdict
was human — the author and I read the result. The mechanism in the title
is a hypothesis this run cannot isolate, and the claim says which half
is which. Working title.*

**Claim:** a 100-document prose corpus — the kind
[the dirty house](the-dirty-house.md) predicts will re-teach its style to
every session that reads it — was cleaned with **no reading barrier**.
The fixing agents read the sick text directly, guided by a disease
taxonomy built first, and the humans who read the result accepted it.
That is the fact this page records. The mechanism is a hypothesis:
perhaps a labeled specimen stops working as a demonstration; perhaps ten
documents per context is too small a dose to teach; perhaps the gates
simply caught what there was to catch. The run cannot tell these apart.
It does not have to for the method to be worth recording — but nothing in
it is push-button: every artifact passed a human gate before it was
trusted, and the pipeline's real product is that those gates got cheap.

## The patients

A book-length prose corpus a friend wrote: 100 documents, roughly 256
thousand tokens, each building on the previous, multiple files of
broken prose throughout. I worked on it as the editor.

## The image: a hospital with no textbook

A hundred patients and no book describing their diseases. You take your
two best doctors — the frontier models; I tried the junior tier and it
misdiagnosed — and walk the wards with them until each has written one.
You review both, demand fixes, have one doctor merge them, and review
the merge. From that book one doctor distills a DIAGNOSIS document.
Patients are split into groups of ten, one doctor per group: read
DIAGNOSIS first, then bed to bed — diagnose, write a report. The tenth
fever got diagnosed like the first; repetition did not turn fever into
background. Then new doctors, in batches, each carrying a TREATMENT
document — DIAGNOSIS plus the how-to-fix — treat their group; you
inspect the patients and correct TREATMENT; a second pass fixes what the
first missed; next batch. Every batch hands the next a better TREATMENT
document.

## The seven steps

1. **Build the disease file with the model, not from it.** One frontier
   model and I analyzed the corpus together: pinpoint, name, validate.
   The model cannot know what you don't like — I supplied examples,
   walked documents by hand, and corrected the file. Slow, not
   automatic, and the step everything else rides on.
2. **Do it twice.** A second frontier model, from a different vendor,
   wrote its own disease file, and the pair was better than either
   alone. Whether the second *vendor* mattered, or simply a second
   independent pass, this run cannot say
   ([the cross-model audit](the-cross-model-audit.md) needs diversity
   for auditing; authoring may only need repetition).
3. **Merge into the TAXONOMY.** One file, shaped like a medical chart:
   symptom, example, remedy, how to grade — the definition of disease,
   not gradings of the corpus. The merge was automatic; I reviewed it
   briefly.
4. **Grade in batches, one report per document — and read the
   reports.** Each grading agent gets the taxonomy plus instructions;
   up to twenty documents per agent proved fine. Below the frontier the
   reports failed silent — whole diseases missing, mostly false
   negatives — invisible unless you read the reports yourself. I read
   them; the frontier model's own audit of the three graders I piloted
   matched my reading. Only after that: grade everything.
5. **One continuity check over the whole book.** One agent read
   everything and wrote a single report. This was just a check that the
   book still made sense as a whole — not an input the fixers depended
   on. It passed, and the sequential structure survived batch fixing.
   At this corpus size — those 256 thousand tokens — one context held
   the book; a much larger corpus needs a different design for this
   check, untested here.
6. **Build the fix plan, review it, then fix in batches with a check
   pass each.** The model drafted a BRIEF — taxonomy plus fix
   instructions — and I modified it before any fleet ran. The first ten
   documents were the pilot, and they earned the review: the fixer
   hallucinated specificity — fake numbers, six swords where the text
   said several — and softened things. Those became brief rules for
   every later batch. Each batch got a fix pass and a check/refix pass;
   the check passes caught uncaught diseases, false positives, false
   negatives, and over-removal.
7. **Review the result against the originals yourself.** I read every
   batch's git diffs, hand-polished every chapter, and fed the
   corrections back — with every batch after my polish, the automatic
   fixing got better. Then the author and I read the fixed book against
   the original and did a comparative analysis. The pipeline's own
   green was never the verdict
   ([settled is a human word](settled-is-a-human-word.md)).

## What one run can and cannot claim

**It can claim the result.** A no-barrier pipeline produced a book two
humans accepted. The failures its gates logged were an over-eager
editor's — over-application, invented specificity, softening — and I,
reading the fixers' diffs batch by batch, identified no imitation among
them.

**It cannot claim "the fixer caught nothing."** The check pass ran
before my read, so absorbed style — had there been any — could have been
fixed before anyone looked for it. Nobody classified the second pass's
findings into *disease the first pass missed* versus *disease the first
pass introduced*, which is the split that would show contagion. Scoring
raw fixer output on style markers is
[the clean room](the-clean-room.md)'s experiment, and it remains unrun.

**It cannot credit the taxonomy for the calm.** Every fix context held
both the taxonomy and a small dose — ten documents, some 25 thousand
tokens of the corpus's 256, never the whole.
Either could explain the absence of drift; no arm separated them.

**It cannot call the non-habituation measured.** There is no answer key
of what each document contained and no per-position tally. The datum is
that I, reading everything, noticed no drift — a report, not a
measurement.

## The economics

The bill was not measured — and could not have been: the run went
through a subscription, Anthropic's 15-euro plan, not a metered API
key, so there is no usage record to read. The proxy I have instead:
the work blew through the plan's five-hour usage limit multiple times,
round after round of hitting the cap and waiting for the window to
reset. [Where the savings are](where-the-savings-are.md) demands cost
claims come from the usage record; this run has none, so this page
prices nothing more precise than that.

The tier question has a cleaner answer than a rule: the ladder was
probed, not obeyed and not broken. I tried cheaper models first, read
the bad results, and consciously switched. Diagnosis below the frontier
failed outright; mid-tier grading looked usable and silently missed
whole diseases. The floor for every judgment step on this task was
frontier — found by trying and reading the failures, which is how the
ladder's caps are supposed to move
([agents launch at full price](agents-launch-at-full-price.md): the
economy is human-imposed). What did save money: granularity — twenty
documents per grader, ten per fix batch, no per-document fan-out — and
front-loading the human work into artifacts that amortize: one slow
taxonomy review, one grader validation, then a hundred light polishes.

## The rules, from one run

Pending replication; scoped by the section above.

- **Diagnose before you fix, at the frontier, in duplicate.** Two
  independent disease files, merged. Cross-vendor is plausible and
  unisolated.
- **Probe the tiers, then hold the floor you found.** Here that floor
  was frontier for every judgment step. Expect the cheap grader to fail
  silent — false negatives — so validate graders on reports you read
  yourself before any fleet run.
- **The taxonomy is your taste written down; the model cannot induce
  it.** Examples, hand-walked documents, the symptom–example–remedy–
  grading shape. Slow on purpose — it is the step that amortizes.
- **The fixer's brief is a reviewed, living artifact.** You modify it
  before the fleet runs, and every batch's inspection feeds it.
- **Never one pass, and pilot first.** Expect invented specificity and
  softening, not just misses.
- **Run one whole-corpus continuity check** if the corpus fits a
  context; it is a check, not a dependency.
- **The last mile is manual.** Read the diffs, polish every chapter;
  the artifacts make that read cheap, not unnecessary. Only a reader
  accepts the book.

## Prior art

**Verdict: PARTIAL — searched 2026-08-26; the bundle is NOT FOUND.**
Rubric grading, LLM-as-judge, fix-then-verify loops, and codebook
construction are all heavily published — KNOWN, as assumed. The
closest shape to the whole pipeline is BooookScore (ICLR 2024,
arXiv:2310.00785): 100 books, 1,193 human annotations, a
human-validated coherence-error taxonomy — but the taxonomy scores
summaries; it never drives a fix loop and nothing gets accepted. No
located work combines taxonomy-first diagnosis, a no-barrier fixer,
batch fixing with check passes, and a human-accepted result on a 100+
document prose corpus. On the title's mechanism the literature leans
the other way, as this page suspected: Min et al. (EMNLP 2022,
arXiv:2202.12837) found demonstration label correctness barely moves
in-context learning — label space and format carry the effect — and
"In-Context Fixation" (arXiv:2605.08295) found demonstrated tokens
overriding semantics outright, while "Voice Under Revision"
(arXiv:2604.22142) measured protective instructions attenuating style
drift without reversing it. Labels are weak levers; dose and gates
stay the defensible mechanism candidates, and
[the clean room](the-clean-room.md) remains the experiment that would
settle it. On tier floors, RuVerBench (arXiv:2606.29920) is the
closest evidence that rubrics don't rescue weaker judges — measured on
agentic coding tasks, not prose, so the floor here stays a field
report.
