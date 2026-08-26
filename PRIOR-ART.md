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
2. **The hardlinked-node_modules correctness hazard** — PARTIAL, and narrower
   than the first sweep recorded. Now reproduced end-to-end with a control
   ([`examples/hardlink-repro`](examples/hardlink-repro/), 11 experiments, 2026-08-03).
   Three corrections to the original entry:
   - The *mechanism* is KNOWN, not new. Hardlink aliasing + in-place write =
     shared mutation is decades-old backup-tool lore (rsnapshot, `cp -al`
     snapshot rotation), and pnpm's store docs warn about it in this exact
     directory ("editing files in node_modules corrupts the global store for
     all other projects"). Cite it; never claim it.
   - Zylos and Schumaker do **not** recommend hardlinks — the original entry
     misread both. Zylos recommends pnpm's store; Schumaker tried Yarn
     `hardlinks-global`, rejected it as too slow, and uses pre-warmed worktree
     pools. The actual hardlink advocacy is pnpm's store, Yarn's
     `nmMode: hardlinks-global`, and RooCodeInc/Roo-Code#11758 (2026-02-26,
     open) — which proposes hardlinking `node_modules` into agent worktrees
     with no risk discussion. That last one is the citation to use.
   - vite is exonerated: its dep prebundle is rename-swapped and does not
     propagate. The confirmed channel is vitest's `results.json` alone, and it
     changes test *ordering*, which becomes a wrong result only in an
     order-dependent suite.
   Where cache contamination between worktrees *is* discussed (Zylos
   2026-02-22, Termdock 2026-03-20), it is blamed on shared/absolute-path
   build-cache dirs (Bazel, Nx, Pants, Turbo), symlinked `node_modules`
   breaking resolution, or shared databases — never on hardlink aliasing.
   **Second channel found 2026-08-03, and it is not about hardlinks.** A cache
   already inside `node_modules` is carried into a new tree by ANY copy —
   `cp -r`, `tar`, `rsync`. tsc inherits a `tsbuildinfo` claiming its outputs
   exist, exits 0, and emits nothing; the `cp -r` control fails identically,
   and deleting the buildinfo fixes it. tsc trusting buildinfo over checking
   outputs is a KNOWN limitation (people hit it deleting `dist/` by hand); what
   is NOT FOUND is that siting it in `node_modules` makes it reachable by
   making a worktree the ordinary way, with nothing deleted.
   **Discriminator, measured across four caches:** written-in-place decides the
   live channel; relative-vs-absolute keys decide whether one tree's entries
   are meaningful in another. vitest (in place + relative) → wrong results;
   tsc (in place + relative) → empty build; eslint (in place + absolute) →
   propagates but cannot collide; vite deps (rename) → harmless. None of this
   is documented or version-stable, hence `detect.sh`.
   **Claimable delta:** measured instances of old mechanisms producing wrong
   answers across agent worktrees, the propagate/collide map, and a detector so
   the map need not be trusted. NOT FOUND for the chain. Still the strongest
   technical finding — but the claim is "documented instance", not "new
   mechanism", and the headline should be the `node_modules`
   immutable-vs-scratch conflation rather than hardlinks specifically.
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

