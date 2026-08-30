# Don't interrupt a working agent

*Written 2026-07-31.*

**Claim:** an agent already running a task treats new text arriving mid-run
with suspicion. A message you send to steer it can read, from inside, like
content slipped in by whatever it was reading — a hijack attempt — and get
ignored or refused rather than obeyed. The time to give instructions is
before it starts.

## The incident

I sent a follow-up message to a background agent while it was mid-task, to
correct its course. Instead of adjusting, it flagged the message as
possibly hostile: an instruction appearing partway through its work had the
shape of the injection attacks it is trained to resist, so it declined to
act on it. The instruction was mine and entirely legitimate. The channel it
arrived on made it look like an attack.

## The rule

Put everything an agent needs in the prompt that launches it. If you keep
needing to steer mid-run, that is a sign the opening brief was
underspecified. When you genuinely must step in, expect that a mid-task
message may not land — and be ready to stop the agent and restart it with a
corrected brief instead.

## Prior art

**Verdict: PARTIAL, with one near-exact match.** A hermes-agent GitHub issue
(#36934, 2026-06) documents the mechanism precisely: a legitimate operator
`/steer` message sent mid-run, appended after a tool result, gets flagged by
the model (Opus 4.8) as possible injection and refused. The structural reason
is in "AI Agents May Always Fall for Prompt Injections" (arXiv:2605.17634): a
high-recall injection defense must sometimes reject legitimate flows; and the
instruction-hierarchy line (Wallace et al., arXiv:2404.13208; the many-tier
follow-up arXiv:2604.09443) explains why mid-context instructions are
distrusted. Open Claude Code feature requests confirm there is no reliable
mid-run steering channel today. The delta: the operator-facing prescription —
treat mid-run steering as unreliable by design, front-load the brief, and be
ready to stop-and-relaunch rather than trust a correction landed.
