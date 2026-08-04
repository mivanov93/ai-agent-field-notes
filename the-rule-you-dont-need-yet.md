# The rule you don't need yet

*Status: prior-art sweep not yet run. The omission below is measured; the
explanation of it is the model's own account, which this repo treats as
literature rather than evidence
([the model doesn't know itself](the-model-doesnt-know-itself.md)).*

**Claim:** asking a model to mine one project's instruction file for another is
a lossy read, and the loss is not random. It drops the rules whose subject is
not yet active in the target — which are exactly the rules you cannot re-derive
when the subject shows up.

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

## The rule

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
to live to be usable), and [agents launch at full
price](agents-launch-at-full-price.md) — which is the specific policy that went
missing here.
