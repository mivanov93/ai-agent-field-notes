# Vocabulary control

**Claim:** an AI collaborator needs a managed vocabulary for COLLISIONS —
places where the model's word choice blurs a term your domain depends on.
Four things work together there: ban the colliding metaphor and name its
replacement; check every new term against your specs before adopting it;
keep the glossary in decision records; and when a rule is broken while
sitting in the model's context, move it into a lint.

*Scope matters, and I learned it the hard way: this practice fixes meaning
bugs. It does not reduce the model's metaphor-minting in general — I
measured that, and the result is page 08. Bans rotate the vocabulary; they
don't shrink it.*

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
- The escalation evidence, now measured rather than anecdotal: rules were
  broken while sitting in the model's context, repeatedly. The sharpest
  cases sit in my own decision log — the entry banning one term was
  followed one day later by an entry using it, and the entry scrapping
  another term was followed one day later by the same thing. Reading a
  rule is not following it. That is the trigger for moving a rule into
  the linter, where compliance stops depending on attention.

## The rule

1. **Bans name their collision.** Not a style list. Each banned term names
   the domain term it blurs and says what to write instead.
2. **New terms get checked first.** Grep the spec, the framework, and the
   codebase before a coined term enters the vocabulary. Standard terms
   stay out — the spec already defines them.
3. **The glossary lives in decision records**, with links when a
   definition replaces an older one. A term's meaning has a history and
   one authoritative home.
4. **Broken-in-context means lint — and the lint must read everything.**
   A prose rule gets one chance. And a lesson from the measurement: my
   original cleanup swept code comments only, and the banned terms
   survived for weeks in 502 documentation files no check ever read. A
   rule enforced over half the corpus is enforced over neither half —
   the unswept half re-teaches the habit to every session that reads it.

## Prior art

- The "banned AI words" lists (delve, tapestry, and so on). Well known,
  and a different practice: those filter style. This manages collisions
  with domain meaning. (My corpus measured clean on those words — under
  100 hits across 502 files, "delve" zero. The style problem here was
  never slop vocabulary; see page 08.)
- Dennis Traub, "Your agent keeps using that word…" (AWS, dev.to,
  2026-05-21). Domain-driven-design glossaries in per-context CLAUDE.md
  files with terms to avoid. The closest neighbor. No collision check, no
  decision-record governance, no lint escalation.
- Vale and custom-vocabulary linting. The enforcement tooling exists and
  predates all of this. What was missing is the rule for when to reach
  for it.
- On why prose rules under-deliver: explicit instructions measurably
  attenuate a style effect without reversing it ("Voice Under Revision",
  arXiv 2604.22142), and negative phrasing is the weakest instruction
  shape — a ban list is negative phrasing. Details and more citations in
  page 08 and PRIOR-ART.md.

**What I think is new:** the four parts together, scoped to collisions;
broken-while-in-context as the escalation trigger, now backed by measured
relapses inside the decision log itself; and the whole-corpus requirement
— enforcement that skips the prose loses to the prose.
