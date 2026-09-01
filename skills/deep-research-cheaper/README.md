# deep-research-cheaper

**Version 0.0.3** · 2026-09-01 ·
[changelog](CHANGELOG.md) ·
[folder on GitHub](https://github.com/mivanov93/ai-agent-field-notes/tree/main/skills/deep-research-cheaper)

Claude Code's built-in `deep-research` workflow, forked: the fan-out
re-tiered onto cheaper models — search on Haiku, fetch and the 3-vote
adversarial verify on Sonnet, scope and synthesis on the session
model — coverage restored to 25 claims, and failed verifier panels
reported *unverified* instead of counted as *refuted*.

The runtime files are
[SKILL.md](https://github.com/mivanov93/ai-agent-field-notes/blob/main/skills/deep-research-cheaper/SKILL.md)
and
[deep-research-cheaper.js](https://github.com/mivanov93/ai-agent-field-notes/blob/main/skills/deep-research-cheaper/deep-research-cheaper.js),
kept free of everything on this page on purpose
([a skill is paid context](../../a-skill-is-paid-context.md)). How to
install any skill from this repo: [the skills index](../README.md).

## Security: the web agents read untrusted pages

The search, fetch, and verify agents read pages surfaced by web search —
untrusted content. As of 0.0.3 each one carries an explicit
WebFetch/WebSearch-only instruction and is told to skip a source rather
than fetch it another way, so it does not fall back to a shell `curl` on
a hostile URL when WebFetch fails. This is the reason
[the fetcher shouldn't have a shell](../../the-fetcher-shouldnt-have-a-shell.md):
the built-in workflow ships fetch agents that *can* make that fallback,
and it has been demonstrated end to end.

The instruction is the portable floor, not a guarantee — the agent still
holds a shell it is asked not to use. For hard enforcement, opt in to the
shell-less agent type shipped alongside this skill:
[web-fetcher.md](web-fetcher.md) has the two steps — create the agent, then
point the three web agents at it. It is opt-in on purpose, and off by
default: the plain install is the skill without the lock, because the lock
adds a file in `~/.claude/agents/` outside the skill folder. A fully
sandboxed run (OS isolation, egress control) is the stronger boundary still.

## Upstream history, and how this fork relates

The built-in's script is published nowhere — the npm package ships a
compiled binary, and the docs describe behavior, not constants. The
script is readable only because every run persists its resolved copy
under `~/.claude/projects/`. This timeline is assembled from persisted
runs on my machine, one public paste, the GitHub API, and the official
docs, all fetched or read directly, as of 2026-08-30.

| When | Actor | The workflow after this | Votes | Cap | Verify agents | Tiered? | Evidence |
|------|-------|-------------------------|-------|-----|---------------|---------|----------|
| ~2026-05 (v2.1.154) | Anthropic ships it | Five stages; verify is one adversarial burst, all of it on the session model | 3 | 25 | 75 | no | [azukiazusa.dev](https://azukiazusa.dev/en/blog/claude-code-dynamic-workflow/) pastes the full script |
| 2026-06-21 | zwrose files [#69883](https://github.com/anthropics/claude-code/issues/69883) | One run spawned 105 agents (~1.68M tokens); the 75-agent verify burst tripped a *server-side* rate limit, every vote failed, and the run reported "all claims refuted" when the truth was "could not check anything" | — | — | — | — | the issue, read via the GitHub API |
| by 2026-06-27 | Anthropic retreats | Verify becomes a single reviewer told "you are the SOLE reviewer — do NOT kill on mere uncertainty." The burst is gone — and so is the adversarial quorum | 1 | 10 | 10 | no | persisted run on my machine |
| by 2026-07-13 | Anthropic corrects course | Quorum restored, coverage cut to keep the burst small. A partial guard now stops errored votes from producing a false "survived," but a claim whose verifiers all failed still lands in the report as "refuted" | 3 | 8 | 24 | no | persisted run on my machine |
| 2026-07-18/19 | **this fork** | Same stages, same quorum. Search moved to Haiku, fetch and verify to Sonnet, cap back to May's 25 — and the full three-outcome fix: failed verifier panels report as *unverified*, a separate bucket from *refuted*, carried through report and caveats | 3 | 25 | 75 (Sonnet) | **yes** | WIP run persisted 07-18 23:23Z; skill files 07-19 |
| 2026-08-14 | the stale bot | #69883 closed "not planned." No human marked it fixed; no fix was ever linked to it | — | — | — | — | GitHub API: `closed_at`, `state_reason` |
| 2026-08-30 (current) | — | Docs describe unverified-vs-refuted as shipped behavior ("the report lists that claim as unverified instead of counting it as refuted"), and still no tiering ("every agent in a workflow uses your session's model unless the script routes a stage") | ? | ? | ? | **still no** | [workflows docs](https://code.claude.com/docs/en/workflows) |

The table's shape is the point: Anthropic's two moves and this fork's
one move are responses to the *same event* — the June 21 rate-limit
report. They fixed the burst by making the harness smaller, twice:
first by dropping the quorum (cheap, but one non-adversarial reviewer),
then by keeping the quorum and cutting coverage to a third of May's.
This fork fixed the burst by making it cheap and keeping the harness
big: 75 Sonnet calls cost about what upstream's 24 session-model calls
do, with three times the claim coverage.

## The three changes, judged separately

**Per-stage model tiering.** Three layers, with different owners:

- *The knob* — a workflow script saying `model: "sonnet"` on one stage —
  is Anthropic's platform feature. It was always available to any
  script.
- *The concept* — running different pipeline roles on different model
  tiers — is known field practice, and this repo's own
  [PRIOR-ART.md](../../PRIOR-ART.md) already lists it as such ("model
  tier ladder for subagents": pilotfish's per-role model pins, the
  Augment/MindStudio routing guides). Not claimable, not claimed.
- *The application to this workflow* is this fork's, 2026-07-19 — and
  there is no before/after race with Anthropic to adjudicate, because
  Anthropic has never entered it: no tiering in the May paste, none in
  either persisted snapshot, none in the current docs, which go as far
  as advising users to *ask* for smaller models on some stages while
  the shipped script runs every agent on the session model. On every
  located source this is the only tiered version of the workflow. Per
  this repo's own rule, "no located source" is a clean first sweep,
  not proof of priority.

**The unverified third state.** The idea is zwrose's, not mine — #69883
named both the defect and the correct behavior on 2026-06-21, four
weeks before this fork. My implementation is dated: the three-outcome
logic is in the work-in-progress script persisted 2026-07-18 23:23Z.
Anthropic's implementation cannot be dated: their 2026-07-13 script
still misreports failed panels as refuted, today's docs describe the
fixed behavior, and nothing pins the change inside that
July-14-to-August-30 window — no changelog entry, and the issue was
closed by a stale bot rather than a fix commit. The window straddles
my date, so mine may have been first by five weeks or theirs by days.
Undetermined, and stated as such.

**The cap of 25.** Not an improvement claim at all. It is Anthropic's
own May value, abandoned for cost reasons, restored here because
re-tiering re-priced it. Credited, not claimed.

## The verdicts, one line each

- **Tiering:** this fork's, for this workflow, unmatched upstream as of
  2026-08-30; the underlying concept is known practice.
- **Unverified fix:** zwrose's idea; my implementation 2026-07-18/19;
  upstream's undateable inside a window that straddles mine —
  undetermined, never "first."
- **Cap 25:** Anthropic's number, restored.

The dates above rest on artifacts on my machine (persisted run scripts,
session files); the folder's public timestamp is its git history. If
you know an earlier tiered fork or an upstream tiering change, file an
issue — the claim becomes a citation.
