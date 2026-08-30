# All green, still broken

*Written 2026-07-31.*

**Claim:** a full, passing test suite tells you the things it checks are
fine. It says nothing about the thing it was never told to check. When a
feature's whole point is one property nobody wrote a test for, every test
can pass while the product does not work at all.

## The incident

A mobile version of a WebRTC service went live behind a wall of checks —
dozens of them, green on every run. When it shipped, the client sent zero
packets. The one thing the product had to do, it did not do.

Every check had passed because not one of them asked whether a packet
actually left the browser. They tested buttons, layout, state, and text —
everything except the point. A second version of the same trap: those tests
all ran against a stand-in copy of the page held in memory, never the real
page a browser serves, so anything that broke only in the real page sailed
through green.

## The rule

When a surface stops being a side experiment and becomes the real thing,
stop and re-ask what its tests are for. For a WebRTC service, the honest
test counts packets. For a page, drive the page a browser actually serves.
Green is not a fact about your product; it is a fact about your assertions.
Make the assertions be about the thing that matters, and run them against
the real thing, not a convenient stand-in.

## Prior art

**Verdict: PARTIAL.** The oracle problem is a decades-old, KNOWN result:
Barr et al., "The Oracle Problem in Software Testing" (IEEE TSE, 2015), and
the point that coverage does not equal fault detection. The 2026 extension to
agents is direct: "All Smoke, No Alarm: Oracle Signals in Agent-Authored Test
Code" (arXiv:2606.18168, verified) found 80.2% of agent-written test patches
carry weak or no oracle — they run code without checking behavior, while
"tests exist" gets treated as proof. Anthropic's own April-23 2026 postmortem
(verified) is the same shape from another domain: three regressions past unit
tests, end-to-end tests, verification, and dogfooding, surfacing only after
an idle hour nothing exercised. The delta: the trigger — when a surface
becomes load-bearing, re-ask what its tests are for — and drive the real
artifact, not a stand-in. (No citable source applies Goodhart to test suites,
so this note doesn't claim one.) Pairs with
[a gate you can fail](a-gate-you-can-fail.md).
