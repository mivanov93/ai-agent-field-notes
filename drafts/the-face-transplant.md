# The face transplant

**Claim:** a mockup is cheap to make and looks like the destination, so it is
easy to believe the hard part is done. It is not. Turning a mockup into a
working prototype — and especially grafting a mockup onto a system that already
exists — is expensive and brutal, closer to a face transplant than a coat of
paint. The mock is a face designed in isolation; the running system is a
different body, with its own anatomy, and it does not want to wear someone
else's face.

## The image

Face/Off — you cut the face off one person and stitch it onto another. On
screen it is seamless. In life the two were never built to fit: the bones
underneath are different, the nerves do not line up, and the body spends the
rest of the film rejecting the graft. A mockup applied to a real system is that
operation. The mock was drawn against nothing — no state, no components, no
constraints — and the running system has all three, arranged its own way. Every
place the design assumed a shape the system does not have becomes surgery.

## Why it's expensive

- **The mock has no anatomy.** It is pixels. The system is state, components,
  data flow, edge cases, and a hundred behaviors the mock never showed. Making
  the system look like the mock means threading the design through all of that.
- **Looks-right is not is-right.** A screen that matches the mock in a static
  render can break the moment it has to hold real state — the same trap as
  [all green, still broken](all-green-still-broken.md): the mock is a stand-in,
  and the real served thing is where it actually has to fit.
- **The gap is invisible up front.** The mock makes the destination look
  already reached, so the transplant gets under-planned every time.

## The rule

Budget the application, not the mockup. The mock is the cheap part; assume the
graft onto the real system is the bulk of the work, plan it as its own phase,
and gate it against the real running system, not a static preview. When you
can, design against the system's real anatomy from the start — so there is a
face to grow rather than one to transplant.

## Prior art

*Status: draft — prior art not yet searched.* Neighbor territory:
design-to-code and "design handoff" friction, the gap between hi-fi prototypes
and production. The angle to defend is the transplant framing — a mock applied
to an existing system as a graft the system rejects, not a reskin — and
budgeting the application as the real cost.