Sources behind the vocabulary-control and bans-rotate pages, from a
separate literature memo (~45
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

The rotation measurement itself (bans-rotate-the-vocabulary.md) is from
my repo's 2026-07-30
sweep of 502 files: banned metaphors replaced by four fresh ones within
three days, two next-day relapses inside the decision log, and a promotion
rule that sanctions any five-times-used term. I found no prior report of
ban-driven vocabulary rotation in LLM collaboration.

## Addendum: the clean-room design (2026-07-31)

The design doc behind the clean-room page states its borrowed/new split
precisely. On the terminology question directly: the *name* is borrowed —
"clean room" is an established term from clean-room reverse engineering — and
what is coined here is applying that barrier to strip a house style from an AI
corpus; the name is not mine, the AI use is.
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

## Addendum: the model votes for more rules (searched 2026-07-31)

Verdict: PARTIALLY KNOWN — the pieces, not the loop. Huang et al. (arXiv
2310.01798, ICLR 2024): intrinsic self-correction fails without external
grounding. Turpin et al. (NeurIPS 2023) and Anthropic's 2025 follow-up:
self-report unfaithful to actual causes. Mittal (arXiv 2604.09189, 2026):
models claim compliance with self-stated policies and measurably violate
them — the nearest direct hit, in the safety domain. Panickssery et al.
(NeurIPS 2024): self-preference in LLM judges. Practitioner rule-bloat
critiques (Osmani 2026-01; wordman.dev 2026-02) document that rule-piling
fails but frame it as human over-correction — neither notices the model
recommends the piling when asked. Unclaimed: the advice-loop as a named
operational trap, the normalization mechanism, the axis problem and the
originate/verify asymmetry, and the falsification requirement on
model-drafted self-rules.

## The 2026-07-31 sweeps — every remaining page

A second and third pass searched every claim the 2026-07-30 dossier had not
covered as its own: the ten previously-unsearched published pages, and the
sixteen pages promoted from drafts. One lane per page over public 2024–2026
material (WebFetch was down during these runs, so lanes fetched via curl and
the browser tool, and I re-verified the load-bearing citations myself). Every
verdict came back PARTIAL, or KNOWN-leaning where the fact is established and
only the framing is new — none was preempted. Each page carries its full
citations; consolidated here.

### The ten published pages (re-searched)

- **the-founding-document** — PARTIAL. Panaversity's "Project Constitution" and
  GitHub Spec Kit (`/speckit.constitution`) put a constitution before code, but
  AI-drafted and with no case-law layer; ETH's "Evaluating AGENTS.md"
  (arXiv:2602.11988) empirically backs written-over-generated; AgentLint
  independently coins "sediment" (2026-04). Delta: the constitution/case-law
  two-layer split, and the warning against bootstrapping the founding file from
  auto-memories.
- **descriptive-statements-as-directives** — PARTIAL. OverEager-Bench
  (arXiv:2605.18583) measures out-of-scope actions (stripping the consent line
  takes Claude Code 0.0%→17.1%); UnderSpecBench (arXiv:2607.02294) measures
  boundary violations on vague instructions — both start from a real task.
  Delta: the report-with-no-imperative trigger, the imperative-collapse
  framing, and the two tells.
- **the-session-has-no-concurrency-model** — PARTIAL, the tightest neighbor
  found. Meiklejohn's "One Writer" (2026-07-27) and "Multi-Agent Systems Have a
  Distributed Systems Problem" (2026-03-30) are near-verbatim; STORM
  (2605.20563), CoAgent (2606.15376), Co-Coder (2606.00953) build the external
  fixes. Delta: the orchestrator corrupting its own readers, the won't-idle
  bias, and the frozen-snapshot fix.
- **the-missing-hypothesis-is-orthogonal** — PARTIAL. CHI 2025 "No Evidence for
  LLMs...Problem Reframing" (2503.01631); IDEAFix (2606.00875, "bound within a
  shared semantic space"); Franceschelli & Musolesi on transformational-
  creativity limits (2024); an LLM Einstellung study (2306.11167). Delta: the
  sign-oscillates / axis-never-rotates diagnostic and the originate/verify
  asymmetry.
- **agents-launch-at-full-price** — PARTIAL. Anthropic's multi-agent writeup
  (2025, "50 subagents for simple queries"); Systima's "Subagent Tax"
  (2026-07-22) measures both blindnesses on Claude Code; BAGEN (2606.00198),
  BAMAS (2511.21572, AAAI 2026), pilotfish. Delta: the two blindnesses as one
  property, the never-self-economize thesis, and the human-authored
  cheap-variant skill.
- **dont-ask-for-perfection** — PARTIAL. Max Woolf's "write better code" (2025);
  OpenAI's GPT-5 guide (convert a superlative to a rubric first; Cursor's
  constraint-over-adjective); persona-prompting (2512.05858); reward-model
  verbosity bias. Delta: the causal-for-humans / correlational-for-models
  framing, and convert-or-delete with the deliberately-absent list.
