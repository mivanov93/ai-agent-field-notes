# The rule you don't need yet

*Status: prior-art sweep not yet run. The omission below is measured; the
insertion is one observed incident; the explanations of them are the model's own accounts,
which this repo treats as literature rather than evidence
([the model doesn't know itself](the-model-doesnt-know-itself.md)).*

**Claim:** asking a model to mine one project's instruction file for another is
a lossy read, and the loss is not random. It drops the rules whose subject is
not yet active in the target — which are exactly the rules you cannot re-derive
when the subject shows up. And the read errs the other way too: the model
copies the source file's section layout, and where the target has not yet
decided what a section should contain, it fills the gap with drafts nobody
approved. The port loses rules you will need and adds decisions you never
made.

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

## The other direction: sections filled with drafts nobody approved

Three weeks later I ran the same kind of port again, one step down the
chain: the project seeded by that first port became the source for a
third project's instruction file. The report I got back looked like the
discipline this note asks for — every adaptation explained, one
deliberate change flagged for my decision. But the source file has a
section called "money-path invariants the reviews enforce," and the
model copied the section and needed something to put in it. What it put
in were schema identifiers (`case_data`, `head_seq`, `agent_cursor`,
`amount_cents`) taken from database drafts I had explicitly pushed back
on and postponed. I caught it on read: "why did you add the database
stuff to the claude.md? we still haven't agreed on the specific
tables."

The session's diagnosis, again recorded rather than paraphrased:

> [the source]'s CLAUDE.md has a "money-path invariants the reviews
> enforce" section, so I carried the pattern over — invariants do belong
> in that file. The defect is *how* I wrote them: in schema identifiers
> […] from DDL you explicitly pushed back on and that we deferred […].
> That treated conversation drafts as settled schema.

Note where the filled section sits: it is the part of the instruction
file that reviews *enforce*. Anything written there becomes policy that
every future agent applies — so an unapproved draft written into it has
been promoted to law without anyone deciding that
([settled is a human word](settled-is-a-human-word.md)).

Both errors may come from one habit — a guess, not a finding: the model
treats the port as producing a complete-looking document. Completeness
pressure drops the rules that look irrelevant today, and fills the
sections that look empty.

The fix that session applied is the right general move: keep the
invariants as plain-language principles, take the identifiers out, and
add a line saying the tables are not yet agreed. "Not yet agreed" is
perfectly good content for an instruction file.

## The rule

- **Don't fill a section the target hasn't decided.** If a ported
  section needs content the target has not settled, write "not yet
  decided" in it — never the best draft lying around. Whatever lands in
  an enforced section gets enforced.
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
(an unapproved draft written into an enforced file is one of its
promotions), and [agents launch at full
price](agents-launch-at-full-price.md) — which is the specific policy that went
missing here.
