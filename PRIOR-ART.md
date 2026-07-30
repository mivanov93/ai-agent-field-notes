# Prior-art dossier — 2026-07-30

Four parallel research agents I ran over 2024-2026 public material (blogs, GitHub, arXiv,
vendor docs). Verdict scale: KNOWN (cite it, don't claim it), PARTIAL (neighbors
exist; the stated delta is the claimable part), NOT FOUND (no combined prior
art located — not proof of novelty, but a clean first sweep). ~130 tool calls
across the lanes.

## Already known — these become citations in the repo

| Practice | Canonical prior art |
|---|---|
| Instruction file as failure log (every rule ← an incident) | Mitchell Hashimoto's Ghostty AGENTS.md; ShipWithAI "Your CLAUDE.md Is an Instruction File. It Should Be a Failure Log" (2026-04-13) |
| Instruction-file compliance cliff | Distyl AI IFScale benchmark (NeurIPS 2025 wkshp): 68% best-case compliance at 500 instructions; TianPan.co 2026-02-14; paddo.dev |
| Watch-the-test-fail / planted defects | TDD red-phase lore (Beck); manual mutation spot-checks (senko.net 2026-01-13, alexop.dev 2026-03-22) |
| Session-end friction retro by the agent | giannimassi/agent-retro; netresearch/retro-skill; TeamRetro "AI retrospectives" (2026-07-13) |
| Model tier ladder for subagents | Nanako0129/pilotfish (2026-07, per-role model pins in frontmatter); Augment/MindStudio routing guides |
| Batched async decisions | Rust rfcbot Final Comment Period; HITL "piling problem"/approval-fatigue literature (MindStudio; Velt 2026-06; arXiv 2606.05770) |
| Transcript mining for model regressions | Stella Laurenzo, anthropics/claude-code#42796 (~2026-04): 6,852 sessions, regression timeline, commit-rate correlation; lucemia/claude-session-analyzer |
| Agent-native task sizing | kiloloop/agent-estimate (XS-XL vs METR p80 horizons, calibration DB); ZhangHanDong/agent-estimation (tool-call rounds); METR time-horizons; PairCoder 2026-02-09 |
| Postmortems fixing systems over behavior | Google SRE Postmortem Culture; "Escaped Defect Analysis" (QA discipline) |
| Outcome-based delegated-work verification | boshu2/agentops (verify-in-fresh-context, PASS/FAIL/NOT_PROVEN); moonrunnerkc falsification-battery series (2026-05); Anthropic verification-loops post (2026-07-22) |

## Surviving claims, ranked by defensibility

1. **The owner-decision drain test** — NOT FOUND combined anywhere: a greppable
   blocker-tag batch + one review pass per session + a self-falsifying kill
   criterion (batch grows, or an entry outlives two sessions ⇒ the constraint
   is decidability, stop adding structure). Halves individually known (rfcbot
   FCP; approval-fatigue posts propose routing/SLA fixes, never a process test
   that names its own failure condition).
2. **The hardlinked-node_modules correctness hazard** — every worktree guide
   (Zylos 2026-02-22, Schumaker 2026-03-13) treats hardlink/pnpm dependency
   sharing as a SPEED lever; none documents that vite/vitest caches sharing
   inodes across trees silently un-isolates parallel agents — grounded in
   a real irreproducible-failure incident I hit. Concrete, reproducible, immediately
   useful: strongest technical finding.
