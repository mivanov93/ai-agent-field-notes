# Vocabulary control

**Claim:** an AI collaborator needs a *governed* vocabulary, and the
governance has four parts that only work together: ban the model's pet
metaphors where they collide with domain terms; collision-check every new
coinage against the spec's own vocabulary before adopting it; keep the
glossary in decision records with supersession links; and the first time a
rule is violated while sitting in the model's context, escalate enforcement
to lint — more prose is proven not to work at that point.

## The incidents

- The model reached for **"watermark"** in a codebase whose media pipeline
  has a real `high-water` concept (the furthest-forward emitted sequence on
  an output stream). The metaphor wasn't wrong in general English — it was
  wrong *here*, blurring an exact term the code depends on.
- **"floor"** is that project's protocol term for the exclusive speaking
  grant (BFCP's word), backed by a state machine and wire messages. The
  model applied it to minimum supported browser versions — "browser floor" —
  which in a repo containing `floor.spec.ts` and a `FloorOffered` command
  reads as the wrong thing entirely. The fix renamed the concept to
  "minimum supported browser versions" and reserved "floor" by rule.
- A proposed coinage, **"bind"**, was checked before adoption and found to
  collide with the underlying framework's own `Bind()` — a transport
  attach with precise semantics. The coinage was renamed. The check became
  mandatory.
- The decisive incident: a vocabulary rule was violated **while the rule
  was in the model's context window**. That observation kills the
  exhortation theory of instruction-following — the rule was read and lost
  anyway — and it is the trigger for moving that rule into a linter, where
  compliance stops depending on salience.

## The rule, in four parts

1. **Collision-driven bans.** Not a style list — each banned term names the
   domain term it blurs, and the ban says what to write instead.
2. **Pre-adoption collision check.** A new coined term is grepped against
   the spec, the framework, and the codebase before it enters the
   vocabulary. Standard terms stay out — the spec is their definition.
3. **Decision-record governance.** The glossary lives in ADR-style entries
   with supersession links, so a term's sense has a history and a single
   authoritative definition, and re-litigating it means finding the record.
4. **Violation-triggered lint escalation.** Prose rules get exactly one
   chance: violated-in-context means the rule graduates to a machine check.

## Prior art

- The "banned AI words" genre (delve, tapestry, …) — well known, and a
  different practice: it filters slop; this manages *semantic collisions*.
- Dennis Traub, "Your agent keeps using that word…" (AWS, dev.to,
  2026-05-21) — DDD ubiquitous-language glossaries in per-context
  CLAUDE.md files with terms-to-avoid; the closest neighbor, informal on
  collision checks, no decision-record governance, no lint escalation.
- Vale and custom-vocabulary linting — the enforcement tooling exists and
  predates all of this; what was missing is the trigger discipline.

**The delta:** the four-part combination, and specifically the
violated-while-in-context observation as the escalation trigger — evidence
that for a standing rule, prose is a provisional format, not a home.
