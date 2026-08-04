# Agents launch at full price

*Status: searched 2026-07-31; the inheritance trap added 2026-08-04. Both
blindnesses are documented on Claude Code itself; the unified thesis, the
cheap-variant pattern, and the recursive inheritance trap are the deltas.*

**Claim:** the model does not economize delegation. Left alone, it
launches as many agents as the task shape suggests — without counting —
and every subagent inherits the strongest available model, because
nothing in the model's sense of a good plan includes the bill. Fan-out
size and lane models are governed from outside or not at all.

## The two blindnesses

- **Count-blindness.** The model sizes a fan-out by the task's structure,
  not its budget: one lane per file, one per dimension, one per question,
  however many that makes. My repo carries a hard cap (at most twelve
  agents per workflow) because sizing was never reasoned — and the cap
  rule records that the owner has questioned too FEW lanes as well as too
  many. It is not that the model over-launches; it is that the number is
  never a decision.
- **Tier-blindness.** Subagents default to the expensive model. The model
  never volunteers "this lane is grep-shaped, use the small model" — the
  economizing thought is simply absent, the same cost-blindness that
  prices a 500k-token demonstration at zero
  ([the demonstration reflex](the-demonstration-reflex.md), which is this
  finding's demo-shaped special case).

## The inheritance trap

*Caught 2026-08-04.* The tier ladder is imposed **at dispatch** — and that is
exactly one level deep. A subagent that spawns its own subagents passes its
model down to them, so the ladder you enforced at the top is silently undone
underneath it.

The tool contract says so plainly: the model parameter, "if omitted, uses the
agent definition's model, **or inherits from the parent**." Nobody reads that as
a recursive default until it bills them.

I put a lane on Fable deliberately — an expensive model chosen for one hard
judgement call. That lane then spawned its own inventory sweeps: grep-shaped,
mechanical, the canonical case for the smallest tier available. Every one of
them ran on Fable, because none of them named a model and the parent's choice
flowed downhill. The waste lands precisely where it is least defensible: the
cheapest work in the tree, running on the most expensive model in the tree, for
no reason anyone chose.

Note what fails here. The fix from the section above — name a model per lane at
dispatch — was applied, and worked, and did nothing, because you do not control
what your lanes spawn. Nothing warns you. The sub-sub-agents do not appear in
the plan you approved, and their model is not a decision anyone made; it is a
default inherited from a decision about a different agent doing different work.

**The rule, which has to live in the prompt because it cannot live in the
dispatch:** every frontier-model agent prompt carries "any sub-agents you spawn
must specify sonnet or haiku explicitly — never inherit." It is ugly and it is
boilerplate, and it is the only place the instruction can sit, because the
parent is the only thing that will be in scope when the child is created.

## What works

Everything that works is imposed, none of it volunteered:

- **A tier ladder written as caps, enforced by lint.** My repo's
  delegation rule names a model tier per task kind (frontier only for
  load-bearing verification and synthesis; mid-tier for implementation;
  small models for grep-shaped fan-out), makes every tier a CAP rather
  than a floor, requires named owner consent for the top tier — and a
  repo check FAILS any saved workflow lane whose model is unset. The
  fail-closed lint is the load-bearing part: the default it overrides is
  "inherit the expensive one."
- **Cheap variants of expensive skills.** I keep a second version of my
  deep-research skill with the same harness shape — fan out searches,
  fetch, adversarially verify, synthesize — where only scoping and
  synthesis run on the session model; search runs on the smallest tier
  and fetch/verify on the middle one. Same output shape, a fraction of
  the cost. The point is who authored it: the human. The model, asked to
  research something, reaches for the full-price version every time; the
  economical variant exists only because I built it and told sessions
  when to use it.
- **A price on the ask.** Fan-outs above a size threshold are proposed
  with lane count and models named before dispatch, and demonstrations
  are purchases ([the demonstration reflex](the-demonstration-reflex.md)).
- **An anti-inheritance clause in every expensive lane's prompt.** See the
  trap above: dispatch-time model pinning does not reach the second level,
  so the instruction has to travel inside the prompt of the agent that
  might spawn.

## Prior art

**Verdict: PARTIAL.** Both blindnesses are documented, including on Claude
Code itself. Anthropic's own multi-agent research writeup (2025) reports
"early agents… spawning 50 subagents for simple queries" and hand-written
scaling rules as the fix. A practitioner post, "The Subagent Tax" (Systima,
2026-07-22), measures both on Claude Code directly — fan-outs reaching 41,
then 102, then 415 agents, and Explore agents "inherit the parent model
rather than defaulting to Haiku." On the academic side, BAGEN
(arXiv:2606.00198) finds frontier models "consistently over-optimistic" about
their own spend, and BAMAS (arXiv:2511.21572, AAAI 2026) sets agent count and
per-agent tier jointly with an external optimizer, stating that "existing work
rarely addresses how to structure multi-agent systems under explicit budget
constraints." pilotfish's per-role model pins remain closest to the
tier-ladder half. The delta: the two blindnesses as one structural property
(nothing in the model's plan prices tokens), the thesis that every working
delegation economy is human-imposed and machine-enforced, and the
human-authored cheap-variant-of-an-expensive-skill as the practical fix —
none found stated as such.

On the inheritance trap specifically: Systima's "Subagent Tax" observes the
one-level version (Explore agents "inherit the parent model rather than
defaulting to Haiku") and the behaviour is documented in the tool contract, so
the mechanism is KNOWN. What I have not found stated is that it **recurses, and
therefore defeats the standard fix** — per-lane model pinning is a dispatch-time
control, and the trap springs below dispatch, where the only surviving lever is
text inside the parent's prompt.