3. **The link rule** — neighbors gesture (moonrunnerkc states "the measurement
   is accurate but the inference is broken" almost verbatim; Hughes's "a log
   line is a statement, proof is a check"), but nobody names the practice: the
   failure lives in the unchecked inference between a real measurement and the
   sentence, and auditing that link is usually one command. The most broadly
   applicable claim.
4. **Cross-model audit** — Laurenzo's mining stops at self-admitted errors and
   interrupt rates; nobody re-derives the suspect model's shipped claims
   against the code USING A DIFFERENT MODEL to separate output quality from
   supervision cost. My 2026-07-30 audit is a complete worked example.
5. **Rule-efficacy pipeline** — measuring per-model rule-firing rates from
   transcripts and pruning rules that never fire; only informal self-report
   pruning found. (Method described; first data lands
   when my archive analysis completes.)
6. **Four-part vocabulary control** — pet-metaphor bans on collision grounds +
   pre-adoption collision checks against spec vocabulary + ADR-governed
   glossary with supersession + lint escalation triggered by in-context
   violation. Traub's DDD-glossary CLAUDE.md piece (2026-05-21) covers half;
   the combination unfound.
7. **Narrower deltas worth one section each, not a headline**: gate-targeted
   retro trigger with lesson-terminates-in-a-named-guard; fail-closed
   lane-model lint + per-launch top-tier consent (vs pilotfish); session-unit
   anchoring + XL-as-forced-promotion + append-only estimate archive (vs
   agent-estimate); zero-tool-call-completion-as-doctrine + frozen-snapshot
   for read-only lanes (vs the hermes-agent bug report).

## The shelf the repo sits on

HumanLayer 12-Factor Agents (Dex Horthy); Martin Fowler, "Patterns for
Reducing Friction in AI-Assisted Development" (2026); Tao of Mac "Field Notes
From The AI Battlefield" (2026-06-04); "Lessons From Building With AI Agents:
120k Lines of Code Later" (2025-09-08); assorted six-months-in dev.to series.
Differentiator vs all of these: incident-derived rules with the incidents
attached, machine enforcement, and prior-art honesty per practice.

## Caveats for the writeup

- "Not found by four search lanes in one afternoon" is a first sweep, not a
  proof; I write claims as "I have not found prior art for", never "first".
- Each practice page follows: the incident → the rule → the mechanism
  (lint/ritual) → prior art found → the delta.

## Addendum: the demonstration reflex (searched 2026-07-30, fifth lane)

Verdict: PARTIALLY KNOWN. Tool overuse is well covered — NVIDIA When2Call
(arXiv 2504.18851, NAACL 2025); SMART (arXiv 2502.11435, ACL Findings
2025); and the nearest mechanistic cousin, the knowing-doing gap paper
(arXiv 2605.14038, 2026-05): models represent a tool as unneeded and fire
it anyway. Consent-side: OpenAI's GPT-5 agentic-eagerness guidance requires
confirmation for consequential actions (state-changing, not expensive
demonstrations); Anthropic's "Building Effective Agents" states the
simplest-solution principle; Quesma (2026) reports a one-command budget
burn as a comparable incident. Unclaimed: the trigger (a question NAMING a
capability becomes its execution), the demonstration-as-purchase framing,
and standing opt-ins not removing the per-use consent moment.

## Addendum: style contamination and the ban rotation (2026-07-30)

Sources behind pages 06 and 08, from a separate literature memo (~45
queries and fetches). Measured: many-shot jailbreaking (Anthropic, 2024) —
volumes of in-context text override instructions and trained behavior via
ordinary in-context learning; The Instruction Hierarchy (arXiv 2404.13208);
Control Illusion (arXiv 2502.15851) — instruction priority is fragile under
conflict; "Voice Under Revision" (arXiv 2604.22142, 2026) — a
voice-preserving instruction cut style drift 32% while 85% of markers kept
their direction; "Show and Tell" (arXiv 2511.13972) — for the style of NEW
output, written instructions outlasted exemplars; negation weakness
(MIT-covered VLM study; Anthropic's own "tell Claude what to do instead of
what not to do"). Architecture: Imitate-Retrieve-Paraphrase (EMNLP 2023) —
the nearest clean-room shape, untested for style; STRAP (EMNLP 2020);
Delete-Retrieve-Generate (NAACL 2018). Practitioner: Böckeler/Fowler (2023)
tracing the default register to marketing-heavy training data; ASD-STE100
and agent-style RULES.md as output-side linting.

Clean negatives from that memo: no published technique for keeping a model
from absorbing the style of text it must read, and no de-styling pipeline
for technical documentation.

The rotation measurement itself (page 08) is from my repo's 2026-07-30
sweep of 502 files: banned metaphors replaced by four fresh ones within
three days, two next-day relapses inside the decision log, and a promotion
rule that sanctions any five-times-used term. I found no prior report of
ban-driven vocabulary rotation in LLM collaboration.

## Addendum: the clean-room design (2026-07-31)

The design doc behind page 09 states its borrowed/new split precisely.
Borrowed: the clean-room name and read/write barrier (copyright-safe
reimplementation practice; legal commentary notes weight-level
contamination remains unsettled there); extract-then-generate
(Imitate-Retrieve-Paraphrase, EMNLP 2023, arXiv 2305.03276); the
constraints from measured work (exemplar decay per Show and Tell →
one-unit-per-writer; instructions persist where examples decay → rules
plus examples for the writer). Not found in ~45 searches: the barrier
applied to stripping a house style from a corpus under cleanup; the
checker as a third role that may see both sides because it does not
write; the structured-not-prose requirement on the intermediate; the
one-unit-per-writer rule. Repo-internal measurements feeding the page:
three writing rules in context produced no change across thirty same-day
commits (mean sentence 10.8 vs 11.2 baseline); the corpus outweighs the
rule examples ~880:1 (375,885 words of docs vs ~427 words of commit-title
examples per session read).
