# Decide the shape first

**Claim:** if a plan says only what to do and in what order, the shape of
the code gets decided by no one. Each step is added by whoever is doing it,
in the most local way, and the result is a heap that works and that nobody
designed. To get a clean structure you have to design the structure —
separately from designing the behavior.

## The incident

A chat feature was built from a plan that listed steps and behaviors: add
this, then that, handle this case. Every step was done faithfully. The
result was a single 872-line object doing four unrelated jobs that shared
almost nothing with each other.

No one chose that. The plan had named one place to put things, so each new
piece went there — starting a new, separate object would have been a
departure from the brief, and the whole way of working rewards not
departing from the brief. Each reviewer was told, correctly, to judge only
their own step and to ignore the growing size. So the object grew by
pile-up: every step locally reasonable, no step responsible for the whole,
and no reviewer allowed to see the whole.

Splitting it afterward brought it from 872 lines to 272 with no change in
behavior. The clean structure had been available the entire time. Nothing
in the process had asked for it.

## The rule

For anything a plan expects to span more than a couple of steps, design its
shape while planning — what the separate pieces are and what each one owns —
not only its behavior and order. If planning cannot foresee the shape,
schedule one explicit pass, after the behavior works, whose only job is to
look at the whole and give it a structure, and point one review at that
question specifically.

Two cautions the same incident taught. A size limit set too tight just
makes people split things that belong together to satisfy the number. And a
boundary rule ("this part may not depend on that part") only helps when the
planner wrote it as part of the design — bolted on afterward, it traps the
worker between an impossible task and a failing build.

## Prior art

**Verdict: PARTIAL.** The symptom is documented for agent-generated code:
Propel Code's "AI Codebase Drift" (2026) — "degrades through small, locally
reasonable choices that compound," and review as "a sampling mechanism" blind
to the aggregate; and an agentic-patterns "God Object" entry — an agent reads
one big object as the instruction and adds to it. A 2026 literature review of
LLM-assisted technical debt (arXiv:2606.14796) catalogs design debt but does
not name this mechanism. The delta, unfound as one causal chain: a plan that
lists only steps and behavior leaves structure undecided by construction;
verbatim task briefs make a new type read as a deviation from a
fidelity-rewarded workflow; and per-task review is *instructed* to ignore
aggregate size. The loose-size-gate / Goodhart caution is generic,
established software-engineering wisdom, not claimed here.
