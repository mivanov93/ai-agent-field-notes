# Where the savings are

**Claim:** you cannot make an agent cheaper by asking; you make it cheaper
by taking off the bill what you did not need or already had. The waste is
never the meal — the reasoning and the checks — it is what sits beside it:
work re-derived that could have been done once, lessons not written down so
a run goes wrong and must be redone, tools loaded and never used, context
re-read that could have been cached. All of it is cut by setup, not by
instruction. And there is a floor under all of it: you cannot under-buy the
model the job needs and call it a saving.

## The principle

You can only economize on what your order contains and you did not need.
Take the water off the bill — you drank some before you came in. For an
agent, the waste is never the meal: the reasoning and the checks are what
you came for. The waste is everything carried alongside it — an answer
derived from scratch that was already written down, a menu of tools nobody
orders from, the same long preamble paid for on every turn. Strike those
and the work is untouched. This is the honest half of
[you can't ask for cheaper](you-cant-ask-for-cheaper.md).

## Do the work once

Every answer an agent derives, it derives again next time unless you wrote
it down. The instruction file, the reference notes, the decision record, a
prepared data file — each is work done once and read many times. A day
spent writing the reference file is not overhead; it is the derivation you
are refusing to pay for on every session afterward
([it's already written down](its-already-written-down.md)). The written
answer is the cheapest token you will ever spend, because it stands in for
the same reasoning done fresh a hundred times.

## Write the scar tissue

The instruction file is the same "do it once" lever, pointed at the
knowledge that is not a fact to look up but a lesson about how this project
bites: the stove that is hot, the check that must run, the tool that isn't
there. Written down once, it is shared with every session
([the file is scar tissue](../the-file-is-scar-tissue.md)) — but it saves a
second way the reference notes do not. It prevents failed runs. A session
that goes wrong — deletes the wrong thing, works on top of another agent,
chases a limitation that was fixed months ago — is not cheaper, it is pure
waste plus the cost of cleaning up after it. A single scar-tissue line that
keeps the model off the hot stove saves the whole botched session, not just
one re-derivation. The cheapest run is the one that did not have to be done
twice.

The sharpest version is the agent you launch. A background agent can burn a
large amount of tokens before it returns anything at all, so if it started
from the wrong state — the wrong branch, the wrong parameters, a crucial
instruction left out of its brief — the whole run is lost, every token of
it, with nothing to show. That is the biggest single waste there is: not a
slow agent, a doomed one. It is why the brief goes in complete before you
dispatch — a correction sent mid-run may not even land
([don't interrupt a working agent](dont-interrupt-a-working-agent.md)) — and
why the launch itself is worth pricing
([agents launch at full price](../agents-launch-at-full-price.md)). The
cheapest agent is the one you did not have to run a second time because you
set it up right the first.

## Unload what you don't use

Skills, tool-servers, plugins, and language helpers a project has no use for
still get loaded and read on every session. One project I measured loaded
roughly fifteen of them and called zero
([the tools you never use](the-tools-you-never-use.md)). You are not
ordering from that part of the menu; stop paying to have it printed. Turn
off, per project, the packs this project does not touch.

## Cache the part that repeats

Most of what an agent reads is the same on every turn — the instruction
file, the standard preamble, the files already loaded. Prompt caching lets
the model reuse that already-processed prefix instead of paying to read it
from scratch again. Keep the stable material stable and near the front so
the cache keeps hitting, and let the part that changes come last. A cache
hit is the same context at a fraction of the price — paying once and
reusing, in its purest form.

## The truck you actually need

There is a floor under all of this, and asking below it is the same false
economy from the other side. You cannot move to a cheaper model where the
cheaper model cannot do the job. That is buying a car because it costs less
than a truck and then trying to load a three-ton metal statue into it — the
statue does not fit, and no amount of shoving changes that. The worse
version is the clever one: cutting the statue into pieces to lug home in the
car a load at a time. Now the statue is wrecked, you have made a dozen
trips, and you have paid more than the truck would have cost — all to avoid
renting the truck. Splitting a task small enough to force it onto a model
that cannot hold it is exactly that. Match the model to the load. The saving
is in cutting what you did not need, never in under-buying what you did.

## The through-line

None of these is the agent being frugal. Each is a person deciding, once, to
take something off the bill: derive it once, write the lesson down so the run
does not fail, unload what is unused, cache what repeats — and never
under-buy the model the job needs. You save on what you did not need beside
the meal. You never save on the meal, and never below the job.

## Prior art

**Verdict: PARTIAL** — each lever is documented; the unifying principle is
not. Pay-once docs: AGENTS.md guidance ("explain twice, document once").
Scar-tissue-against-failures: project lesson files (Osmani's self-improving
agents, 2026) — framed as correctness, not the token cost of a failed run;
the closest cost-framed version is an AWS piece where a workflow burned 20M
tokens and failed versus 1,234 with memory pointers. Unused-tool pruning: MCP
context-bloat writeups (see [the tools you never use](the-tools-you-never-use.md)).
Prompt caching: documented and dated by Anthropic (Aug 2024), OpenAI, and
Google, with cache-friendly ordering (stable prefix first) — the
strongest-supported lever. Model-routing floors: the routing/cascade
literature (RouteLLM, arXiv:2406.18665, and 2026 follow-ups on routing being
harder than task difficulty). The delta: all of it under one principle — cut
only what you did not need or already had, never the meal — plus the
mislaunched-agent economics and the explicit "floor" rule.
