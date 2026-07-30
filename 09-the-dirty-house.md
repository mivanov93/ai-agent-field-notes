# The dirty house and the clean room

*Status: the principle is measured; the method is designed and untested.
This page specifies an experiment; it does not report one.*

**Claim:** whatever your corpus does, the model will do more of it. Text in
context works as an unlabeled demonstration set, so a repo full of bad
writing teaches every session to continue it — and instructions cannot
outshout it, because the corpus is bigger. Cleaning such a corpus needs a
clean room: the agent that writes the replacement must never read the text
being replaced.

## The principle, with numbers

The situation, as I finally understood it: the model walks into a dirty
house. The host is mid-cleanup. There are rules posted on the wall. The
model does not care — it wipes its dirty shoes on the floor and throws
more trash around, because the house itself says that is what one does
here. Models imitate. The rules describe what the house should be; the
floor shows what it is; when the two disagree, the model believes the
floor. Piling more rules on the wall does not change the floor.

The mechanism behind that is measured under another name: Anthropic's
many-shot work showed enough in-context examples override both
instructions and training, scaling with volume, through ordinary
in-context learning.

My repo's version, also measured. Three writing rules went into the
instruction file; thirty commits written the same day, rules in context,
came out with a mean sentence of 10.8 words against an 11.2 baseline —
no change. The arithmetic explains it: a session reads about 427 words of
commit-title examples against 375,885 words of documents. The corpus
outweighs the rules by roughly 880 to 1. Every session walks into that
house and adds matching dirt. The best published rewriting experiment
agrees on the direction: an explicit voice-preserving instruction cut
style drift by 32%, and most markers kept drifting anyway.

## The method: three roles and a barrier

You cannot ask a model to rewrite the corpus it is reading — the source is
the exemplar. So the cleanup splits into roles on either side of a strict
barrier:

- **Reader.** Sees the original. Emits only structured records, never
  prose: one record per assertion, with typed fields (claim, referent,
  anchor as file:line, kind). Extracting, not summarizing.
- **Writer.** Sees the records, the style rules, and example passages
  drawn from OUTSIDE the repo. Never sees the original — it cannot
  imitate text it has not read. Writes the replacement.
- **Checker.** Sees both the original and the replacement, and answers
  one question: does the new text assert the same claims? Letting it see
  both sides is safe because it never writes — only writing carries
  style. When meaning was lost, it rejects; repairing would mean
  writing, which is the wrong side of the barrier.

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
substitution is enough.** Replacing one term with another writes no prose,
so there is nothing to infect. The clean room is only for text that needs
actual rewriting.

## The failure hypothesis, stated up front

I expect the barrier to stop the copying and not the voice. The model's
default register — bubbly, over-structured — comes from its training
data, not from my repo. A writer that never reads my dirty docs still has
its own habits, and the measured expectation for style rules is
attenuation, not control. There is also a subtler leak: the reader picks
the words inside each record's fields, and the reader did read the
original.

## The experiment that settles it

Thirty passages in the unwanted style. Three versions of each: unchanged,
rewritten directly by an agent that read the original, rewritten through
the clean room. Score all three on countable markers — sentence length,
clause count, dangling references, the repo's own coined terms — and on
meaning preserved, judged by a checker that sees the original. The method
earns its cost only if clean-room output is measurably closer to the
target style than the direct rewrite, at equal meaning preservation. If it
is not, the barrier does nothing and mechanical substitution was the whole
answer.

## Prior art

Many-shot jailbreaking (Anthropic, 2024) for the mechanism. "Voice Under
Revision" (arXiv 2604.22142) for instructions-attenuate. "Show and Tell"
(arXiv 2511.13972) for exemplar decay, which the one-unit rule comes from.
Imitate-Retrieve-Paraphrase (EMNLP 2023) for extract-then-generate as an
architecture. The clean-room name and barrier come from copyright-safe
reimplementation, where legal commentary already notes contamination can
live in the weights. Full citations in PRIOR-ART.md.

**What I think is new** (checked across ~45 searches): applying the
barrier to strip a house style from a corpus under cleanup; the checker as
a third role allowed to see both sides because it does not write; the
requirement that the intermediate be structured rather than prose; and the
one-unit-per-writer rule derived from exemplar decay. The parts are known.
The assembly, its constraints, and any evidence it works are not.
