# Where scar tissue comes from

**Claim:** an instruction file is scar tissue — hard-won, non-derivable
lessons about one project ([the file is scar tissue](the-file-is-scar-tissue.md)).
This note is where the scar tissue comes from. The retro is the ritual that
turns one incident into a durable rule: something ships wrong, you ask why
the checks let it through, and you write the answer down as a new rule or a
new check. Skip the retro and the lesson evaporates — the next session, with
the same blind spot, repeats it.

## The move

The retro is not "why did the bug happen." It is "why did our checks miss
it." Blameless, and pointed at the process rather than the person or the
model: the gates were green and the thing was still broken, so the gates are
what have to change. The output is not a scolding — it is a new gate where
one can exist, or a new line in the instruction file where one can't. That is
what converts a single painful incident into something that protects every
session after it.

## What follows

This repo is a pile of retros. Every note here started as an incident where
the right guidance was already in context and the work still went wrong, and
each ends in something enforceable. The instruction file grows the same way —
not designed up front, accreted one healed incident at a time. The founding
document is written by hand before the corpus exists
([the founding document](the-founding-document.md)); the retros are the
case law that accretes after. And because a good retro often ends in a check
rather than a sentence, this is where the cheapest savings come from too: a
rule that stops a run from failing is a run you never pay for twice
([where the savings are](where-the-savings-are.md)).

## The rule

Run the retro whenever work ships wrong despite green checks — that is the
trigger, not a calendar. Ask what the checks missed, and write the lesson
where it will fire again: as a gate if the property is checkable
([a gate you can fail](a-gate-you-can-fail.md)), as an instruction-file line
if it is judgment. A lesson you feel but never write down is a lesson you
will learn again.

## Prior art

Heavy, and mostly KNOWN — this note's job is to connect it, not claim it. The
blameless-postmortem discipline is Google's SRE practice ("fix the system,
not the people"); QA calls the same move escaped-defect analysis; Mitchell
Hashimoto's Ghostty AGENTS.md is a well-known instruction-file-as-failure-log.
Agent-specific retro tools (agent-retro, retro-skill, and similar) automate
the session-end version. *Status: KNOWN method; the only delta is the framing
— the retro as the mint for an AI agent's instruction file, and the
gate-focused variant that asks why the green check missed it.*
