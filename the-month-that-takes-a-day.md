# The month that takes a day

**Claim:** a model cannot estimate how long something will take, or whether it
is worth attempting, because it does not know its own capabilities. Ask it "how
hard is X" and it answers from a world without the model in it: a human
integrating an unfamiliar library over a week, a research spike that eats a
month. But the agent does that same job with tools the estimate never priced —
it reads the whole API in one pass, pulls a working example, compiles until it
compiles, builds a check and iterates against it. So the honest-sounding
"that's too hard, it'll take a month" is often a day, and the model has just
talked you out of something that was cheap.

## The image

"Rome wasn't built in a day" is a proverb about hauling stone and timber by
hand for a lifetime. Roll a fleet of excavators, cranes, and bulldozers onto
the same site and it is not a lifetime — it is a season. The pyramids took a
generation of people dragging blocks up ramps; with the right machines, not
years. A model estimating your work is quoting the proverb: it prices the job
as if you will lug the trees and the stones yourself, because the machinery —
its own reading, iterating, and building — is invisible to it. It does not know
it is the excavator.

## The example

You want to try an idea that needs a gnarly, unfamiliar library — the kind
where a person would budget a month just to learn its shape before writing
anything real. Ask the model whether it's worth it and you may hear "that's a
big lift, maybe defer it." Do it anyway and watch: it reads the library's API
surface in one pass, pulls a working example, writes a thin harness, and
compiles-fixes-compiles until the thing runs — a day, maybe an afternoon. The
month was the *human's* month. The model quoted it, then did it in a day, and
never noticed the contradiction.

## The mechanism

The estimate comes from three places, all blind to the present. Its training
data prices work in **human** effort — "wiring up library X takes about a week"
is a real sentence from a real blog, about a person. Its sense of its own limits
is literature about older, weaker models
([the model doesn't know itself](the-model-doesnt-know-itself.md)). And that
literature is disproportionately a record of predecessors *failing* — forum
threads and papers where an LLM tried the task and could not do it. So a
frontier 2026 model, asked whether an AI can pull this off, answers from a
corpus of Llama-70B-class failures and warns you off — cautious on someone
else's behalf, because it is not Llama-70B. None of the three accounts for what
an agent actually does: turn a month of "read the docs, find the pattern, get it
building" into a loop that runs in an afternoon, because reading everything and
iterating against a compiler are cheap for it and expensive for a human. The
model quotes you the by-hand price while holding power tools it does not know it
has.

## Both directions, one cause

The bias mostly runs one way — over-quoting feasible work — because "this is
hard" is the safe-sounding answer and it discourages the attempt. But the same
not-knowing-itself makes the opposite error too: it will cheerfully call a
genuinely research-hard problem "an afternoon" and loop on it forever
([AI is not Mr. Fix-IT](ai-is-not-mr-fix-it.md)). Either way the number is
unreliable, for one reason: a thing that does not know what it can do cannot
say how long doing it will take.

## The rule

Don't take the model's feasibility or time estimate for its own work — it is
the one number it is structurally unfit to give. When it says "too hard" or "a
month," treat that as a hypothesis to test, not a verdict: the cost of trying is
often the very day you were told to fear, so attempt the thing and measure.
Capability is an experiment, not an interview
([the model doesn't know itself](the-model-doesnt-know-itself.md)) — and so is
difficulty. The one estimate worth trusting is the one you get by starting.

## Prior art

**Verdict: PARTIAL — and the core is now empirically confirmed.** "Can LLMs
Perceive Time?" (Garikaparthi, arXiv:2604.00010, 2026-03, verified) is the
near-direct hit: models overshoot their own task-duration estimates by 4–7×,
holding "propositional knowledge about duration from training but lacking
experiential grounding in their own inference time" — this note's mechanism,
measured, though at seconds-to-minutes latency rather than day-versus-month
project scale. A 2026 Frontiers paper on LLM-aware effort estimation supplies
the other half: classic models (COCOMO, story points) "assume effort is driven
by human labor," and LLMs complete 78% of high-complexity tasks in under 25% of
the expected human effort — but it avoids the model's own self-report. METR's
task-horizon work is the outside-view baseline this note contrasts against;
BAGEN (arXiv:2606.00198) is the opposite-direction error — budget
over-optimism, the [AI is not Mr. Fix-IT](ai-is-not-mr-fix-it.md) failure; and
Ryan McDonald's "AI Broke the Planning Fallacy" (2026) names the same
direction-reversal but blames humans' stale mental models, not the model's own
estimate. The delta: the composite — over-quoting *feasible* work at project
scale, from human-labor pricing plus a self-model built on predecessors
*failing*, with the behavioral consequence (it talks you out of cheap value)
and the fix (treat "too hard / a month" as a hypothesis to test by attempting,
not asking). It is stronger than the generic planning fallacy — it names the
opposite direction (over-, not under-estimation) and a specific, now-measured
mechanism.
