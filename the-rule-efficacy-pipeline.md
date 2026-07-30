# The rule-efficacy pipeline

*Status: method, plus a first manual measurement (2026-07-30). The
per-model transcript version is still pending.*

**Claim:** instruction files only grow. Saved transcripts hold the evidence
of which rules the current model still breaks. Measure that, and pruning
becomes a data question instead of a guess.

## The problem

Writing instruction-file rules from incidents is now standard advice. What
nobody does is close the loop. Rules pile up. Rule-following degrades as
the file grows — that is benchmarked, with a caveat the popular advice
skips: the falloff varies sharply by model, and the strongest current
models follow large files far better than the benchmark averages suggest.
"Trim your file to near zero" inherits the average and ignores the
variance — and misreads what the file is
([the file is scar tissue](the-file-is-scar-tissue.md)). A rule written
for one model's bad habit may cost pure attention on its successor. And
the only pruning method in circulation is asking the model which rules
matter — self-report, from the thing being measured, which is retrieval
of memes about models in general
([the model doesn't know itself](the-model-doesnt-know-itself.md)).

I hit this directly. A week of suspected model regression added several
defensive rules, and the obvious question — can these go, now that the
model changed back? — had no data behind it. Worse, I could show a rule
being broken while it sat in the model's context. Reading a rule is not
the same as following it, and that case is invisible if all you do is
keep writing rules.

A first manual run now exists. A sweep of all 502 documentation files
counted violations per rule: one banned term had 19 live uses, another 15,
all surviving in the half of the corpus no lint ever read. It caught the
two sharpest data points I have: twice, the document that banned a term
was followed one day later by a document using it. And it measured the
accretion side directly: my instruction file grew from 1,939 to 4,233
words in eleven days — 33 of its 35 revisions added text, two shrank it —
while the file itself states that quality is subtractive. That is what an
unmeasured rule system looks like from the inside.

## The method

1. Keep session transcripts, append-only, including subagent traces. They
   are the record of what the model actually did, and harnesses delete
   them unless you save them.
2. For each rule, write down what a violation looks like in a transcript:
   a banned word, a forbidden command shape, a claim about a check with no
   run behind it.
3. Sweep the transcripts per model. Count violations per rule.
4. A rule the current model never breaks moves out of the instruction file
   into a reference doc, incident links intact. A rule that still fires
   stays — now with evidence.

## Prior art

- Mitchell Hashimoto's Ghostty AGENTS.md and the "failure log" pattern
  (ShipWithAI writeup, 2026-04-13). The accretion half: every rule from an
  incident. Widely imitated.
- Distyl AI's IFScale benchmark (NeurIPS 2025 workshop). Instruction
  compliance drops as rule count grows — the reason pruning matters, with
  the model-variance caveat above.
- Informal pruning by asking the model appears in the CLAUDE.md-curation
  genre. No measurement over saved transcripts was found.

**What I think is new:** the measuring loop — violation patterns, counts
per model from saved transcripts, pruning backed by data. The manual sweep
above is the existence proof; the per-model transcript version is the next
step.
