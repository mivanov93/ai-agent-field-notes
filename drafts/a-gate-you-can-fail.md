# A gate you can fail

**Claim:** an AI agent reliably fixes its own mistakes only when something
can reject its work. A check that fails tells it — and you — that the work
is not clean yet. Take the check away and it walks straight in carrying
whatever it carried, and no one finds out. This is not about how good the
model is; the best models need the gate too.

## The image

Picture a walled city with a gate. If the guards turn you away, you learn
something: you are not fit to enter — go down to the river, wash, come back
and try again. The gate that can refuse you is the only thing that tells
you you were dirty. A city with no gate lets everyone in exactly as they
arrived, clean or filthy, and no one is ever told which. A model with no
check to fail has no gate. It cannot tell whether it needs to go wash, so
it doesn't.

## What the measurements showed

Across a month of sessions on three models, the deepest finding did not
depend on which model I used. Wherever a real check stood at the gate — a
test that had to go green, a screen that had to match a target image — the
model washed and re-approached on its own, dozens of times, until it was
let in, with little help from me. Wherever there was no gate — a claim it
reasoned to, a change whose effect nothing measured — any model walked in
dirty, and the only guard on the wall was me, reading carefully.

The same split shows up in the benchmark numbers: models score far higher on
suites whose tasks ship with a hidden test to grade them than on real-world
code where nothing does. The task that carries its own check and the task
that does not are almost two different machines.

## The rule

- Before you trust the model on something that matters, ask: what can turn
  this away if it is wrong? If the answer is "nothing," you have not handed
  off the work — you have kept the checking and handed off only the typing.
- Build the gate first, and make it a real one. For a WebRTC service, a
  test that counts whether a packet actually left the browser. For a
  page, a check that drives the real running page, not a convenient
  stand-in. The gate is worth more than the choice of model.

## Prior art

**Verdict: PARTIAL.** The narrow result is near-KNOWN: LLMs cannot reliably
self-correct reasoning without external feedback — Huang et al., "Large
Language Models Cannot Self-Correct Reasoning Yet" (ICLR 2024,
arXiv:2310.01798), and the Kamoi et al. self-correction survey (TACL 2024,
arXiv:2406.01297): correction works only with a reliable external signal. Two
2026 papers extend it to coding agents — "The Verification Horizon"
(arXiv:2606.26300), verification as the harder problem, and "Building to the
Test" (arXiv:2606.28430, verified), where agents hit near-perfect hidden-test
scores while the library was "dead or absent." Anthropic's verification-loop
writing sits alongside (see [the link rule](../the-link-rule.md)). The delta:
the compact ceiling/floor formulation — the model raises the best case, the
gate raises the worst case, and the worst case is what ships — grounded in a
shipped incident. (No single source pairs a clean benchmark-vs-real number,
so this note states the split without one.) Washing links back to
[the dirty house](../the-dirty-house.md).
