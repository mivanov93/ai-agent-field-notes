# Agent field notes

Notes on making AI coding agents behave. They come from months of running a
real project — a WebRTC project in Go with a TypeScript web client — almost
entirely through AI coding sessions. Each note started as a real incident:
something went wrong even though the right guidance was in the model's
context. Each note ends with something enforceable — a check, a lint, a
ritual — not just advice.

**Scope:** everything here was observed on Claude Opus 4.8, Opus 5, and
Fable 5, in the Claude Code harness, June–July 2026. By this repo's own
argument, findings are model-relative — re-measure before assuming they
hold for yours.

Each finding has its own page, cross-linked to the others. Every page cites
the closest published work I found and says exactly what I think is new.
The full search record is in [PRIOR-ART.md](PRIOR-ART.md). Order within
each section is by importance, not by when I learned it.

All of it comes from one story — a blog project where I asked for
perfection, a WebRTC project built on hand-written code where the docs
rotted while the code stayed clean, and the year of memory filth in
between. **Start with [the story](the-story.md)**; the pages are its
chapters.

**One rule for this repo:** "I have not found prior art" does not mean
"first". The searches were a handful of research agents over public
2024–2026 material. If you know earlier work for any claim, open an issue.
The claim becomes a citation. That is how this repo is supposed to work —
and it applies to me too:
[bans rotate the vocabulary](bans-rotate-the-vocabulary.md) partially
corrects [vocabulary control](vocabulary-control.md), because I measured my
own repo and half of my original claim did not survive.

## Principles — how the model actually behaves

