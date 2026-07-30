# Bans rotate the vocabulary

**Claim:** an AI's invented terms are compression devices. If your
instructions demand both brevity and zero loss of precision, the model
mints words to satisfy both. Ban the words and the pressure mints
replacements — in my repo, within three days. To reduce invention, change
the pressure or catch violations mechanically. Written bans alone rotate
the vocabulary; they do not shrink it.

*This page corrects part of [vocabulary
control](vocabulary-control.md). The correction comes from measuring my
own repo after the bans had been in force for eleven days. Finding out a
practice half-works is the point of measuring.*

## The measurement

My instruction file banned a list of the model's favorite metaphors on
July 19 ("watermark", "backstop", "glue", and others), each with a plain
replacement. Eleven days later a sweep of all 502 markdown files checked
what happened.

- The banned words were still live in the docs — 19 uses of one, 15 of
  another — because the original cleanup had only swept code comments, and
  no lint ever read the prose.
- Four fresh metaphors had appeared within three days of the ban: a new
  name for a timestamp ("ghost clock", printed next to the real field
  name), plus three more. The ban removed words. The pressure that minted
  them was untouched, so it minted new ones.
- Twice, the document that banned or scrapped a term was followed one day
  later by a document using it — inside the decision log itself. Not old
  text: fresh writing, by a model with the rule in context.
- One house rule closed the loop: any term used five or more times
  qualifies for the sanctioned vocabulary. So compression invents a word,
  the ban list rotates it, and the five-use threshold promotes whichever
  replacement survives.

## The pressure

The instruction file asks for compression in seven separate rules (lead
with the effect, one qualifier per claim, titles that decode alone, no
narration, plain English, one idea per sentence) and, at the same time,
for zero loss of precision (use real names, depth is fine, document
everything deferred). Hold the meaning fixed and cut the words, and the
cheapest move is to name a multi-part mechanism with one invented word.
The rules never ask for invention. They make invention the only way to
satisfy both demands.

One more measurement kept me honest here: the dense style was not the
model's import. My own hand-written goals file was the densest document in
the repo — more em-dashes per thousand words than anything the model
wrote. The model was compressing the way the house compresses. Attacking
the model's style would have missed the cause.

## Why written rules cannot fix it alone

A literature pass (see PRIOR-ART.md) found no published technique for this
exact problem, but the adjacent evidence is consistent:

- Explicit style instructions attenuate drift, measurably, and do not
  reverse it. The best experiment (Voice Under Revision, 2026) found a
  "preserve the voice" instruction cut the average style shift by about a
  third — while 85% of the individual markers kept drifting the same
  direction.
- Negative instructions ("don't say X") are the weakest instruction shape,
  across several studies. A ban list is a stack of negative instructions.
- Large volumes of in-context text act as unlabeled demonstrations — the
  mechanism behind many-shot jailbreaking. A 375,000-word corpus written
  in the house style re-teaches that style to every session that reads it.
  The model walks into a dirty house and adds to the dirt.

## What to do

- Scope bans to collisions — cases where a metaphor blurs a real domain
  term. Those are meaning bugs, and [vocabulary
  control](vocabulary-control.md) handles them.
- For the style itself, fix the pressure: decide which rule wins when
  brevity and readability conflict, and write the winner down. My repo's
  actual defect was never the em-dashes — it was sentences carrying more
  meaning than they could hold.
- Remove the reward for repetition. A threshold that promotes any
  five-times-used term into official vocabulary pays the model to repeat
  its inventions.
- Enforce mechanically, over ALL the prose. The banned words survived in
  the half of the corpus no lint ever read. A grep that reads everything
  beats a rule that persuades.
- Treat your corpus as training data. What your documents sound like is
  what your next documents will sound like. Page 09 takes this to its
  conclusion: cleaning an already-contaminated corpus needs a clean-room
  pipeline, because the model cannot rewrite the text it is being
  re-taught by.

## Prior art

The literature pass behind this page: many-shot jailbreaking (Anthropic,
2024) for content-overrides-instructions, measured; "Voice Under Revision"
(arXiv 2604.22142, 2026) for instructions-attenuate-but-don't-reverse,
measured; the negation-weakness findings (MIT-covered VLM study;
Anthropic's own "tell Claude what to do instead of what not to do");
"Show and Tell" (arXiv 2511.13972) as a complication — for style of NEW
output, written instructions outlasted examples; Imitate-Retrieve-
Paraphrase (EMNLP 2023) as the closest architecture to a style clean-room,
untested for this use. Direct searches for "stop a model from absorbing
the style of text it must read" and for de-styling technical documentation
came back empty.

**What I think is new:** the rotation measurement — banned metaphors
replaced by fresh ones within days, with the promotion loop that
sanctions the survivors — and the diagnosis that the instruction file's
own compression rules are the mint.
