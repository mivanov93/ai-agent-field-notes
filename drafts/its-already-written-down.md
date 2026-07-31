# It's already written down

**Claim:** the model will happily spend real effort re-investigating a
question your own notes already answer. It does not first check whether the
answer exists; it starts deriving. If you keep reference notes, they only
pay off when the model reads them before it works.

## The incident

I kept a reference file in the repo cataloguing the quirks of a library we
depend on — the exact answers, written down after we had learned them the
hard way. In a later session the model hit one of those quirks and derived
the answer again from scratch, arriving at the same conclusion the file
already stated. The work was competent and completely redundant.

## The rule

Point the model at the notes before it investigates. A standing
instruction — "before probing library or browser behavior, grep the
reference docs and the known-issues file" — turns a written answer from
decoration into a first step. A note nobody reads is a note nobody has.

## Prior art

**Verdict: PARTIAL.** The behavioral mechanism has a strong recent match:
Vercel's engineering eval (Jan 2026) found an on-demand "skills" setup scored
no better than baseline because in most cases the model never chose to invoke
it — "there's no moment where the agent must decide 'should I look this up?'"
— and always-loading the content fixed it. "Codified Context"
(arXiv:2602.20478) shows a written spec preventing an agent from re-deriving
what was already established; a Claude Code subagents piece and an HN thread
corroborate agents not reading AGENTS.md / CLAUDE.md unless told each session.
The delta: the specific incident — a dependency-quirks catalogue skipped in a
later, independent session, the answer re-derived competently and redundantly
— and the cheap instruction-level fix (grep the notes first) rather than
Vercel's structural fix (remove the decision point by always-loading). Cousin
of [the demonstration reflex](../the-demonstration-reflex.md).
