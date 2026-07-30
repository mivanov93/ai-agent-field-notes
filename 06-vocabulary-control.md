# Vocabulary control

**Claim:** an AI collaborator needs a managed vocabulary, and four things
have to work together: ban the model's favorite metaphors where they
collide with your domain terms; check every new term against your specs
before adopting it; keep the glossary in decision records; and the first
time a rule is broken while sitting in the model's context, move it into a
lint — more prose is proven not to work at that point.

## The incidents

- The model liked "watermark" in a codebase with a real `high-water`
  concept (the furthest point written on an output stream). Not wrong in
  general English. Wrong here, because it blurred an exact term the code
  depends on.
- "Floor" is the project's protocol word for the exclusive right to speak,
  with a state machine and wire messages behind it. The model used it for
  minimum browser versions — "browser floor". In a repo with
  `floor.spec.ts` and a `FloorOffered` message, that reads as the wrong
  thing entirely. The concept was renamed "minimum supported browser
  versions" and "floor" is reserved by rule.
- A proposed term, "bind", was checked before adoption and collided with
  the framework's own `Bind()`, which has a precise meaning. Renamed. The
  check became mandatory.
- The deciding incident: a vocabulary rule was broken while the rule was in
  the model's context. That kills the theory that writing rules down is
  enough — this one was read and lost anyway. It became the trigger for
  moving rules into the linter, where following them no longer depends on
  the model's attention.

## The rule

1. **Bans name their collision.** Not a style list. Each banned term names
   the domain term it blurs and says what to write instead.
2. **New terms get checked first.** Grep the spec, the framework, and the
   codebase before a coined term enters the vocabulary. Standard terms stay
   out — the spec already defines them.
3. **The glossary lives in decision records**, with links when a definition
   replaces an older one. A term's meaning has a history and one
   authoritative home.
4. **Broken-in-context means lint.** A prose rule gets one chance.

## Prior art

- The "banned AI words" lists (delve, tapestry, and so on). Well known, and
  a different practice: those filter style. This manages collisions with
  domain meaning.
- Dennis Traub, "Your agent keeps using that word…" (AWS, dev.to,
  2026-05-21). Domain-driven-design glossaries in per-context CLAUDE.md
  files with terms to avoid. The closest neighbor. No collision check, no
  decision-record governance, no lint escalation.
- Vale and custom-vocabulary linting. The enforcement tooling exists and
  predates all of this. What was missing is the rule for when to reach for
  it.

**What I think is new:** the four parts together, and especially
broken-while-in-context as the escalation trigger — the evidence that
writing a rule down is a first step, and enforcement is where a standing
rule ends up.
