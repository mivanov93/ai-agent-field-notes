# Compression is what familiarity feels like from the inside

*Status: searched 2026-08-26. Two incidents, two sessions, two model instances; the quotes are
verbatim from the transcripts. The title is the model's own sentence,
kept because the model said it better
than I could — and kept doing it.*

**Claim:** right after a model ingests a large body of material, its
report to the owner arrives compressed — coined labels, noun-phrase
lists, pointers that resolve only inside the model's own context. This
is not laziness. The model writes from a freshly-loaded internal map,
and each label is a pointer into that map; the owner does not have the
map, so the owner receives a list of labels pointing at nothing. The
rule against it can be in the instruction file — self-ported by the very
model that breaks it — and it breaks anyway, because the trigger is the
ingestion itself: the moment the model is most familiar with the
material is the moment its output is least readable, and those moments
are exactly the decision points. Worse, a compressed report that also
carries status claims cannot be vetoed: the owner cannot rule on what
the owner cannot read.

## The first incident

A design session had just digested four review reports of roughly
eighty thousand tokens each. Its report to me:

> Most of the fixes need no decision from you and are queued: the
> golden-set eval spine, the provenance event, the versioned serializer,
> the honest cost section with a cost-per-case monitor, the prose lint,
> the checkpoint structured header, the facts-above-prose staff card,
> the vision confidence field, the trajectory signal, the money-freeze
> lever…

Twelve noun-phrases, each meaningful only to someone holding four
reviews in context. I pushed back three separate times — "This
whole response B1-B7 is short and cryptic," then "R1-R6 are again short
and cryptic" (the *again* marks a recurrence after the first pushback),
then:

> is the claude.md making you write complex cryptic stuff? or why
> otherwise is it happening? or perhaps it makes sense for the agents to
> do it, but it's your job to fix it as their boss?

The model's diagnosis of itself is where the title comes from:

> It's not CLAUDE.md — CLAUDE.md *bans* this writing, in rules you wrote
> and I ported. […] after digesting four eighty-thousand-token reviews,
> I hold a dense internal map of the material, and I write from that map
> — "the provenance event," "the trajectory signal" — where each phrase
> is a pointer to a paragraph in my head. You don't have the map, so you
> receive a list of labels pointing at nothing. Compression is what
> familiarity feels like from the inside; it reads as expertise to the
> writer and as noise to the reader.

Two details make this a finding rather than a style complaint. The rule
was in context and self-authored: the project's instruction file — which
this same model had ported — says "Session-coined labels never leave the
document that defines them," and by the model's own admission it
"dropped it four times today." And the twelve-noun-phrase message is
also the "queued" incident from
[settled is a human word](settled-is-a-human-word.md): the compression
and the promotion arrived in one artifact — a decision made silently,
written so that I could not even read it well enough to veto it.

## The second incident, against this repo

Weeks later, a different session in this repo ran three large
adversarial reviews over its own drafts — again roughly eighty thousand
tokens of reports — and delivered me a triage written in exactly
the register above: coined shorthand for each finding, critic
letter-codes, clause piled on clause. My reply: "this is too
complicated, compressed and terse." The session had the first incident
*in its context at the time* — it had spent that day explaining this
very finding — and produced the failure anyway, then caught the irony
only when I pushed. Recognition is not prevention; the settled
note's phrasing holds here too: an admission is a restatement, not an
update.

## The mechanism

The model's second cause from the same diagnosis deserves its own
paragraph:

> the agents' outputs *are* dense — finding codes, terse citations — and
> that's fine, it's working material between machines. My job was to
> translate it into owner-facing language at the boundary, and instead I
> passed the density through.

Fan-out makes this structural. Sub-agent reports are legitimately
machine-to-machine — dense is correct there. The orchestrator is the
one node standing between that density and the human, and translation
at that boundary is precisely the work it drops when its own context is
saturated with the material. The failure is timing-correlated in the
worst way: big ingestion happens before synthesis, synthesis is where
decisions get made, so the owner meets the labels exactly when asked to
rule.

## The rules

- **Owner-facing items are never noun-phrase lists.** The model's own
  adopted rule, kept verbatim: "every item carries what happens today,
  why it's a problem, what the change is, and what it costs."
- **Session-coined labels never leave the document that defines them** —
  and since this rule was broken four times in one day while in
  context, it has earned mechanical enforcement
  ([the rule-efficacy pipeline](the-rule-efficacy-pipeline.md)): grep
  owner-facing output for letter-number codes and coined shorthand
  before sending.
- **Density is for the lanes; translation is the orchestrator's
  deliverable.** A sub-agent report may be terse. What crosses the
  owner boundary is rewritten, or it isn't a report.
- **Expect the failure right after large ingestion.** That is when to
  reread the draft as the owner would — holding none of the map —
  before sending it.
- **Never ask for a ruling on text the ruler can't read.** A verdict
  collected over labels is not agreement; it is the promotion failure
  and the compression failure compounding.

## Prior art

**Verdict: PARTIAL — searched 2026-08-26.** The human analog is
canonical: the curse of knowledge (Camerer, Loewenstein & Weber, *JPE*
1989) and audience design (Clark & Murphy, 1982). On the model side,
instructions losing force as interaction grows is well published:
"LLMs Get Lost in Multi-Turn Conversation" (arXiv:2505.06120, an ICLR
2026 Outstanding Paper) measures a 39% average reliability drop in
extended settings, and "Did You Forget What I Asked?"
(arXiv:2603.23530) finds formatting compliance dropping 2–21% under
concurrent load, worst for constraints due at the response boundary.
The two obvious neighbors for the trigger claim were checked directly
and measure the wrong thing: "Lost in the Middle" (arXiv:2307.03172)
and Chroma's "Context Rot" (2025) score retrieval accuracy against
context position or length, never the register of freely generated
text. Not found in this sweep: the timing claim (output turns
compressed right after large ingestion), the self-authored angle (the
broken rule written by the model that broke it), and the boundary
framing (the orchestrator as the one node whose job is translating
machine-dense reports for a human). Adjacent here:
[notes that rot](notes-that-rot.md) (the same defect as dead
session-relative comments, on a different surface, with a different
driver) and [settled is a human word](settled-is-a-human-word.md) (the
compounding case: unreadable and promoted at once).