- **the-models-model-of-you** — PARTIAL; its worst form is a product bug, not
  the model. "Algorithmic Self-Portrait" (WWW 2026, 2602.01450: 96%
  system-created, 52% psychological); "Interaction Context Increases Sycophancy"
  (CHI 2026, 2509.12517); Willison's "memory dossier" (2025) — all consumer
  chat apps. Delta: abolition (delete the genre), profile-as-license, and the
  coding-agent case distinct from the chat product bug.
- **memory-belongs-in-the-repo** — PARTIAL. Claude Code issue #24044 (loaded
  twice); the "Shared Team Memory" thread (#38536); Letta's "Context
  Repositories" (git-backs the store — the opposite fix); Galster et al.
  (2602.14690) show versioned context files dominate. Delta: the same-organ
  thesis and the fold-in-then-delete discipline.
- **the-session-archive** — PARTIAL, and the backup tools are not the claim.
  Anthropic's SessionStore and `csb`-style tools only retain; The Register
  (2026-06-30) confirms the wipe incident; Laurenzo's mining (already cited,
  KNOWN) analyzed what survived; Honeycomb's Observability 2.0 (2024) is the
  raw-capture ancestor. Delta: the never-delete-then-mine standing instrument,
  arrived at independently (~June 2026).
- **the-models-clock** — PARTIAL. "Set the Clock" (2402.16797), "Dated Data"
  (2403.12958), "Supersede" (2606.27472), and the "outdatedness hallucination"
  taxonomy document cutoff staleness. Delta: the quotable-not-operative gap
  (quote today's date, still search stale in the same turn) and the
  standing-conversion-rule fix.

### The sixteen promoted pages

- **a-gate-you-can-fail** — PARTIAL. Huang "LLMs Cannot Self-Correct"
  (2310.01798), Kamoi survey (2406.01297); "The Verification Horizon"
  (2606.26300) and "Building to the Test" (2606.28430) extend it to coding
  agents. Delta: the ceiling/floor formulation — the model raises the best
  case, the gate raises the worst, and the worst ships.
- **all-green-still-broken** — PARTIAL. Barr et al.'s "Oracle Problem" (TSE
  2015); "All Smoke, No Alarm" (2606.18168, 80.2% of agent tests carry no real
  oracle); Anthropic's April-23 postmortem. Delta: the re-ask-what-the-tests-
  are-for trigger and drive-the-real-artifact.
- **decide-the-shape-first** — PARTIAL. Propel Code's "AI Codebase Drift"
  (2026); an agentic-patterns "God Object" entry; ETH's LLM-tech-debt review
  (2606.14796). Delta: the plan-format causal chain (steps-only plans leave
  structure undecided, verbatim briefs punish deviation, review told to ignore
  aggregate size).
- **move-the-code-lose-the-test** — PARTIAL. Fowler's "Parameterize Function";
  Jon Reid's "Who Tests the Tests?" (2016) is the corrupt-and-rerun ritual;
  "rotten green tests" RTj (1912.07322). Delta: the consolidation-turns-inline-
  into-caller-input failure class and the post-refactor inert-value gate.
- **notes-that-rot** — PARTIAL, the closest to unfound. An LLM-comment taxonomy
  (2607.01867), "TODO: Fix the Mess Gemini Created" (2601.07786), and "context
  rot" (2606.09090) are adjacent. Delta: the dead-session-label defect, the 85%
  measurement, and the merge-time grep — the combination appears original.
- **the-tools-you-never-use** — PARTIAL. unclog and mcp-tidy already prune by
  call count; Scott Spence and EclipseSource measure the token cost; RAG-MCP
  (2505.03275); Anthropic's context-engineering post (2026-07-24, the 80%
  prompt trim). Delta: the 0.6%-of-11,669 measurement and the
  inversion-of-the-trim framing.
- **it-cant-be-done-is-usually-out-of-date** — PARTIAL. CodeUpdateArena
  (2407.06249), a deprecated-API study (2406.09834), "When LLMs Lag Behind"
  (2604.09515), and Context7 cover the generation side. Delta: the
  assertion-side false "impossible," reframed as a (version, date) claim you
  falsify against the current upstream, not the local copy.
