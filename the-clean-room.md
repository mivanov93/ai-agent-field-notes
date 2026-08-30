# The clean room

*Written 2026-07-31 · last amended 2026-08-26.*

*Status: designed and untested as specified — this page specifies an
experiment; it does not report one. Since it was written, a rival
no-barrier design has run at scale with a human-accepted result
([the doctor doesn't catch the fever](the-doctor-doesnt-catch-the-fever.md)); see the addendum below.*

**Claim:** a corpus that teaches the model its own bad style
([the dirty house](the-dirty-house.md)) cannot be cleaned by a model that
reads it — the source text is itself the style exemplar. The cleanup needs
a barrier: the agent that writes the replacement must never read the text
being replaced.

## The method: three roles and a barrier

- **Reader.** Sees the original. Emits only structured records, never
  prose: one record per assertion, with typed fields (claim, referent,
  anchor as file:line, kind). Extracting, not summarizing.
- **Writer.** Sees the records, the style rules, and example passages
  drawn from OUTSIDE the repo. Never sees the original — it cannot
  imitate text it has not read. Writes the replacement.
- **Checker.** Sees both the original and the replacement, and answers
  one question: does the new text assert the same claims? Letting it see
  both sides is safe because it never writes — only writing carries
  style. When meaning was lost, it rejects; repairing would mean writing,
  which is the wrong side of the barrier.

Two constraints carry the whole design:

1. **The intermediate must be structured, not prose.** Style lives in
   surface form — word choice, clause structure, rhythm. Typed fields
   have no clause structure to carry it. If the reader emits a summary
   paragraph instead, style crosses the barrier intact and the method
   does nothing.
2. **One unit per writer, then discard it.** Measured exemplar effects
   decay by the second output while written rules persist — so a writer
   handles one file and is not reused down a list. Its style anchor is
   strongest on its first output and gone by its second.

And one scoping rule before any of it: **substitute, never rewrite, where
substitution is enough.** Replacing one term with another writes no
prose, so there is nothing to infect. The clean room is only for text
that needs actual rewriting.

## The failure hypothesis, stated up front

Two different problems hide under "bad style," and the clean room targets only
one. It is built to strip the style your corpus imported and now re-teaches —
the dirty house. It does nothing about the model's *inherent* default register,
bubbly and over-structured, which comes from its training data rather than your
repo and which no barrier around your corpus can reach
([don't ask for perfection](dont-ask-for-perfection.md) is nearer that one). So
I expect the barrier to stop the copying and not the voice: a writer that never
reads my dirty docs still has its own habits, and the measured expectation for
style rules is attenuation, not control. There is also a subtler leak: the
reader picks the words inside each record's fields, and the reader did read the
original.

## The experiment that settles it

Thirty passages in the unwanted style. Three versions of each: unchanged,
rewritten directly by an agent that read the original, rewritten through
the clean room. Score all three on countable markers — sentence length,
clause count, dangling references, the repo's own coined terms — and on
meaning preserved, judged by a checker that sees the original. The method
earns its cost only if clean-room output is measurably closer to the
target style than the direct rewrite, at equal meaning preservation. If
it is not, the barrier does nothing and mechanical substitution was the
whole answer.

## Addendum: a rival result

After this page was written, a different cleanup ran for real — 100
documents of broken prose, no barrier anywhere: the fixing agents read
the originals directly, carrying a frontier-built disease taxonomy in
every context, batched small, with a second check/refix pass, and the
result was accepted by the humans who read it
([the doctor doesn't catch the fever](the-doctor-doesnt-catch-the-fever.md)).

What follows for this page is narrower than it first looks. That run
did not measure contagion: its check passes and hand-polish sit between
the fixer's output and every verdict, so absorbed style — had there
been any — would have been caught or polished away before anyone looked
for it. I read the fixers' diffs and identified no imitation there,
and the failures the gates logged were over-application rather than
absorption; but nobody classified second-pass findings into
missed-versus-introduced, and no raw fixer output was scored on style
markers. That scoring is exactly the experiment this page specifies,
and it remains unrun. So the claim stands unmeasured rather than
challenged — what has changed is the baseline. The comparison above was
clean room versus naive direct rewrite; the honest baseline is now the
labeled reader — direct rewrite with taxonomy, bounded batches, and a
check pass — which shipped an accepted book without the barrier. The
barrier earns its considerable ceremony only if it beats that.

## Prior art

"Show and Tell" (arXiv 2511.13972) for exemplar decay, which the one-unit
rule comes from. Imitate-Retrieve-Paraphrase (EMNLP 2023) for
extract-then-generate as an architecture. The clean-room name and barrier
come from copyright-safe reimplementation, where legal commentary already
notes contamination can live in the weights. Full citations in
PRIOR-ART.md.

**What I think is new** (checked across ~45 searches): applying the
barrier to strip a house style from a corpus under cleanup; the checker
as a third role allowed to see both sides because it does not write; the
requirement that the intermediate be structured rather than prose; and
the one-unit-per-writer rule derived from exemplar decay. The parts are
known. The assembly, its constraints, and any evidence it works are not.