| Finding | One line |
|---------|----------|
| [The dirty house](the-dirty-house.md) | Whatever your corpus does, the model will do more of. Reading is training, and my corpus outweighs my rules 880 to 1. The rules describe what the house should be; the floor shows what it is; the model believes the floor. |
| [The model doesn't know itself](the-model-doesnt-know-itself.md) | A model postdates its own training data, so everything it "knows about itself" is literature about predecessor models, worn in the first person. Capability questions are experiments, not interviews. |
| [The model's clock stopped at its cutoff](the-models-clock.md) | The harness feeds it today's date and it still searches last year and recalls stale versions. Quoting the date is not operating from it — standing check-what-is-latest rules convert one into the other. |
| [The missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md) | When something is wrong, the model offers plus or minus on the quantity your question named — more rules, fewer rules — and never a new variable. The sign oscillates; the axis never rotates. Reframes are your job. |
| [The file is scar tissue](the-file-is-scar-tissue.md) | An instruction file carries non-derivable experience about one environment. Smarter models follow rules better; they do not know which stove is hot. A genius baby still touches the fire once. |

## Failure modes — what goes wrong in practice

| Finding | One line |
|---------|----------|
| [The model votes for more rules](the-model-votes-for-more-rules.md) | Ask the model how to fix the model and you get the five deflections: gate me harder, every codebase looks like this, clean from now on, other repos have no rules, your rule file is too big. Demand measurements and refutations, not advice. |
| [The model's model of you](the-models-model-of-you.md) | An owner profile converts requirements into psychology: superlatives get mirrored, "expects micro-decisions" becomes a license, and the dossier is a shipped default nobody reviews. The model shouldn't know who you are. |
| [Don't ask for perfection](dont-ask-for-perfection.md) | Quality words are causal for a human and correlational for a model: "impeccable" selects the aesthetic of quality — ceremony, layers, ornament — not the substance. Every quality adjective converts to a constraint, a budget, or a test, or gets deleted. |
| [Bans rotate the vocabulary](bans-rotate-the-vocabulary.md) | Ban an AI's invented words and new ones appear within days. The words are compression devices, and the instruction file's own rules are the mint. Fix the pressure; enforce mechanically. |
| [The demonstration reflex](the-demonstration-reflex.md) | Ask an agent a question about its tools and it may answer by running the tools, at full cost. "Can you X" is a question, not a work order; capability is not demand. |
| [Agents launch at full price](agents-launch-at-full-price.md) | The model never counts its fan-out and never downgrades a lane's model — every working economy in delegation is human-imposed and machine-enforced. Cheap variants of expensive skills exist only if you build them. |
| [The session has no concurrency model](the-session-has-no-concurrency-model.md) | A session parallelizes by task shape, not data dependency: it edits under its readers, lets writers clobber each other, and won't wait, because idle feels stalled. Isolation and sequencing are imposed rules, never volunteered. |
| [Descriptive statements as directives](descriptive-statements-as-directives.md) | Tell an agent "I found X better than Y" and it starts doing X and dismantling Y. A report is not an order — and when sharing knowledge with your agent needs a "just FYI" disclaimer, description has become dangerous. |
| [The hardlink hazard](the-hardlink-hazard.md) | Sharing `node_modules` between agent worktrees with hardlinks breaks isolation: build caches share storage, so parallel agents corrupt each other's runs. A correctness bug the guides all describe as an optimization. |

## Methods — what actually works

| Finding | One line |
|---------|----------|
| [The link rule](the-link-rule.md) | When an agent says "X shows Y", X is usually a real measurement. The error is in the jump from X to Y. Checking that jump usually takes one command. |
| [The clean room](the-clean-room.md) | To clean a corpus without inheriting its style: a reader that emits only typed records, a writer that never sees the original, a checker that may see both sides because judging doesn't write. Designed, not yet run. |
| [The decision drain test](the-decision-drain-test.md) | Collect the human's pending decisions behind one tag and ask them in one batch per session. If the batch grows instead of shrinking, the process failed — stop adding structure. |
| [The cross-model audit](the-cross-model-audit.md) | Transcripts tell you when your model changed. To learn whether its work was actually bad, re-check the claims with a different model. |
| [The session archive](the-session-archive.md) | Keep an immutable append-only archive of every session and subagent trace, before you know the questions. Transcripts are the only record of what the model actually did, harnesses delete them, and every number in these notes came out of the archive. |
| [The rule-efficacy pipeline](the-rule-efficacy-pipeline.md) | Instruction files only grow. Transcripts can show which rules the current model still breaks, so pruning becomes data instead of guessing. |
| [Vocabulary control](vocabulary-control.md) | Ban the model's metaphors where they collide with your domain terms. Check new terms for collisions. When a rule is broken while in context, turn it into a lint. Scoped to meaning bugs. |
| [The founding document](the-founding-document.md) | Write the constitution before the corpus exists: intent and rules, human-written, day one. Case law accretes later from incidents. Never bootstrap the instruction file from auto-memories — that is model sediment as founding text. |
| [Memory belongs in the repo](memory-belongs-in-the-repo.md) | An out-of-repo memory mechanism is the instruction file with worse properties: unversioned, unshared, unlinted, a second load, growing in the dark. Fold findings into the repo; memory keeps only what can't live there. |

## Where these came from

The method behind all of them is simple. When work ships wrong despite
green checks, ask why the checks missed it — not why the bug happened.
Then turn the answer into a new check. The method itself is not new: Google
SRE says fix the system, not the people; QA calls it escaped-defect
analysis; Mitchell Hashimoto's AGENTS.md is a famous failure log. These
notes are what fell out of applying it hard for a month and then checking
what the field already knew.

## Neighbors

This repo sits beside — and cites — HumanLayer's 12-Factor Agents, Martin
Fowler's "Patterns for Reducing Friction in AI-Assisted Development", the
Ghostty failure-log pattern, METR's task-horizon work, and the 2025–26
field-notes genre. What is different here: each practice comes with the
incident that caused it, a way to enforce it, and the prior art I found.

---

Mihail Ivanov, first public draft 2026-07-30, restructured 2026-07-31.
[MIT license](LICENSE).
