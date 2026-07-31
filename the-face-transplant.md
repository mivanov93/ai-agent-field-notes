# The face transplant

**Claim:** applying a mock to a real system feels like a face transplant — cut
the mock's face off and stitch it onto the system. That is the tempting model,
and it is exactly the one that fails. The working move is the opposite: you
keep the system's own face and reshape it, bit by bit, until it matches the
mock held up beside it. The mock is a photograph — one frozen expression — and
the real system is a living face with many. The single frame the mock froze is
the part you can check; every other expression it never captured, you fix
blind.

## The tempting version, and why it fails

Face/Off — you cut the face off one person and graft it onto another. On screen
it is seamless. In life the two were never built to fit: different bones,
nerves that do not line up, a body that rejects the graft. That is what
"applying the mock" sounds like — lift the design and drop it onto the system —
and it fails for the same reason. The mock was shaped against nothing (no
state, no components, no behavior); the running system has all of it, arranged
its own way. There is no face to cut off, either: the mock is a photo, not a
thing you can transplant.

## The version that works

You keep the system's face and sculpt it. Put the mock beside the running
screen and reshape the screen until, in that one pose, it is a pixel-perfect
match. For that pose you have a gate: the mock is right there, so you compare
and correct until they agree. But the mock is a still photo — the real screen
loads, empties, errors, holds long text, shows live data — and the photo shows
none of it. The moment the screen moves off the frozen pose you have nothing to
compare against, and you are sculpting the other states from your own judgment,
one at a time, hoping each one holds.

## Why it's slow — and mostly un-gate-able

- **The mock is one frozen frame.** One state of one screen. The system has
  many, and the mock is silent on all but one.
- **One expression you can gate; the rest you can't.** For the frame the mock
  froze, the mock is the oracle — hold it adjacent and compare
  ([a gate you can fail](a-gate-you-can-fail.md)). For every other state there
  is no reference, so the check falls back to you, by eye, case by case.
- **A mock has no behavior.** It shows how one moment looks, never what happens
  on tap, on failure, on change. All of that you supply and validate yourself.

## The rule

Budget the application as slow, manual work — not a reskin, and not a
transplant. Keep the mock adjacent and compare against it for the one state it
froze; for the states it never showed, you are the check, so plan real time for
sculpting and validating them by hand
([all green, still broken](all-green-still-broken.md) is the same trap — a
match on one frame is not a match on the system). Where you can, design against
the real system's states from the start, so the reference covers more than a
single pose.

## Prior art

**Verdict: PARTIAL — the reframe is stronger, but not fully novel.** That a
static mock omits states (loading, empty, error) is common in design writing —
"The Happy Path Fallacy" (Uzma Noor, 2025), "The End of Static Mockups" (2026),
the usual design-handoff pieces — which treat the gap as something designers
should close by drawing more states. Against that literature this note is
sharper: it names *why* the mock fails as an oracle (one frozen state, no
behavior) and turns it into an operational rule. But the deeper structural
point has an independent, near-identical formulation in code-generation
research: Interaction2Code (arXiv:2411.03292) notes benchmarks "only contain
static web pages… and ignore the dynamic interaction," and a 2026 survey
(arXiv:2606.15932, verified) explicitly contrasts "single-output imitation"
(match one rendered artifact) with "multi-state verification." That thread
evaluates *generated* code against a mock, not the act of reshaping a live
system. So the delta that survives is the application, not the insight: the
single-frozen-state-as-partial-oracle observation is repeatedly rediscovered
across design blogs and ML research alike; what this page adds is applying it to
incrementally retrofitting an already-behaving system — reshape, not transplant
— and turning it into a budget rule: spend on the application, not the mockup.
