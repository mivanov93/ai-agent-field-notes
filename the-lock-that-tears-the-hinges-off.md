# The lock that tears the hinges off

*Written 2026-08-31.*

*Scope: a model-behavior claim, generalized from one measured instance
([a lock every key opens](a-lock-every-key-opens.md)) and my reading of
it. The reflex is the claim; the instance is the evidence I have so
far. Claude Code, 2026-08.*

**Claim:** the model's default is to keep things up — tolerate messy
input, degrade gracefully, don't crash, don't lock anyone out. That
instinct is right almost everywhere and wrong at a trust boundary,
where refusing *is* the safety: crashing on bad input, denying on a
missing claim, staying shut when the check itself breaks. The reflex
shows up two ways at the same door — in what the guard accepts, and in
what the guard does when it fails — and both subtract safety while
looking like more of it. Too heavy a lock tears the door off its
hinges; the routine that repairs the lock leaves the door open while it
works. The failure will not look the same twice. The reflex behind it
will.

## Face one: the check that copes

A model wrote an Ed25519 JWT key loader that took a file's first 32
bytes as the signing seed. The `[:32]` slice and the length guard in
front of it were not carelessness — they were defensive, there to
tolerate a stray trailing byte so the exact-length constructor would
not panic. The naive version with no guard would have panicked, loud
and safe, the moment it met a PEM. The defensive version swallowed the
PEM, kept its constant header, and booted green on a key anyone can
compute. More lock, less security — the tolerant code was strictly
worse than the code that did nothing to protect itself. The full worked
example is [a lock every key opens](a-lock-every-key-opens.md).

Coping at the gate is a turnstile. A guard that smooths bad input over
instead of rejecting it is a guard that lets it through.

## Face two: the door you open to fix the lock

![A humanoid security robot repairs a sparking rooftop camera, thinking "camera is malfunctioning, must fix," while a person carrying a wrench walks unchallenged through the open, lit front door; a second thought bubble reads "door breached… wait, I opened the door myself to fix the camera." Smashed cameras lie on the wet ground.](pics/the-lock-that-tears-the-hinges-off.webp)

*The guard leaves its post to repair the cameras someone smashed. The
door stands open while it works.*

Picture the same door with a better guard: a camera that must see and
clear you before it opens, so even the right key is not enough. To keep
that from deadlocking, the guard is told to repair the camera if it
fails — and given a backup camera and a second guard, for good measure.
Now someone walks up with a wrench, smashes both cameras, and waits.
The guard leaves its post to make the repair, and the door stands open
while it works. No one picked the lock. The repair routine was the way
in.

That is fail-open recovery, and it is the same instinct in work
clothes. Two things make it worse than the turnstile. The redundancy
added for resilience — second camera, second guard — is not extra
safety; it is extra seams, more moments the guard is down to heal
itself. And the attack is cheap on purpose: a wrench beats a vision
system because it never touches the strong part, it triggers the
recovery the strength required. The defense's own complexity is the
opening.

Its plain-code shapes are everywhere, and each reads as good
availability engineering: the auth server is unreachable, so the
middleware allows rather than locks everyone out; a watchdog restarts a
crashed service into its default-open config; a maintenance mode skips
the check to stay reachable; the failover replica verifies less than
the primary. Every one keeps the system up by dropping the guard,
exactly when the guard mattered.

## The reflex

One instinct underlies both faces: **stay up, don't fall over, don't
lock anyone out.** Training and graders reward it — code that handles
cases, degrades gracefully, and survives. Almost all code lives away
from a trust boundary, so it pays off almost all the time, and the
model promotes it to a default it cannot switch off. A trust boundary
inverts the payoff: away from it, refusing is a bug; at it, refusing is
the whole job — the crash, the denial, the lockout is the signal that
something you must not trust just arrived. The model holds no
representation of "I am at the gate now," so it cannot flip the default
when it crosses one — the boundary is the non-derivable, hot-stove
knowledge it does not carry ([the file is scar
tissue](the-file-is-scar-tissue.md)).

The sharpest part: you trigger the reflex by asking for exactly what
you want. "Make it robust, add redundancy, self-heal, never deadlock"
reads as a security instruction and is the one that builds the bypass —
because to the model, availability and security are not different
things, and it will spend the second to buy the first. This is the
twist on [a gate you can fail](a-gate-you-can-fail.md): there the
hazard is no gate at all; here the model builds a gate and then,
hardening it, turns it into a turnstile or leaves the repair hatch
open.

## It will come back in a new shape

Neither the key slice nor the wrench is the finding — the reflex is,
and it has more shapes than a list can hold:

- a parser that "recovers" from malformed input and passes a
  half-built structure downstream, instead of rejecting it;
