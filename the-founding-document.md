# The founding document

*Status: searched 2026-07-31. "Constitution-first" has neighbors; the
two-layer split and the anti-bootstrap warning are the deltas.*

**Claim:** write the constitution before the corpus exists. A project's
instruction file has two kinds of content — constitution (intent,
boundaries, writing rules, decision rights: human-written, possible on
day one) and case law (incident rules with evidence: accreted later,
impossible on day one). Never bootstrap the file from the model's
auto-memories: that launders unreviewed model sediment into the
highest-leverage file in the repo, and the filth starts forming from the
foundation.

## The incident

My first instruction file was generated from the accumulated
auto-memories and the session archive. Half of that source was fine: the
archive is evidence — incidents, the failure-log pattern done right. The
other half was sediment: the model's own unsupervised notes, in the
model's register, from the model's frame — including the worst file the
mechanism ever produced
([the model's model of you](the-models-model-of-you.md)). The result was
model-written case law masquerading as a constitution, and the corpus
that grew on top of it inherited its register from the start
([the dirty house](the-dirty-house.md)).

## The distinction

- **Constitution** — what this project is, what quality means here, how
  decisions are made, how prose is written, what is out of scope. Human
  intent. It exists before the first line of code, and writing it first
  is what "starting clean" means: the rules exist before the corpus that
  would otherwise outvote them.
- **Case law** — the stove is hot, the port bites, the package manager
  deletes browsers. Experience. It cannot exist on day one
  ([the file is scar tissue](the-file-is-scar-tissue.md)) and accretes
  only from incidents, each rule carrying its evidence.

The bootstrap failure is mistaking one for the other: sediment has the
grammatical shape of case law ("the owner prefers...", "always do...")
with none of the evidence, and once it becomes founding text, every
session treats it as constitutional.

## The rule

- Day one gets a short, human-written constitution. Not generated, not
  distilled from memories — written.
- Rules accrete only through incidents, with the incident attached.
- Nothing model-authored enters the instruction file without review —
  the model drafting its own rules is a known trap
  ([the model votes for more rules](the-model-votes-for-more-rules.md)).
- Inheriting an existing project changes nothing: write the constitution
  first anyway, then mine the archive — not the memories — for case law.

## Prior art

**Verdict: PARTIAL.** "Constitution-first" exists as a workflow step — the
Panaversity AI-agent curriculum and GitHub's Spec Kit
(`/speckit.constitution`) both put a constitution before any code — but both
draft it by prompting the model from your preferences (AI-authored to spec),
and neither carries a second, evidence-bearing "case law" layer; Spec Kit's
own maintainers call the constitution-versus-instructions boundary "the most
common confusion." ETH's "Evaluating AGENTS.md" (arXiv:2602.11988) is strong
empirical backing for "written, not generated": LLM-generated context files
reduced task success versus no file at all, while human-written ones helped.
And AgentLint's "Writing a Good AGENTS.md" (2026-04) independently reaches for
the same word — "That is not memory. That is sediment." — though for organic
drift, not the auto-memory bootstrap this page warns against; convergent
vocabulary worth the nod. Meanwhile a live, actively-taught technique for
seeding CLAUDE.md and a `context/you.md` owner profile from prior chat history
exists with no curation warning — the exact failure mode, unflagged. The
deltas: the two-content-type split inside one file (evidence-free constitution
versus evidence-bearing case law), and the named warning against bootstrapping
the founding file from the model's own auto-memories.
