# Changelog — deep-research-cheaper

## 0.0.3 — 2026-09-01

- Hardened the web agents. Search, fetch, and verify now carry an explicit
  WebFetch/WebSearch-only instruction and are told to skip a source rather
  than fetch it another way, so they do not fall back to a shell `curl` on an
  untrusted URL when WebFetch fails. The reasoning is in the README and in
  [the fetcher shouldn't have a shell](../../the-fetcher-shouldnt-have-a-shell.md).
- Shipped [web-fetcher.md](web-fetcher.md): the opt-in shell-less agent type for
  hard enforcement (create the agent, add `agentType` to the three web calls).
  Off by default — the plain install is the skill without the lock.

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