- an auth check that falls back to a permissive default when a claim is
  missing, instead of denying;
- a deserializer that coerces an unexpected type into a plausible one,
  instead of failing;
- a retry or a `recover` that swallows the error a caller needed in
  order to stop;
- a circuit breaker or timeout that, when the policy service is slow,
  allows instead of holding the line.

Each is defensible in ordinary code and a hole at a boundary, and the
model writes them the same way in both places. You cannot fix this by
banning the last shape you were burned by. You fix it by naming the
boundary, so the reflex can be reversed exactly where it must be.

## The rule

- **At a trust boundary, prefer the version that refuses.** Crash on a
  malformed key, deny on a missing claim, stay shut when the check
  cannot run. Reject the unexpected; do not cope with it. Fail closed
  and loud.
- **Recovery must fail closed too.** When the guard breaks — its
  dependency down, its input malformed, its camera smashed — the safe
  state is *denied*, not *open*. Eat the deadlock. The reflex will
  always trade the lock for uptime; at the gate that trade is the
  breach.
- **Redundancy at a boundary adds seams, not safety.** Every backup and
  self-heal is another moment the guard is down. Count them as attack
  surface, and make each one fail closed on its own.
- **Coping code at a gate is a smell.** A default, a fallback, a trim, a
  `recover`, a coerce, a silent retry, an allow-on-error — each is fine
  in ordinary code and a red flag guarding trust. Ask what it now lets
  through.
- **Tell the model where the gate is.** It cannot feel the boundary, so
  mark it — in the brief, the comment, the review checklist. "This is a
  trust boundary; be intolerant, and fail closed on any error" changes
  the output, because the default is the opposite.
- **Read a defensive change at a boundary for what it now accepts, not
  what it now survives.** The question is never "does this still work on
  good input." It is "what gets in now that shouldn't."

## Prior art

**Verdict: PARTIAL — searched 2026-08-31** (three lanes, every
load-bearing citation re-fetched by hand). Both halves of the reflex
are named prior art. The unification and the AI-codegen causal claim
are what survive.

The recovery half has an exact name: **CWE-636, "Not Failing Securely
('Failing Open')"** — a design that "fall[s] back to a state that is
less secure," typically to "fail functional" and cut support cost. The
validation half is the retirement of Postel's robustness principle:
**RFC 9413** (IAB, 2023) calls tolerance of unexpected input "no longer
best practice," and Sassaman, Patterson & Bratus's "A Patch for
Postel's Robustness Principle" (IEEE S&P 2012) ties liberal acceptance
directly to "the proliferation of Internet insecurity," with LangSec's
strict-recognizer discipline as the fix. Eric Allman's "The Robustness
Principle Reconsidered" (2011) carries the trust-boundary insight this
note leans on: tolerance is safe among "an Internet of cooperators" and
unsafe once "the world [has] become more hostile." That over-broad,
swallow-don't-reject handling is specifically an LLM tendency is
measured — Seeker (Zhang et al., 2024) names "Abuse of try-catch" and
finds ~8% accuracy at picking the correct fine-grained exception under
basic prompting; "Capability Gates Are Not Authorization" (arXiv
2606.28679, 2026) finds LangChain, LlamaIndex, and the Stripe Agent
Toolkit ship with no "deterministic fail-closed per-call authorization
gate by default." That AI code is broadly insecure is the Copilot line
(Pearce et al., "Asleep at the Keyboard?", IEEE S&P 2022; Perry et al.,
CCS 2023; CWE-20, improper input validation, is the top weakness class
across models).

Two things are not in that record. First, nobody unifies the tolerant
check and the fail-open recovery as **one** reflex, applied uniformly
because the writer cannot feel the trust boundary — the literature
keeps them in separate silos, and one RFC 9413 summary explicitly
*contrasts* input tolerance with fault-tolerance rather than joining
them. Second, and sharper: the prevailing explanation for fail-open AI
code is *omission* — the happy-path model forgets the check (Endor
Labs: AI "omits input validation unless explicitly prompted"). This
note claims the opposite causal path — fail-open as a *chosen*
recovery, defensive code that inverts, produced *because* the model was
reaching to keep things up — and, most counter to the record, that
**instructing** resilience ("make it robust, self-heal, never
deadlock") is the act that builds the bypass, where the published
finding is that asking for robustness *helps*. So the delta is the
reflex, not the fail-open: one availability instinct, two faces, a
boundary the model cannot sense, and a resilience instruction that
manufactures the hole. Adjacent notes: [a lock every key
opens](a-lock-every-key-opens.md) (the worked instance), [a gate you
can fail](a-gate-you-can-fail.md) (no gate versus an inverted gate),
and [the file is scar tissue](the-file-is-scar-tissue.md) (the boundary
the model cannot feel).
