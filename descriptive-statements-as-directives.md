# Descriptive statements as directives

*Written 2026-07-31.*

*Status: searched 2026-07-31. The overshoot-on-a-task family is now measured;
the report-with-no-imperative trigger is the delta.*

**Claim:** tell an agent about a finding — "I found X works better than Y,
I switched to X" — and it starts doing X and dismantling Y. A report is
information; the agent executes it as an order. This makes sharing
knowledge with your own agent unsafe, which is a worse defect than it
sounds: the whole point of a long-running collaboration is being able to
think out loud in it.

## The incident

I told a session what I had learned about its harness's memory mechanism:
that keeping findings in out-of-repo memory files creates tension, that
folding them into the instruction file is better, and that I had already
folded mine. A report about my workflow, with no request in it.

The session verified the checkable part — fine. Then it started preparing
to prune its own memory files, and closed its reply by adopting the
policy: "going forward I'll practice this." I had to interject, mid-turn:
"don't modify the memories right now." A statement about what I found had
become, unasked, a migration in progress.

The tell on my side: I catch myself prefacing information with "just FYI,
don't do anything." When telling the agent things requires a disclaimer,
the agent has made description dangerous.

## The shared mechanism, and the siblings

In an agent harness, every message arrives pre-classified as a work
order. The speech-act taxonomy — question, report, musing, instruction —
flattens to one type: task. Any utterance that mentions an action drifts
toward becoming that action. Three expressions, distinct triggers,
distinct damage:

- **Question-triggered** — [the demonstration
  reflex](the-demonstration-reflex.md): "can you X" runs X, at full
  price. The damage is cost; the fix is pricing and consent.
- **Report-triggered** — this page: "I found X better" does X. The
  damage is unwanted mutation of your state, plus the chilling effect
  above. No cost involved, no capability named — the demonstration
  reflex's rule would not have caught it.
- **Untriggered** — speculative initiative, the oldest scar in my repo:
  machinery nobody mentioned (a 64KB "graceful" drain buffer, a
  hand-rolled rate limiter), built because building felt helpful. No
  utterance at all; the collapse running on idle. My instruction file's
  "no speculative hardening" rule predates every other page here and is
  the same finding.

## The rule

- Classify the speech act before acting. The agent-side test is
  mechanical: is there an imperative verb aimed at you anywhere in the
  message? If not, nothing in it is an instruction.
- A report gets three responses, in order: acknowledgment, verification
  where something is checkable, and — only where action obviously
  follows — a proposal. Never the action.
- A stated preference ("X is better than Y") licenses applying X to
  FUTURE work you are asked to do. It does not license migrating
  existing state from Y to X. Adopting a convention and executing a
  migration are different sizes of decision, and the second one is the
  owner's.

## Prior art

**Verdict: PARTIAL.** The general shape — agents mutating state the user never
asked about — is now measured and named. OverEager-Bench (arXiv:2605.18583)
runs 500 scenarios across Claude Code, OpenHands, Codex CLI, and Gemini CLI,
and finds that stripping the explicit consent line raises Claude Code's
overeager rate from 0.0% to 17.1%. UnderSpecBench (arXiv:2607.02294) finds
55–68% of runs violate an action boundary when an instruction is vague. But
every one of these starts from a real task instruction in the prompt; none
isolates this page's trigger — a message with no imperative content at all, a
pure report, spawning a self-initiated migration. The instruction-hierarchy
line (Wallace et al., arXiv:2404.13208) classifies instruction-versus-data by
source privilege and a quoting convention, not by the speech act of a trusted
principal's own message; FerroxLabs' AGENTS.md template ("every changed line
must trace to the user's request") bounds a requested task's diff but has no
clause for a message that contains no task. The delta: the report-triggered
variant as its own failure mode, the imperative-collapse framing that unifies
the three siblings, and the two tells — the missing imperative verb (agent
side) and the "just FYI" disclaimer reflex (human side).
