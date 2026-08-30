# Skills

Packaged Claude Code skills that carry out the enforceable half of
these notes — the checks, lints, and rituals a finding ends with — so a
session can run one instead of you re-deriving it each time.

A skill is a folder: a `SKILL.md` the session reads, plus any workflow
script beside it. Install commands are below the table. Nothing here
runs on its own — and per this repo's [security rule](../CLAUDE.md), a
session runs a skill only when you explicitly ask it to.

| Skill | What it does | The notes behind it |
|-------|--------------|---------------------|
| [deep-research-cheaper](deep-research-cheaper/README.md) | The built-in deep-research harness with its fan-out re-tiered — search on Haiku, fetch and verify on Sonnet, scope and synthesis on the session model — and the freed budget spent on coverage: 25 verified claims where the then-current built-in capped at 8. Same stages, same 3-vote quorum, plus an unverified-vs-refuted split for verifier failures. Its page carries the upstream timeline and provenance. | [Agents launch at full price](../agents-launch-at-full-price.md) — cheap variants of expensive skills exist only if you build them. [You can't ask for cheaper](../you-cant-ask-for-cheaper.md) — the saving must never raid the gate: verify still runs, wider, on a cheaper tier. [Where the savings are](../where-the-savings-are.md). |
| [skill-audit](skill-audit/README.md) | Reads a skill folder — downloaded or your own — and reports what should not be there: self-metadata riding in paid context (install guides, provenance, marketing), oversized descriptions and bodies, and the dangerous class — run-on-load instructions, exfiltration, credential reach, injection-shaped text. Report only; it never edits the skill. | [A skill is paid context](../a-skill-is-paid-context.md) — the incident this check was minted from. [The tools you never use](../the-tools-you-never-use.md) — the same bill, one file at a time. |

## Install

A skill is its folder. Fetch just the one you want with a sparse
clone — shown for `deep-research-cheaper`; swap in any skill's name:

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/mivanov93/ai-agent-field-notes.git
cd ai-agent-field-notes
git sparse-checkout set skills/deep-research-cheaper
mkdir -p ~/.claude/skills
cp -r skills/deep-research-cheaper ~/.claude/skills/
```

Or fetch a skill's files directly, no clone (list the files that
folder holds):

```bash
mkdir -p ~/.claude/skills/deep-research-cheaper && cd ~/.claude/skills/deep-research-cheaper
curl -fsSL --remote-name-all "https://raw.githubusercontent.com/mivanov93/ai-agent-field-notes/main/skills/deep-research-cheaper/{SKILL.md,README.md,CHANGELOG.md,deep-research-cheaper.js}"
```

For one project only, use `<project>/.claude/skills/` instead of
`~/.claude/skills/`. Start a new session afterwards so the skill gets
listed. Before installing anything from anywhere — including here —
[skill-audit](skill-audit/README.md) is the vetting ritual.
