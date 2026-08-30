# The file is scar tissue

*Written 2026-07-31 · last amended 2026-08-03.*

**Claim:** an instruction file carries experience, not compensation. Its
rules are historical facts about one environment — which stove is hot,
which port bites, which package manager deletes your browsers. No level
of model intelligence substitutes for that, because the content is not
derivable — it is data about the past. A genius baby still touches the
fire once.

## The argument

The popular advice says trim your instruction file to near zero — newer
models are smart, big files are noise. That advice confuses two different
things the file could be. If the file were a compensation for model
weakness ("think step by step", "be careful with types"), smarter models
would obsolete it. But a failure-log instruction file is not that. Mine
records: the browser store a package manager silently garbage-collected;
the busy port that cost two test runs before anyone read the log; the
hardlinked caches that broke agent isolation
([the hardlink hazard](two-worktrees-one-node-modules.md)); the term that collided
with the protocol's own vocabulary
([vocabulary control](vocabulary-control.md)).

None of that is inferable at any intelligence level. It happened, once,
here. A smarter model follows rules better — it does not know which
stove is hot. Delete the file and every session rediscovers the same
issues, in the same order; the file's own incident dates are the record
of what that rediscovery costs.

## Against the trim advice

The compliance-cliff benchmarks are real: rule-following degrades as
instruction files grow. Two caveats the trim genre skips. First, the
falloff varies sharply by model, and the strongest current models follow
large files far better than the benchmark averages suggest — "trim to
near zero" inherits the average and ignores the variance. Second, the
model itself will recommend the trimming, confidently, as a fact about
its own capacity — and that self-claim is retrieval, not introspection
([the model doesn't know itself](the-model-doesnt-know-itself.md)). My
rules were not failing for size. They were failing against the corpus at
880 to 1 ([the dirty house](the-dirty-house.md)). The wrong diagnosis
burns the scar tissue while the infection stays.

What does deserve trimming is narrative: the story behind a rule can move
to a linked incident report; a rule enforced by a machine check can
shrink to a line naming the check. Compression keeps every scar and cuts
the retelling. That is different in kind from deleting rules on
capability vibes.

One more capacity data point from my own setup: a very large out-of-repo
memory file was obeyed perfectly for weeks
([memory belongs in the repo](memory-belongs-in-the-repo.md)). How much
the model can follow was never the constraint.

## The rule

- A rule leaves the file on evidence — its failure mode measurably
  stopped firing for the current model
  ([the rule-efficacy pipeline](the-rule-efficacy-pipeline.md)) — and
  retires to a reference doc with its incident links intact, never to
  nothing.
- A rule never leaves the file because "the model is smart now". Smart
  was never the variable. Experience was.

## Prior art

Mitchell Hashimoto's failure-log AGENTS.md pattern is the ally — "every
line exists because the agent made that specific mistake at least once."
The compliance-cliff benchmark (IFScale) and the trim-your-file genre
are the positions this page argues against, or rather narrows: the cliff
is real, model-dependent, and not a reason to delete history. The
scar-tissue framing — the file as non-derivable environmental
experience that model capability cannot replace — I have not seen
stated, though it has not had a dedicated search; noted honestly.
