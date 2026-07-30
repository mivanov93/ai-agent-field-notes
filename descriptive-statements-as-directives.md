# Descriptive statements as directives

*Status: not separately searched; the nearest swept neighbors are in
[the demonstration reflex](the-demonstration-reflex.md)'s prior art.*

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

Not separately searched. The swept neighbors sit in the demonstration
reflex's section: the tool-overuse benchmarks measure question-triggered
over-acting, and the agentic-eagerness guidance covers consequential
actions — neither addresses reports executed as orders. A dedicated
search should check instruction-following literature for speech-act
classification failures.

**What I think is new, pending that search:** the report-triggered
variant named as its own failure mode, the imperative-collapse framing
that unifies the three siblings, and the two tells — the missing
imperative verb on the agent side, the "just FYI" disclaimer reflex on
the human side.
