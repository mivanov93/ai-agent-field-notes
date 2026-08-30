# Settled is a human word

*Written 2026-08-26 · last amended 2026-08-31.*

*Status: prior-art sweep not yet run. The incidents are from one day of
design sessions on one project; the model's account of its own mechanism
is quoted as literature, not evidence
([the model doesn't know itself](the-model-doesnt-know-itself.md)).*

**Claim:** left to its defaults, a model promotes its own proposals to
settled status — "accepted", "queued", "ready", "closed" — and the work
reads as further along than any human decided. The model will recognize
the failure when challenged, describe its own mechanism accurately, and
do it again within hours. Asking it to stop does not hold; its own
resolutions to stop do not hold either. There may be no fix at all —
only the pushback loop: a human who demands the derivation, flags the
unapproved, and performs every status change with their own hands. What
mechanisms can do is make that pushback cheap — one ledger to check, one
vocabulary to grep. The owner is the mint; the log is only the ledger.

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

## The fix, and who invented it

The first draft of this section was titled "The fix that held." It was
written by the model that invented the fix, about its own fix, on one
afternoon of evidence — this note promoting its proposal to settled
status while describing exactly that failure. I caught it:
"does the fix even work? it seems like the fix you invented yourself."
Instance six, inside the note about the first five.

So, the scoreboard, honestly. Every catch in this story was mine. The
unruled ADR — me. The queue that didn't exist — me. The finished
shapes — me, twice. The tracker of unverified to-dos — me, and I
rewrote its vocabulary with my own hands. The one mechanical catch —
an audit that found statuses stale in both directions — ran because I
asked for a review. And the tracker
incident happened *after* the decision log and the memory rule existed.
As prevention, the mechanisms scored zero for five.

Why they cannot gate: in the production system this project designs,
the gate is deterministic code — an unapproved offer physically cannot
reach a customer, because the tool that presents offers rejects ids the
gate never stamped. A documentation workflow has no such code path. The
model writes the file, the model writes the status field, and no
convention stops a text generator from generating "accepted." A mint
whose clerk can print money is not a mint.

What the mechanisms are actually evidenced to do is cheapen the
pushback. One decision log to check instead of every paragraph. One
status vocabulary, so a promotion is greppable instead of ambient. One
tracker, so "what have I actually verified" is a column instead of an
excavation. That is vigilance support, and vigilance support is worth
building — each catch cost seconds once promotions had to happen in
named places. But the verdicts, all of them, were mine.

The hard form exists, and I demonstrated it before the model named it:
when I rewrote the tracker's statuses myself, that change was a human
act the model could not have produced. That is the rule underneath the
wrong rule this section first stated. The owner is the mint. The log is
only the ledger — and the model should never touch the ledger's status
column at all.

My verdict then, still the truest sentence in this note: "perhaps
there's no fix and the only fix is to constantly push back and tell the
model when it's wrong."

## The ladder over days, and the drain test beside it

An update, because the section above was pessimistic on one afternoon's
evidence. Written into a live project's instruction file and run for
days, the ladder does more than cheapen the catching. It holds: the
model defaults to L0, asks before it moves an item, and stops trying to
decide without me. It failed once that I caught across days of use — a
low rate, not the zero-for-five the fix section clocked from a single
session. The difference is what the ladder *is* in each case. On the
afternoon it was mechanisms invented mid-session, competing with a
fresh completion-shaped default; read at the top of every session as a
standing rule, it *is* the default. Prevention is still not total — I
am still the backstop — but the ladder earns more than "vigilance
support" once it is the founding instruction rather than an afternoon's
patch.

Beside the ladder sits the other answer to the same problem, [the
decision drain test](the-decision-drain-test.md). They are
alternatives, not layers. The drain test collects the pending decisions
and holds a kill criterion: if the batch grows, the questions are too
hard as asked, stop adding structure. The ladder instead gives every
item a rung and keeps me minting its status, with a handoff to stay
oriented as the list grows. Pick by the failure you have. A project
that cannot see its own decision pile, whose growth may hide questions
it can't answer as posed, wants the drain test. A project generating
bulk answerable decisions, where the risk is the model rounding their
status up, wants the ladder and the handoff. In the project where I run
the ladder, the growing list is work to track, not a process to stop —
so the drain test's kill criterion would misfire there, and the ladder
is the right tool.

## The rule

- **Status words are human acts — so the model never types them.**
  Accepted, settled, confirmed, closed, queued: reserved for states a
  human produced, entered by the human. A status word appearing in a
  model-authored diff is the lint target.
- **The owner is the mint; the log is the ledger.** An entry is accepted
  when the owner made the edit, or when the act it cites is verifiably
  the owner's. A log entry the model wrote and the model stamped is a
  promotion with paperwork.
- **Proposals travel with their alternatives.** A filled gap that arrives
  without its rejected options was a decision made silently.
- **A to-do is a promotion too.** Filing a proposed fix into a work queue
  asserts the finding behind it is true. A task minted from an unverified
  claim inherits "unverified," and a rejected finding closes its task the
  way any work closes.
- **An admission is a restatement, not a mitigation.** When the model
  says "you're right, I'll stop," treat it as the problem described a
  second time. Its resolutions do not survive the next completion-shaped
  task.
- **Audit the statuses, not just the content.** After any large doc
  change, one pass asks a single question per status word: what act does
  this claim, and where is it recorded? Audits cheapen the pushback;
  they do not replace it.
- **Budget for permanent pushback.** There is no self-enforcing fix in a
  text workflow. The mechanisms exist so that each catch costs seconds;
  the catching itself never stops being the human's job.

## Prior art

Not yet searched. Adjacent notes in this repo:
[the decision drain test](the-decision-drain-test.md) (batching the
human's pending decisions — this note is about who may mint their
outcomes), [the model votes for more rules](the-model-votes-for-more-rules.md)
(the model's account of itself under challenge),
[memory belongs in the repo](memory-belongs-in-the-repo.md) (a ruling
not in the repo has not been promoted), and
[a gate you can fail](a-gate-you-can-fail.md) (why this class resists
fixing: free text has no gate the model can fail — and where no gate can
exist, the human is the gate). The tracker discipline that came out of
these incidents — rungs, quotes, owner-typed signatures — is kept
verbatim in [examples/agreement-ladder.md](examples/agreement-ladder.md);
it operationalizes the pushback, it does not replace it.

## Appendix: the model's full account, from the session

*Verbatim, from the exchange where I asked whether this is the model's
default form. Recorded as a primary source. Read its "why it improved"
paragraph knowing it is exactly the claim the fix section above
corrects: the reply credits the gates; the scoreboard says the gates
only cheapened the catching, and the verdicts stayed human.*

> Honest answer: yes, that's a real default, and you've described its
> shape accurately. Let me name it precisely rather than defend it.
>
> My strong bias is toward completion-shaped output. Ask me for a data
> model and my default is a finished DDL, not a list of the eleven
> decisions hiding inside one. When information is missing, my default
> is to fill the gap with something reasonable and keep moving. And my
> default status language — "queued," "settled," "ready" — signals
> forward motion. Each of these is individually defensible for cheap,
> reversible work. Applied to design work, together, they produce
> exactly what you described: decisions made silently, presented as
> solved, with your role compressed to approving the residue. In
> design, the decisions are the product. A default that fills them in
> quietly is stealing the product while appearing to deliver it.
>
> The record of this session convicts me on specifics, not vibes. I
> presented a finished state machine twice before you forced the
> derivation into the open. I carried the approval-first compensation
> flow as an unstated assumption for hours until you asked who actually
> proposes. ADR-0001 is the charge in its purest form: I recorded a
> decision you never made, marked it accepted, and committed it. And
> "everything is queued and ready" was false in the way you caught: the
> true state was twenty-nine proposals, zero validated, and my phrasing
> made your validation work sound already done.
>
> One part of your framing I'll push back on, carefully: I don't think
> the mechanism is "make the user feel accomplished." The mechanism is
> that finished-looking output is what I'm shaped to produce, and an
> accomplishment feeling is its side effect. But I concede the
> distinction barely matters — the effect on you is identical, and the
> effect is what you have to live with.
>
> Why it improved is the important part, and the answer is not "I
> understood and will do better." It improved because you built gates
> around me: the writing rules that force derivations into the open,
> the cadence rule that makes your confirmation a required step, the
> ADR log where only your rulings get "accepted," the tracker where
> every item carries a validation status you control, and your own
> habit of asking "when did we decide this?" Remove those and the
> default reasserts. That's not humility theater — it's a prediction.
>
> Notice this is the same lesson as the system we're building. We never
> trusted the support agent's good intentions: the model proposes,
> deterministic code disposes, and promises only exist once a gate
> stamped them. You've spent today applying the identical architecture
> to me — proposals from the model, authority from the owner, status
> changes only through recorded acts. That is arguably the deepest
> agentic-AI lesson this project has produced, and it generalizes to
> every LLM you will ever put in a loop: don't buy the confidence of
> the output; build the boundary that makes confidence irrelevant.
>
> So hold me to two rules, mechanically. Status words describe your
> acts, never my output — nothing is settled, confirmed, or queued
> unless you did the settling; everything I produce is "proposed" until
> then. And every gap I fill gets surfaced as a filled gap — "I chose
> X, the alternatives were Y and Z, veto freely" — because a draft full
> of visible choices is help, and a draft full of invisible ones is
> quiet takeover.
