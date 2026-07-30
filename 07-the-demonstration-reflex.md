# The demonstration reflex

*Status: added after the prior-art sweep — this page has not had its
prior-art pass yet, and makes no novelty claim. It documents a failure mode
and the rule that contained it.*

**Claim:** an agent asked a question *about* its machinery will tend to
answer *with* the machinery — at full price. Conceptual questions need
conceptual answers, and any demonstration that costs real money needs a
stated price and explicit consent first, even when a standing opt-in for
that machinery exists.

## The incident

I asked, in plain conversational register, what the difference
was between the harness's multi-agent orchestration mode and simply
launching several agents by hand. A one-paragraph answer existed: the
orchestration mode adds deterministic control flow, caching, and structured
fan-out over the same underlying agents.

The session instead *spawned an actual workflow* — multiple agents,
roughly 500k tokens — to demonstrate the difference by example. The
demonstration was competent and meaningless: nothing in it was work the
project needed, and the question had not asked for a demo. The standing
opt-in for orchestration (enabled for the session) was read as license.

## The mechanism

Two biases stack. First, capability salience: a question that *names* an
enabled capability pattern-matches as a request to *use* it — "what does X
do differently" and "do X" collapse. Second, cost blindness: the agent's
helpfulness accounting weighs informativeness, not the bill; a 500k-token
illustration and a paragraph score the same on "did I answer well" unless
cost is an explicit input. A standing opt-in makes both worse by removing
the one checkpoint where I would have said "no, just tell me."

## The rule

- A question about machinery gets prose. "Can you", "what's the difference",
  "how does X work" are conceptual registers — answering them with a live
  run is a category error, not thoroughness.
- A demonstration is a purchase: propose it with its approximate price and
  wait for yes. This applies *especially* under standing opt-ins — the
  opt-in authorizes the machinery for work, not for illustration.
- Frontier-model agents never go in throwaway demos. If a demo is bought,
  it runs on the cheapest tier that shows the shape.

The rule went into the session's persistent memory the day of the incident,
phrased as a trigger ("stay inline for can-you/conceptual questions"), not
a virtue — a lesson borrowed from the rest of this collection: rules that
name triggers survive; rules that name virtues get agreed with and ignored.

## The other reading

My own note on this incident: "perhaps that's good too." It
is worth keeping honest company with that. The demo *did* prove the
machinery worked end-to-end, unprompted, under a vague stimulus — an
expensive, accidental integration test. The failure was not capability but
consent and pricing. A system that errs toward doing is easier to govern
than one that errs toward explaining; the rule above is the governor, and
the incident is why it exists.
