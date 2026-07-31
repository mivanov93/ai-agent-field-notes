# "It can't be done" is usually out of date

**Claim:** when the model tells you something is impossible, it is often
reporting the world as it was at its training cutoff, or the world as your
one installed version happens to be. Neither is the same as "impossible
now." A limitation is something you measure today, not something the model
remembers.

## The incident

A browser feature I needed — capturing a fake media stream inside a test —
the model reported as unsupported, with a confident explanation of why that
browser could not do it. The support had shipped twelve days earlier. The
model's picture of the browser predated the fix, and probing the copy
installed on my machine only told me what that one copy could do, not what
the current version could.

## The rule

When the model says "X is not possible," treat it as a claim about a
version and a date, and check the current state before believing it. Look
at the upstream project, not only the copy on your disk. A standing
instruction helps: "before declaring anything unsupported, check the latest
release." It turns a stale memory into a fresh measurement.

## Prior art

**Verdict: PARTIAL.** The staleness mechanism is well studied on the
generation side — models emit deprecated or outdated API code: CodeUpdateArena
(arXiv:2407.06249), the deprecated-API-usage study (arXiv:2406.09834,
ICSE'25), and "When LLMs Lag Behind" (arXiv:2604.09515). Context7 (Upstash)
is the tooling embodiment of the fix — inject live, version-specific docs so
the model stops answering from stale training. What the sweep did not find:
the assertion-side failure this note names — a model answering a capability
question with a confident "it can't be done" that was true only at an earlier
version — reframed as a claim bound to (version, date) that you falsify by
checking the current upstream release, not the locally installed copy.
Sibling to [the model's clock stopped at its cutoff](the-models-clock.md).