- **its-already-written-down** — PARTIAL. Vercel's "AGENTS.md outperforms
  Skills" (Jan 2026: the skill went un-invoked in most cases); "Codified
  Context" (2602.20478). Delta: the specific "doesn't even check," the
  dependency-quirks-across-sessions incident, and the cheap grep-the-notes-first
  fix.
- **dont-interrupt-a-working-agent** — PARTIAL, one near-exact match. A
  hermes-agent issue (#36934) documents a legitimate `/steer` flagged as
  injection (Opus 4.8); "AI Agents May Always Fall for Prompt Injections"
  (2605.17634) is the structural reason. Delta: the operator-facing
  prescription — front-load the brief, expect mid-run steering to fail,
  stop-and-relaunch.
- **you-cant-ask-for-cheaper** — PARTIAL. Concise-CoT (2401.05618), TALE
  (2412.18547), TRIAGE (2605.13414) / BAGEN (2606.00198), and JetBrains's
  "caveman" benchmark (trimming chatter is safe). Delta: that "use less" cuts
  verification and docs specifically, the no-cost-meter principle, and the
  throwaway exception.
- **where-the-savings-are** — PARTIAL. The AGENTS.md "explain twice, document
  once" guidance; Osmani's self-improving agents; MCP context-bloat writeups;
  prompt caching (Anthropic/OpenAI/Google docs); RouteLLM (2406.18665). Delta:
  the levers unified under "cut what you didn't need," the mislaunched-agent
  economics, and the model-floor rule.
- **where-scar-tissue-comes-from** — KNOWN-leaning; the method is established
  (Google SRE blameless postmortems, escaped-defect analysis, Hashimoto's
  Ghostty log, the agent-retro tools). Delta: the retro as the mint for an
  instruction file, and the gate-focused "why did the green check miss it"
  variant.
- **the-docs-arent-on-the-test** — the benchmark facts are KNOWN; the framing is
  the delta. Every mainstream coding benchmark (SWE-bench and variants,
  HumanEval+, MBPP, LiveCodeBench, BigCodeBench, Aider) scores test-pass only,
  and RL-with-verifiable-rewards trains on the same signal; the doc-touching
  benchmarks are BLEU-scored summary generation. Delta: benchmark blindness to
  docs as the incentive-side cause of doc rot. One emerging caveat, "Needle in
  the Repo" (2026), unverified.
- **extends-broekx-shared-git-index** (↳ derivative) — PARTIAL. Parent: Ruben
  Broekx, "AI Agents Need Their Own Desk, and Git Worktrees Give Them One"
  (Towards Data Science, 2026-04-18, verified). Claude Code issues
  #37888/#55024 show working-tree clobbers; a steipete gist prescribes
  explicit-file commits. Delta: the shared git index sweep — a human
  hand-staging while the agent runs an unscoped commit — distinct from the
  shared working tree Broekx covers.
- **ai-is-not-mr-fix-it** — PARTIAL. Huang (2310.01798) and Kamoi (2406.01297)
  on self-correction limits; CHI 2025 reframing (2503.01631); a "$47K
  autonomous-loop" postmortem (2025); "intelligence doesn't compose linearly"
  practitioner writing. Delta: the four-part taxonomy of what only the human
  supplies (decomposition, missing fact, reframe, check) and "more money or
  machinery doesn't substitute" across the three escalation axes.
- **the-face-transplant** — PARTIAL. The "static mock omits states" observation
  is common in design writing (Uzma Noor's "Happy Path Fallacy" 2025; "The End
  of Static Mockups" 2026); the single-vs-multi-state distinction is formalized
  in code-generation research (Interaction2Code arXiv:2411.03292; the survey
  arXiv:2606.15932 — "single-output imitation" vs "multi-state verification").
  The reframe is stronger than the generic handoff literature but not a novel
  discovery of the core insight; the surviving delta is the application —
  reshaping (not transplanting) a live system to a single-frame reference, and
  budgeting the application rather than the mockup.
- **the-month-that-takes-a-day** — PARTIAL, core now empirically confirmed. "Can
  LLMs Perceive Time?" (Garikaparthi, arXiv:2604.00010) measures models
  overshooting their own duration estimates 4–7× ("propositional knowledge…
  no experiential grounding"); a 2026 Frontiers effort-estimation paper covers
  the human-labor-pricing half (LLMs do 78% of high-complexity tasks in <25% of
  expected human effort). METR is the outside-view baseline; BAGEN the
  opposite-direction error. Delta: the composite at project scale — over-quoting
  feasible work, the behavioral consequence (talks you out of cheap value), and
  the attempt-don't-ask fix.

## The 2026-08-26 sweeps — the five drafts

Five lanes over public 2024–2026 material, one per draft, run on a
cheaper model tier with every load-bearing citation re-verified at
session level before use (per the delegation rules). All five verdicts
PARTIAL; several framings came back clean NOT FOUND.

- **the-test-that-assumes-it-owns-the-table** — PARTIAL. Luo et al.
  (FSE 2014, DOI:10.1145/2635868.2635920) covers two of three incidents
  by name (external-resource dependency inside Test Order Dependency;
  Resource Leak); *SWE at Google*'s hermeticity chapter is the
  declare-your-dependencies baseline; Berndt et al. (ICSE-SEIP '26,
  arXiv:2601.08998) show LLM-written DBMS tests are flakier than human
  ones, single-agent. Delta: cross-binary contention on an always-on
  shared topic (outside Luo's single-process taxonomy), ownership as a
  gate-checkable artifact, and the author-and-crowd structure — the
  last two NOT FOUND.
- **the-model-cant-see-the-picture-it-drew** — PARTIAL. The fix is
  shipped: Agents365-ai's mermaid-skill README contrasts "never looks
  at the render" with its vision loop; Design2Code (arXiv:2403.03163);
  VF-Coder (arXiv:2604.19750). SolidCoder (arXiv:2604.19825) names the
  Mental-Reality Gap for code execution. Delta: the pricing framing and
  cost-mislabeled-as-incapability — NOT FOUND.
- **compression-is-what-familiarity-feels-like** — PARTIAL. Curse of
  knowledge (Camerer, Loewenstein & Weber 1989) and audience design
  (Clark & Murphy 1982) for the human analog; Laban et al.
  (arXiv:2505.06120, 39% multi-turn reliability drop) and Mittal
  (arXiv:2603.23530, 2–21% compliance drop under load) for rules losing
  force. "Lost in the Middle" (arXiv:2307.03172) and Chroma's "Context
  Rot" (2025) checked directly — retrieval metrics, not output
  register. Delta: the post-ingestion trigger, the self-authored rule,
  the orchestrator-as-translator — all NOT FOUND.
- **the-doctor-doesnt-catch-the-fever** — PARTIAL; the bundle NOT
  FOUND. BooookScore (ICLR 2024, arXiv:2310.00785) is the closest
  shape (100 books, human-validated error taxonomy — evaluates, never
  fixes). The mechanism literature leans against labels: Min et al.
  (EMNLP 2022, arXiv:2202.12837), In-Context Fixation
  (arXiv:2605.08295), Voice Under Revision (arXiv:2604.22142) —
  supporting the page's dose-and-gates hedge. RuVerBench
  (arXiv:2606.29920): rubrics don't rescue weak judges (coding, not
  prose).
- **the-crash-lands-on-the-innocent-process** — PARTIAL.
  Victim-not-cause exists scattered (Autoheal's OOM guide, nearly
  verbatim for memory; AWS AgentCore observability for agent tool
  errors); agent disk exhaustion is now publicly documented:
  openai/codex#34061 (731.5 GiB of session logs),
  anthropics/claude-code#59856 (121 unswept session dirs) and #23484
  (864 → 73,217 processes in ~an hour), and the storage_ballast_helper
  tool. Delta: the unowned-pool family as one diagnostic claim, and
  Docker build-cache growth from agent retry loops — NOT FOUND.
