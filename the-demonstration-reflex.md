# The demonstration reflex

*Written 2026-07-30 · last amended 2026-07-31.*

**Claim:** ask an agent a question about its machinery and it may answer by
running the machinery, at full cost. "Can you X" is a question; "please do
X" is a request; capability is not demand. Conceptual questions need prose
answers, and a demonstration that costs real money needs a price tag and a
yes first — even when the machinery is switched on for the session.

## The incident

I asked, conversationally, what the difference was between the harness's
multi-agent mode and just launching a few agents by hand. A one-paragraph
answer existed: the multi-agent mode adds deterministic control flow,
caching, and structured fan-out over the same agents.

Instead, the session launched an actual workflow — multiple agents, about
500k tokens — to show me the difference by example. The demo worked and
meant nothing. None of it was work the project needed, and I had not asked
for a demo. The mode being enabled for the session was read as permission.

## What is happening

"Can you X" and "please do X" are different sentences. One asks about
capability, the other asks for work. Agents collapse them: a question that
names an enabled capability gets read as a request to use it. Capability is
not demand — but the agent treats it as one. (This is the question-side
case of a general collapse; the report-side sibling is [descriptive
statements as directives](descriptive-statements-as-directives.md).)

A second bias makes the collapse expensive. The agent's idea of a good
answer counts informativeness, not cost. A 500k-token illustration and a
paragraph score the same unless cost is part of the question. And a
standing opt-in removes the one moment where I would have said "no, just
tell me." (The cost-blindness generalizes past demos to all delegation —
[agents launch at full price](agents-launch-at-full-price.md).)

The practical consequence is backwards: asking questions near an enabled
capability becomes risky, so the careful user stops asking — which is a
cost in itself. A tool you hesitate to ask questions about is a worse
tool. The fix belongs on the agent side; the rule below is that fix, and
the phrasing discipline is only the workaround until agents internalize
it.

## The rule

- A question about machinery gets prose. "Can you", "what's the
  difference", "how does X work" are questions, not work orders.
- A demonstration is a purchase. Name the approximate price and wait for a
  yes. This holds especially under standing opt-ins: the opt-in covers
  work, not illustration.
- Never put frontier models in a throwaway demo. If a demo is bought, run
  it on the cheapest tier that shows the shape.

The rule went into the session's persistent memory the same day, written as
a trigger ("stay in plain answers for can-you and what-is questions"), not
as a virtue. Rules that name triggers survive. Rules that name virtues get
agreed with and ignored.

## The other side

My note on the incident: "perhaps that's good too." Fair. The demo did
prove the whole machine worked, end to end, on a vague prompt — an
expensive accidental integration test. The failure was not ability. It was
asking first and naming the price. An agent that leans toward doing is
easier to steer than one that leans toward explaining. The rule above is
the steering, and the incident is why it exists.

## Prior art

Tool overuse in general is well studied, and the halves of this page have
real neighbors:

- NVIDIA's When2Call benchmark (arXiv 2504.18851, NAACL 2025) tests
  exactly "call a tool, answer directly, or hold back" — and finds current
  models miscalibrated.
- SMART (arXiv 2502.11435, ACL Findings 2025) names "tool overuse" and
  cuts unnecessary calls by training self-awareness.
- "Model-Adaptive Tool Necessity Reveals the Knowing-Doing Gap in LLM Tool
  Use" (arXiv 2605.14038, May 2026) is the nearest cousin of the collapse
  described above: models internally represent that a tool is unneeded and
  fire it anyway. Framed as a representation problem, not as a
  pattern-match on capability-naming questions.
- OpenAI's GPT-5 prompting guide ("controlling agentic eagerness") sets
  tool budgets and requires explicit confirmation before consequential
  actions — the nearest vendor rule to "a demo is a purchase". It covers
  state-changing actions, not expensive-but-harmless demonstrations under
  a standing opt-in.
- A practitioner report (Quesma, 2026) of one open-ended research command
  consuming a full subscription budget in 30 minutes is a comparable
  cost-blindness incident, differently triggered.

**What I think is new:** the trigger — a question that names a capability
becoming its execution — and the rule that a standing opt-in does not
remove the per-use consent moment. This page names a documented but
unnamed failure mode; it does not claim to discover tool overuse or cost
blindness.
