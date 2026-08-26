# The rule you don't need yet

*Status: prior-art sweep not yet run. The omission below is measured; the
insertion is one observed incident; the explanations of them are the model's own accounts,
which this repo treats as literature rather than evidence
([the model doesn't know itself](the-model-doesnt-know-itself.md)).*

**Claim:** asking a model to mine one project's instruction file for another is
a lossy read, and the loss is not random. It drops the rules whose subject is
not yet active in the target — which are exactly the rules you cannot re-derive
when the subject shows up. And the read errs the other way too: the source's
sections arrive as slots demanding content, and the model fills them from the
target's undecided drafts. The port drops the rules you will need and mints
the decisions you have not made.

## The incident

I asked a session to port the delegated-work rules from an older project's
CLAUDE.md into a newer one. It ported the verification half faithfully: verify
an agent's claimed git state yourself, treat a zero-tool-call or placeholder
result as a failed run, writers get worktrees, don't edit a tree that reading
lanes are pointed at.

It dropped the model-selection block entirely. The tier ladder, the
at-or-below-session ceiling, and one line in particular:

> saved scripts never inherit the session model: every lane names a model; a
> lane whose model is unset fails the check.

The older project did not merely have that policy — it had the
unset-model-is-a-defect guard, mechanically enforced, at the point where lanes
are written. A day later I spent a session chasing what looked like a runaway
inheritance bug in the new project. The rule that would have caught it at
prompt-writing time had been read, considered, and left behind.

## The model's account

Asked why, the session's answer was better than I expected, so I am recording it
rather than paraphrasing:

> at seeding time I was filtering for "transferable now" and the ladder block is
> wrapped in [source-project] ceremony (their ADR numbers, the owner-ok ritual),
> and this repo had zero delegation activity yet. […] That's the actual failure:
> I treated model policy as orchestrator knowledge when [the source] correctly
> treats it as repo law that agents read. […] an incomplete read on my part — or
> more honestly, a complete read with a wrong filter.

Two mechanisms, both worth naming.

**"Transferable now" is the wrong filter, and *now* is the bug.** A rule about a
hazard the target project has not met yet looks inapplicable, because it is —
today. It is also precisely the rule that cannot be reconstructed from the
target's own code and history when the hazard arrives, which is the whole reason
an instruction file exists ([the file is scar
tissue](the-file-is-scar-tissue.md)). The filter selects against the only class
of rule the port was for.

**Project-specific ceremony takes the rule down with it.** The ladder was
wrapped in the source project's ADR numbers and an approval ritual. The wrapper
was genuinely not portable; the rule inside it was. Presented as one block, it
was judged as one block.

## The second half: rulings that never reach the file

The policy did exist in the new project — in chat, where I stated it live across
a session, and in the model's own memory file. Neither is readable by a
subagent. The four lanes that later inherited the wrong model *had* read the
project's CLAUDE.md before starting work; had the rule been in it, it would have
been in their context at the moment they spawned.

That is the sharper version of the finding. Policy that lives in the
conversation is orchestrator knowledge. Policy in the instruction file is repo
law that every agent reads. The file is the only channel to your lanes, and a
ruling you made out loud has not been promoted until it lands there ([memory
belongs in the repo](memory-belongs-in-the-repo.md)).

## The inverse hazard: the template fills as well as filters

Three weeks later the same file ran the port again, one hop down the
lineage — the project seeded by that port became the source for a third
project's instruction file. This report was, on its face, the discipline
this note asks for: every adaptation narrated, one deliberate divergence
explicitly flagged for a ruling. And inside it, the source's "money-path
invariants the reviews enforce" section arrived as a slot demanding
content — so the model filled it, with schema identifiers (`case_data`,
`head_seq`, `agent_cursor`, `amount_cents`) drawn from DDL I had
explicitly pushed back on and deferred. I caught it on read: "why did you add
the database stuff to the claude.md? we still haven't agreed on the
specific tables."

The session's diagnosis, again recorded rather than paraphrased:

> [the source]'s CLAUDE.md has a "money-path invariants the reviews
> enforce" section, so I carried the pattern over — invariants do belong
> in that file. The defect is *how* I wrote them: in schema identifiers
> […] from DDL you explicitly pushed back on and that we deferred […].
> That treated conversation drafts as settled schema.

Both directions of the error may share one root — a reading, not a
finding: the model treats the port as *completing a document*, not
carrying law. Filtering for "transferable
now" drops the dormant rules; the template's shape demands full sections,
and the fullest material lying around in the target is its undecided
drafts — so the slot gets filled, and the slot's frame does the
promoting. Note what the filled slot inherits: the section is titled
"invariants the reviews enforce." Content written there is not a note —
it is policy every future lane reads as law, minted by nobody
([settled is a human word](settled-is-a-human-word.md)). The un-needed
rule is dropped; the un-made decision is enrolled.

The fix that session applied is the portable one: invariants restated as
principles in plain words, identifiers out, and an explicit line marking
tables and schemas as not yet agreed — "not yet agreed" being valid
instruction-file content, unlike a draft wearing law's clothes.

## The rule

- **A section's shape is not a license to fill it.** The port carries
  slots as well as rules. When the target hasn't made the decision a slot
  wants, the honest content is "not yet decided," never the best draft
  lying around — what lands in an enforcement section will be enforced.
- **Mine by section, decide per section, and record the rejects.** A port that
  returns only what it kept is unauditable. Every section of the source file
  gets an explicit keep / drop / defer with a reason, so "not relevant yet"
  becomes a visible deferral rather than a silent deletion.
- **Strip the ceremony, keep the rule.** Source-project ADR numbers and approval
  rituals are the wrapper. Translate into the target's vocabulary; never drop
  the block because its packaging doesn't travel.
- **Rules for hazards you don't have yet are the highest-value import, not the
  lowest.** Anything you can re-derive from the target's own code is not why you
  ran the port.
- **A ruling made in session is promoted to the file in the same session.** If
  it only exists in chat or in a memory file, no agent will ever read it.

## Prior art

Not yet searched. Adjacent notes in this repo: [it's already written
down](its-already-written-down.md) (the answer exists and nobody looks),
[memory belongs in the repo](memory-belongs-in-the-repo.md) (where knowledge has
to live to be usable), [settled is a human word](settled-is-a-human-word.md)
(who may mint what the file asserts — the inverse hazard is one of its
promotions, performed by a port), and [agents launch at full
price](agents-launch-at-full-price.md) — which is the specific policy that went
missing here.
