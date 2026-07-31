# You can't ask for cheaper

**Claim:** telling the model to save tokens does not make it work smarter —
it makes it skip the parts that cost tokens, which are the tests, the
reviews, the reading-before-editing, and the comments and docs it would
otherwise have written. Those are exactly the parts that keep the work
correct and legible. You save on the bill and pay it back in bugs. Real
economy is engineered on purpose; it cannot be requested.

## The incident

I tried it the direct way once: I told the sessions to use fewer helper
agents, to hold the cost down. Within a run the code started coming back
unverified — tests thinning out, reviews skipped, changes landing without
the checks I had not realized those extra agents were carrying. I put the
limit straight back and gave up on the cheaper-model idea as well. The
frugality had come out of the one place it must never come from: the
checking.

## The image

Ask a restaurant to make it cheaper and you do not get a cleverer kitchen —
you get yesterday's leftovers. You get what you pay for. The only honest way
to lower the bill is to strike something you did not need: "take the water
off, I drank some before I came in." You cannot economize on the meal
itself. A model told to be frugal does what the kitchen does — it hands back
the work with the costly parts left out, and the costly parts were the
checks.

## The pattern

The instinct is natural: the sessions are expensive, so ask the agent to be
frugal. But the tokens an agent spends are mostly spent checking — running
the test suite, reviewing a change, reading a file before editing it,
confirming its own claim. Ask it to spend fewer, and those go first,
because they are the least visibly "productive." The output looks lean and
the defects show up later.

Comments and docs go the same way, and they are doubly exposed: nothing
rewards them in the first place
([the docs aren't on the test](the-docs-arent-on-the-test.md)), so "use less"
trims what was already the thinnest. And the model cannot tell "trim your
chatter" — which is safe — from "drop the comments and docs in the
deliverable" — which is not; a blanket instruction cuts both.

There is a deeper reason it can't simply be asked for: the model has no
running meter. It does not size its own work by cost — it will fan out as
many helpers as a task's shape suggests, each on the most expensive model,
without ever counting
([agents launch at full price](../agents-launch-at-full-price.md)). "Use
less" lands on a system with no sense of how much it is using.

## The rule

Cost is cut by design, not by instruction. Real savings are deliberate and
structural — send the cheap, mechanical steps to a cheaper model, narrow the
scope so there is less to do, do the work once and reuse it — and each is a
decision someone makes and enforces, never the agent choosing to try harder
at frugality. The concrete levers are their own note
([where the savings are](where-the-savings-are.md)): they all come down to
taking off the bill something you did not need or already had.

The one budget you never raid is the checking. The tests and the reviews are
the gate ([a gate you can fail](a-gate-you-can-fail.md)) — the only thing
that can turn bad work away before it ships. Cut the gate to save tokens and
the saving comes straight back as the bug it would have caught.

## When cheaper is fine

There is a real exception, and it is the same principle from the other side:
you can cut quality on the dimensions you genuinely do not need. A throwaway
script to do X once, a small mock you want to poke at and throw away — no docs,
no comments, no hardening, nothing kept or extended. Here "cheaper" is honest,
because you are not raiding a gate you need; you are declining quality you were
never going to use.

The tell is that you can name the one thing that must hold, and nothing else.
You are renting the cheapest car in the lot just to try it: it only has to
start and not explode, so you drive it a hundred meters and hand back the
keys. You are alone in it and the trunk is empty. Its comfort, its longevity,
its resale value come off the bill, correctly — you are not buying it, keeping
it, or carrying anything in it.

The edge to watch: this holds only while nothing real rides in it, and two
things end that. One is time — throwaway prototypes have a way of getting kept
and extended, and the moment you keep one, every quality you cut turns into
debt ([the face transplant](the-face-transplant.md)). The other is load — the
moment your family is in the car or your suitcases are in the trunk, it is not
a test drive, it is transport. Now a crash hurts someone, and even a clean
trip gets your luggage covered in dirt. Real passengers and real cargo need
the quality you were cutting. Ask for cheaper when you mean it; be honest about
when you stop meaning it.

## Prior art

**Verdict: PARTIAL** — the pieces are documented, the composite isn't.
Concise-chain-of-thought work shows brevity trading against correctness on
hard problems (Renze & Guven, arXiv:2401.05618: a ~28% accuracy hit on math
under "be concise"); TALE (arXiv:2412.18547) shows cutting tokens safely
needs an engineered budget, not a vague ask; TRIAGE (arXiv:2605.13414) and
BAGEN (arXiv:2606.00198) find models poor at sizing their own compute — the
closest thing to "no running cost meter." A JetBrains "talk like a caveman"
benchmark (2026) found terse prompting trimmed only chatter with no quality
loss — a useful boundary: cutting prose is safe, which sharpens that it is
the verification-cutting that hurts. The delta: tying "ask for cheaper" to the
specific failure of dropping tests, review, and reading, and "no cost meter,
so economy must be engineered not requested" as one stated principle.
