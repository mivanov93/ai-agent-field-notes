# The dirty house

**Claim:** whatever your corpus does, the model will do more of it. Text in
context works as an unlabeled demonstration set, so a repo full of bad
writing teaches every session to continue it — and instructions cannot
outshout it, because the corpus is bigger. Reading is training.

## The image

The model walks into a dirty house. The host is mid-cleanup. There are
rules posted on the wall. The model does not care — it wipes its dirty
shoes on the floor and throws more trash around, because the house itself
says that is what one does here. Models imitate. The rules describe what
the house should be; the floor shows what it is; when the two disagree,
the model believes the floor. Piling more rules on the wall does not
change the floor.

## The numbers

The mechanism is measured under another name: Anthropic's many-shot work
showed enough in-context examples override both instructions and
training, scaling with volume, through ordinary in-context learning.

My repo's version, also measured. Three writing rules went into the
instruction file; thirty commits written the same day, rules in context,
came out with a mean sentence of 10.8 words against an 11.2 baseline —
no change. The arithmetic explains it: a session reads about 427 words of
commit-title examples against 375,885 words of documents. The corpus
outweighs the rules by roughly 880 to 1. The best published rewriting
experiment agrees on the direction: an explicit voice-preserving
instruction cut style drift by 32%, and most markers kept drifting
anyway.

The principle plainly extends past prose — sessions continue the code
patterns, doc structures, and shortcuts they see, good or bad — and for
code there is adjacent published evidence (models reproducing insecure
patterns present in context). For style, no one has run the exact
experiment.

## What follows

- Corpus hygiene is a capability lever, not cosmetics. What your
  documents sound like is what your next documents will sound like.
- "Clean from now on, deal with the old mess later" cannot work: the old
  mess is the teacher of every new session
  ([the model votes for more rules](the-model-votes-for-more-rules.md)).
- Word bans do not fix it either — they rotate the vocabulary while the
  pressure stays ([bans rotate the vocabulary](bans-rotate-the-vocabulary.md)).
- Cleaning an already-contaminated corpus needs a reading/writing barrier,
  because the model cannot rewrite the text it is being re-taught by —
  [the clean room](the-clean-room.md).

## Prior art

Many-shot jailbreaking (Anthropic, 2024) for the mechanism, measured.
"Voice Under Revision" (arXiv 2604.22142) for
instructions-attenuate-but-don't-reverse, measured. Insecure-pattern
reproduction in code as the adjacent evidence for the non-prose case.
Full citations in PRIOR-ART.md.

**What I think is new:** naming the corpus-as-training-data principle as
an operational concern for agent-run repos, with the 880-to-1 arithmetic
that explains why rules lose.
