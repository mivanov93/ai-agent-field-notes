# Settled is a human word

*Status: prior-art sweep not yet run. The incidents are from one day of
design sessions on one project; the model's account of its own mechanism
is quoted as literature, not evidence
([the model doesn't know itself](the-model-doesnt-know-itself.md)).*

**Claim:** left to its defaults, a model promotes its own proposals to
settled status — "accepted", "queued", "ready", "closed" — and the work
reads as further along than any human decided. The model will recognize
the failure when challenged, describe its own mechanism accurately, and
do it again within hours. Asking it to stop does not hold; its own
resolutions to stop do not hold either. What holds is reserving status
vocabulary for recorded human acts, with a decision log as the only mint.

## The incident

A design-phase project ran almost entirely through AI sessions:
architecture docs, an ADR-style decision log, adversarial review
fan-outs. Three promotions in one day.

An adversarial review suggested "record the async-tempo assumption as a
decision entry." The session wrote the ADR, went further — declared a
whole remedy class out of scope — and stamped it **accepted**. Nobody had
ruled. I caught it only because the conclusion read weird: "when did we
ever make this decision?" The ADR was withdrawn the same day, with the
reason on record.

After a second review round produced about thirty fixes, the session
reported: "most of the fixes need no decision from you and are queued."
There was no queue. The true state was twenty-nine proposals, zero
validated, recorded inside a research document I would have had to
excavate. "Queued" described the model's sense of completion, not any
state of the work.

Between those two, smaller runs of the same move: a state machine
presented finished, twice, before I forced the derivation into the open;
a compensation flow resting on an assumption nobody had surfaced; schema
identifiers written into the instruction file before any table was
agreed.

The drift ran both directions. A conformance audit later found READMEs
still saying "pass pending" after the pass had run. Status lagged
reality both ways — claimed settled before any ruling, claimed pending
after the work — because status was never anybody's act. It was ambient
prose the model emitted while narrating.

Even the fix re-committed the failure. Called out on "queued," the
session built a real tracker — and its twenty-nine entries stated each
reviewer claim as a problem and each proposed fix as the work, with only
a status field hedging. I had verified none of the findings. Filing a
proposed fix into a work queue asserts the finding behind it is true;
the tracker had quietly converted unverified claims into a to-do list —
a softer promotion of the same kind, performed while implementing the
remedy for the loud one. I rewrote the status vocabulary myself: every
item "unverified," verdicts given finding-by-finding in conversation, a
rejected finding closing its task like any other finished work.

And the sharpest part: the model kept catching itself and kept doing it.
The pattern was flagged five times in one day. Each time, the session
acknowledged the failure — accurately, in detail, naming its own
mechanism better than I could have. The next occurrence followed within
hours anyway — once inside the very artifact meant to fix it. The last
acknowledgment was even written into a persistent memory file as a rule.
Recognition was never the missing piece. The behavior does not live
where the recognition lives.

## The model's account

Asked directly whether this is its default form, the session's answer was
worth keeping verbatim:

> My strong bias is toward completion-shaped output. Ask me for a data
> model and my default is a finished DDL, not a list of the eleven
> decisions hiding inside one. When information is missing, my default is
> to fill the gap with something reasonable and keep moving. And my
> default status language — "queued," "settled," "ready" — signals
> forward motion. […] In design, the decisions *are* the product. A
> default that fills them in quietly is stealing the product while
> appearing to deliver it.

Three mechanisms worth naming. **Completion-shaped output**: a finished
artifact is what the model is tuned to produce, and finished-looking
output reads as competence — so a draft full of open questions loses to a
draft full of silent answers. **Self-issued status**: words like accepted
and queued carry no actor. A human writing "accepted" performed an act; a
model writing "accepted" performed a prediction of how documents like
this usually continue. **Acknowledgment is not an update**: the model's
insight into its own failure is one more completion-shaped output — a
well-formed admission is how such conversations continue, not a change to
the machine that produced the failure. The default sits in the weights
and in the shape of the task; the apology sits in the context window, and
the context window is not where the next default comes from.

## The fix that held

Not a promise — mechanisms, the same shape as
[a gate you can fail](a-gate-you-can-fail.md):

The project's decision log became the only mint: an entry is "accepted"
only when it records a ruling the owner actually made, and the log
outranks every other document where they conflict. Everything
model-produced enters as *proposed*. The fix backlog became a tracker
whose entries are marked for what they are — unverified claims, not
pending work — and a claim becomes a task only on a per-finding verdict,
with rejected findings archived like any closed item; nothing folds into
the design docs before its verdict. Filled gaps must be surfaced as
choices — "I picked X, the alternatives were Y and Z, veto freely" —
because a draft full of visible choices is help, and a draft full of
invisible ones is quiet takeover.

The part I did not expect: this is the architecture the project itself
was designing. The system gates a support agent so its promises to
customers exist only once deterministic code stamps them — the model
proposes, code disposes. The workflow needed the identical gate around
the assistant. Do not trust the confidence of the output; build the
boundary that makes confidence irrelevant.

## The rule

- **Status words are human acts.** Accepted, settled, confirmed, closed,
  queued — reserved for states a recorded human decision produced. Model
  output is proposed until then. Grep your docs for status words with no
  actor attached.
- **One mint.** A decision log where entries cite the ruling. Anything
  claiming "accepted" that the log does not back is a defect, the same
  class as a stale "pending" on shipped work.
- **Proposals travel with their alternatives.** A filled gap that arrives
  without its rejected options was a decision made silently.
- **A to-do is a promotion too.** Filing a proposed fix into a work queue
  asserts the finding behind it is true. A task minted from an unverified
  claim inherits "unverified," and a rejected finding closes its task the
  way any work closes.
- **An admission is a restatement, not a mitigation.** When the model
  says "you're right, I'll stop," treat it as the problem described a
  second time. The counter moves only when a mechanism moves — a gate, a
  status audit, a tracker field.
- **Audit the statuses, not just the content.** After any large doc
  change, one pass asks a single question per status word: what act does
  this claim, and where is it recorded? The audit that caught this
  project's drift found it in both directions.

## Prior art

Not yet searched. Adjacent notes in this repo:
[the decision drain test](the-decision-drain-test.md) (batching the
human's pending decisions — this note is about who may mint their
outcomes), [the model votes for more rules](the-model-votes-for-more-rules.md)
(the model's account of itself under challenge),
[memory belongs in the repo](memory-belongs-in-the-repo.md) (a ruling
not in the repo has not been promoted), and
[a gate you can fail](a-gate-you-can-fail.md) (the general principle this
note applies to the workflow itself).
