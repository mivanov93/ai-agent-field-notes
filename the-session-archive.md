# The session archive

*Status: not separately searched; the nearest neighbors are noted at the
end.*

**Claim:** keep an immutable, append-only archive of every session
transcript, subagent traces included, before you know what you will ask
it. Transcripts are the only ground truth of what the model actually did;
the harness deletes them on a schedule; and the questions arrive later —
a model regression, a rule audit, a cost dispute — when the evidence is
already gone unless you kept it.

## Why the repo is not enough

The repo records outcomes: commits, docs, tests. The transcripts record
behavior: what the model read, claimed, retried, was corrected on, and
what every message cost. Those are different corpora, and the second one
answers questions the first cannot. Every number in this collection came
out of the archive or the tree it snapshots: the model timeline and the
audit window ([the cross-model audit](the-cross-model-audit.md)), the
rule-violation counts ([the rule-efficacy
pipeline](the-rule-efficacy-pipeline.md)), the corpus-versus-rules
arithmetic ([the dirty house](the-dirty-house.md)).

## The incidents that shaped the design

- **The harness deletes transcripts.** They are working files with a
  cleanup policy, not records. Without deliberate copies, the evidence
  for any question about the past has a countdown on it.
- **Half the record was never archived.** My sync copied top-level
  session files only. Subagent and workflow traces — 2,200 files, more
  than half the total volume, the entire history of what delegated work
  actually did and cost — sat outside the archive, one cleanup away from
  gone.
- **The sync froze silently.** Copying was a by-hand step, so it stopped
  for twelve days — exactly across the window a model regression later
  had to be investigated in. The live files still existed, by luck.
- **Sources multiply.** The project changed directories twice; sessions
  lived under three paths. Without a provenance manifest, "which era is
  this file from" becomes archaeology.

## The design

- **Raw is the substrate.** Verbatim transcript copies, write-protected,
  hash-manifested, append-only. Nothing in `raw/` is ever edited or
  deleted — an archive you can rewrite is a draft.
- **Derived views are regenerable.** Deduplicated skeletons, structure
  maps, per-question extracts — cheap to rebuild from raw, never
  authoritative, never a reason to touch the substrate.
- **Provenance travels with the files.** One manifest line per file:
  source path, sync date, hash.
- **Subagent traces are part of the record.** The parent transcript holds
  what a lane was asked and what it reported; only the trace holds what
  it did and what it cost.
- **Sync is a script, run as a ritual.** A manual copy step is a frozen
  archive with extra steps.

## What it buys

One archive, one design, and every later question becomes a query:
which model ran which era, and did its work hold up
([the cross-model audit](the-cross-model-audit.md)); which rules still
fire ([the rule-efficacy pipeline](the-rule-efficacy-pipeline.md)); how
much correction each model era cost per shipped change; what delegated
lanes actually did versus what they claimed; cost and cache accounting
from the per-message usage fields; decisions that never made it into the
decision log; and the humble one that pays weekly — "did we already try
this," answered from the record instead of re-derived at full price.

## Prior art

Not separately searched. The nearest neighbors, found during the
cross-model sweep: the transcript-mining precedents (Laurenzo's
regression timeline from 6,852 session files; the session-analyzer tools
that generalize it) are single-purpose and after-the-fact — mining what
happened to survive, not maintaining an instrument. The agent
observability genre (tracing platforms for LLM applications) instruments
the apps you build, not your own coding sessions. The delta to check in
a dedicated search: the standing archive as practice — lossless,
append-only, subagent-inclusive, built before the questions.
