# The session archive

*Written 2026-07-31.*

*Status: searched 2026-07-31. Retaining transcripts has neighbors; the
archive-ahead-of-the-question instrument did not.*

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

## What I actually ran on it

None of this is hypothetical. With the transcripts attributed per message to
the model that wrote them, I asked: per thousand tool calls, each model's rate
of assistant-fault tool errors and of editing a file without reading it first;
per thousand of my own messages, how often I corrected a wrong claim versus
asked a skeptical "are you sure"; and per era, how often each model launched a
background agent, talked about parallelizing, or edited a file while one of its
own read-only lanes was mid-read. One durable, model-specific result fell out —
one model initiated delegation roughly six times less than the other two — and
two of the loudest early findings turned out to be detector artifacts, caught
and retracted only because the raw record was there to re-check
([the cross-model audit](the-cross-model-audit.md)). None of it lives in the
repo; all of it came out of the transcripts, and only because they were kept.

## Prior art

**Verdict: PARTIAL — and the backup tools are not the claim.** Two different
things get run together here; keep them apart. Retaining transcripts is
solved and vendor-sanctioned: Anthropic's Agent SDK `SessionStore` mirrors
sessions and subagent traces to your own storage, and tools like `csb` and
the backup guides git-back them byte-for-byte. But those keep the bytes for
continuity — none of them runs anything over the archive. The motivating
incident is public and dated: Claude Code's 30-day `cleanupPeriodDays`
silently deletes transcripts (The Register, 2026-06-30; issues #59248,
#62272, #62476). That is the problem, not a solution.

Analyzing the archive does have a precedent, and this page already names it:
Stella Laurenzo's transcript mining (claude-code#42796 — 6,852 sessions, a
model-regression timeline). But that mined transcripts that happened to
survive, after the fact. The genre ancestor for the underlying move is
observability's "capture raw and wide, derive the views later" (Honeycomb's
Observability 2.0, 2024) — written for production telemetry, never carried
across to agent transcripts.

The delta, unfound in this sweep: the archive built deliberately, before the
question — immutable, append-only, subagent-inclusive, raw substrate kept
apart from regenerable derived views — as a standing instrument for exactly
those later analyses (model comparison, rule audits, cost disputes).
Retention keeps without analyzing; Laurenzo analyzed what luck preserved;
nobody welds "archive first, because the repo records outcomes but the
transcripts record behavior." That weld is the contribution.

Provenance, in the spirit of this repo's own rule: I arrived at this
independently, around June 2026, with no research and no one asked. The driver
was concrete — I do not delete my sessions, so I mined the ones I had to build
a working CLAUDE.md and to pull docs and ideas out of them, and ran the
append-only archive from there. The formal archive began after the first ~50
sessions, not before session one; nothing was lost only because not-deleting
is the whole discipline, so the raw record was already complete when I came to
build on it. That someone published the transcript-mining idea before me I
recognize and cite; the independent derivation, the never-delete-then-mine
practice, and the archive-as-standing-instrument framing are what this page
adds.
