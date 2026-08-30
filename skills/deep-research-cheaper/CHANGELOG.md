# Changelog — deep-research-cheaper

## 0.0.2 — 2026-08-30

- First published version (this repo).
- The verify-phase comment's issue reference made resolvable:
  `anthropics/claude-code#69883` instead of an internal shorthand.
- SKILL.md stripped to runtime-only content; history, provenance, and
  install moved to this folder's README and the skills index
  ([a skill is paid context](../../a-skill-is-paid-context.md)).

## 0.0.1 — 2026-07-19

- Initial fork from the built-in `deep-research` (base: the shipped
  script as of 2026-07-13), private. Per-stage model pinning — search
  on Haiku, fetch and verify on Sonnet; verify cap restored to 25;
  three-outcome verdicts (unverified vs refuted); scope-schema
  robustness fix.
