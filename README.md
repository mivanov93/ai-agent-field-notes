# AI Agent field notes

![Robots and construction machines building the Colosseum and the pyramids — the monuments that took lifetimes, going up in an afternoon](main.webp)

Notes on making AI coding agents behave. They come from months of running a
real project — a WebRTC project in Go with a TypeScript web client — almost
entirely through AI coding sessions. Each note started as a real incident:
something went wrong even though the right guidance was in the model's
context. Each note ends with something enforceable — a check, a lint, a
ritual — not just advice.

**Scope:** everything here was observed on Claude Opus 4.8, Opus 5, and
Fable 5, in the Claude Code harness, June–July 2026. By this repo's own
argument, findings are model-relative — re-measure before assuming they
hold for yours. They are also scoped to one kind of work — using AI agents
for software engineering; see [CONTEXT.md](CONTEXT.md) for what that scopes
in and out.

Each finding has its own page, cross-linked to the others. Every page cites
the closest published work I found and says exactly what I think is new.
The full search record is in [PRIOR-ART.md](PRIOR-ART.md), and how the
findings were derived, written, and vetted is in
[METHODOLOGY.md](METHODOLOGY.md). Order within each section is by importance,
not by when I learned it.

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

## Why this exists

The point is to hand you something immediately useful about working with AI
coding agents, with no fluff attached — no video to sit through, no course, no
hour of your day asked for. Read a page and use it. Or feed your session the
whole repo and ask it what to change about how you work: the notes are written
to be consumed that way — pragmatic and efficient, advice a model can act on
without you translating it first. A sample CLAUDE.md distilled from every
principle here — for a generic project — sits in
[examples/CLAUDE.md](examples/CLAUDE.md).

It also exists because everything is eventually invented and coined by someone.
I would rather share what I worked out myself, now, than hold it back and find
out later it was already known anyway. If someone got there first, that becomes
a citation rather than a loss — and the page still helped whoever read it today.

## On "partial"

Most pages here come back "partial" when I search for prior art: the pieces
exist somewhere, a neighbor gets cited, and I say so on the page. That is the
honest verdict. But partial is not the same as identical. A finding can share
a piece with earlier work and still differ in shape — a different mechanism, a
sharper trigger, a measurement nobody ran, a fix scoped to the exact failure.
The delta line on each page is where I state that difference, and in most cases
I think it is real.

There is also value in the gathering itself. These are in one place, cut to the
point, and written to use right away — read a page, or hand the whole repo to
your session and act on it — instead of scattered across papers, threads, and
posts you would have to find and stitch together yourself. That is worth
something on its own. Until someone shows a finding adds nothing new — which a
GitHub issue can do, at which point the claim becomes a citation — the bet this
repo makes is that there are genuinely new ideas here, and that collecting them
plainly is useful even where there are not.

**★ marks the pages with the most original claims** — if you already work in
this area, read those first. The basis is each page's own prior-art section
and [PRIOR-ART.md](PRIOR-ART.md); a ★ is a "not found" or a stated delta no
neighbor covers, not just an important idea. **↳ marks a derivative note** that
extends someone else's published work, credited in its title.

## Principles — how the model actually behaves

| Finding | One line |
|---------|----------|
| [The dirty house](the-dirty-house.md) | Whatever your corpus does, the model will do more of. Reading is training, and my corpus outweighs my rules 880 to 1. The rules describe what the house should be; the floor shows what it is; the model believes the floor. |
| [The model doesn't know itself](the-model-doesnt-know-itself.md) | A model postdates its own training data, so everything it "knows about itself" is literature about predecessor models, worn in the first person. Capability questions are experiments, not interviews. |
| [The model's clock stopped at its cutoff](the-models-clock.md) | The harness feeds it today's date and it still searches last year and recalls stale versions. Quoting the date is not operating from it — standing check-what-is-latest rules convert one into the other. |
| [The missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md) | When something is wrong, the model offers plus or minus on the quantity your question named — more rules, fewer rules — and never a new variable. The sign oscillates; the axis never rotates. Reframes are your job. |
| [The file is scar tissue](the-file-is-scar-tissue.md) | An instruction file carries non-derivable experience about one environment. Smarter models follow rules better; they do not know which stove is hot. A genius baby still touches the fire once. |
| [A gate you can fail](a-gate-you-can-fail.md) | A model reliably fixes its own mistakes only when something can reject them. With no check to fail — the city gate that turns you away so you go wash — it walks in dirty and no one is told. Build the gate; it is worth more than the model choice. |
| [AI is not Mr. Fix-IT](ai-is-not-mr-fix-it.md) | There is no incantation. "Fix it" in a loop does not converge, and bolting deep research or a bigger model onto it buys the same wrong answer at huge cost. You supply the decomposition, the missing fact, the reframe, and the check. |
| ["It can't be done" is usually out of date](it-cant-be-done-is-usually-out-of-date.md) | When the model says something is impossible, it is often reporting its training cutoff or the one version you have installed. A limitation is a measurement to take today — check the current release. |
| [The docs aren't on the test](the-docs-arent-on-the-test.md) | The benchmarks that rank coding models, and the rewards they train on, score test-pass only — never doc or comment quality. The model optimizes what is graded; docs rot because nothing grades them. |
| [The month that takes a day](the-month-that-takes-a-day.md) | A model can't estimate its own work — it quotes the by-hand human price ("that's a month") for a job it does in a day with tools the estimate never counts: read the whole API, compile until it compiles, build a gate. It doesn't know what it can do, so it can't say how long. |

## Failure modes — what goes wrong in practice

| Finding | One line |
|---------|----------|
| [The model votes for more rules](the-model-votes-for-more-rules.md) | Ask the model how to fix the model and you get the five deflections: gate me harder, every codebase looks like this, clean from now on, other repos have no rules, your rule file is too big. Demand measurements and refutations, not advice. |
| [The model's model of you](the-models-model-of-you.md) | An owner profile converts requirements into psychology: superlatives get mirrored, "expects micro-decisions" becomes a license, and the dossier is a shipped default nobody reviews. The model shouldn't know who you are. |
| [Don't ask for perfection](dont-ask-for-perfection.md) | Quality words are causal for a human and correlational for a model: "impeccable" selects the aesthetic of quality — ceremony, layers, ornament — not the substance. Every quality adjective converts to a constraint, a budget, or a test, or gets deleted. |
| ★ [Bans rotate the vocabulary](bans-rotate-the-vocabulary.md) | Ban an AI's invented words and new ones appear within days. The words are compression devices, and the instruction file's own rules are the mint. Fix the pressure; enforce mechanically. |
| [The demonstration reflex](the-demonstration-reflex.md) | Ask an agent a question about its tools and it may answer by running the tools, at full cost. "Can you X" is a question, not a work order; capability is not demand. |
| [Agents launch at full price](agents-launch-at-full-price.md) | The model never counts its fan-out and never downgrades a lane's model — every working economy in delegation is human-imposed and machine-enforced. And pinning models at dispatch only reaches one level: a subagent passes its model to whatever it spawns, so an expensive lane's grep-shaped helpers run at frontier price. Cheap variants of expensive skills exist only if you build them. |
| [The session has no concurrency model](the-session-has-no-concurrency-model.md) | A session parallelizes by task shape, not data dependency: it edits under its readers, lets writers clobber each other, and won't wait, because idle feels stalled. Isolation and sequencing are imposed rules, never volunteered. |
| [Descriptive statements as directives](descriptive-statements-as-directives.md) | Tell an agent "I found X better than Y" and it starts doing X and dismantling Y. A report is not an order — and when sharing knowledge with your agent needs a "just FYI" disclaimer, description has become dangerous. |
| ★ [Two worktrees, one node_modules](two-worktrees-one-node-modules.md) | `node_modules` is an immutable install and a mutable scratch directory in one folder, so every way of copying it breaks something: hardlinks let one worktree's failing run turn another's passing suite red, and a plain `cp -r` hands you a green pipeline that compiled nothing and tested nothing. Two paste-able demos, no repo to clone. Hits CI `node_modules` caching too, not just agents. |
| [The crash lands on the innocent process](the-crash-lands-on-the-innocent-process.md) | `/dev/shm`, `/tmp`, the Docker store and the package caches are machine-wide, unowned, and unattributed, so the process that dies is rarely the one that filled them: an IDE leaked 416 MB of shared memory and a different app crash-looped for it, reporting a network error. Agent fan-out, retry, and crash-recovery all draw harder on the same pools. |
| [All green, still broken](all-green-still-broken.md) | A passing suite only proves what it checks. A mobile client shipped green while it sent zero packets — nothing asserted a packet left the browser, and the tests ran against a stand-in, not the real page. When a surface goes load-bearing, re-ask what its tests are for. |
| [Move the code, lose the test](move-the-code-lose-the-test.md) | Pull duplicated code into one shared place and the tests that covered it can quietly stop, while everything stays green. After any such move, set each new input to its inert value and re-run — still-green is untested wiring. |
| ★ [Notes that rot](notes-that-rot.md) | The model explains its code by pointing at its own work-session — "item 6, round A" — which means nothing to a later reader; 85% of comment defects were these dead labels. Cite the reason, not the session. |
| [Don't interrupt a working agent](dont-interrupt-a-working-agent.md) | A steering message sent to a running agent can read like injected content and get refused as a hijack. Put everything in the launch prompt; if you must intervene, expect it may not land — stop and relaunch. |
| [It's already written down](its-already-written-down.md) | The model re-derives an answer your own reference notes already hold, because it never checks whether the answer exists. Point it at the notes before it investigates; a note nobody reads is a note nobody has. |
| ★ [You can't ask for cheaper](you-cant-ask-for-cheaper.md) | "Use fewer tokens" cuts the tests, reviews, and docs first, and the savings come back as bugs — you can't raid the gate. The exception: genuinely throwaway work with one pass condition, the cheapest rental car you drive 100m and return. |
| ↳ [Extension of Broekx: the shared git index](extends-broekx-shared-git-index.md) | Broekx named the shared-desk hazard and fixed it with worktrees; this adds the layer he skips — the shared git staging area, where an unscoped commit sweeps your half-staged work into the agent's. |
| [The leak is in the cleanup](the-leak-is-in-the-cleanup.md) | A model can't be trusted to remove confidential data: it scrubs the current files but leaves the secret in all of history, re-lists what it removed in the cleanup's own commit message, and can't tell a paraphrased tell from the banned word. You own the scope and verification; the model owns only the mechanics. |

## Methods — what actually works

| Finding | One line |
|---------|----------|
| ★ [The link rule](the-link-rule.md) | When an agent says "X shows Y", X is usually a real measurement. The error is in the jump from X to Y. Checking that jump usually takes one command. |
| ★ [The clean room](the-clean-room.md) | To clean a corpus without inheriting its style: a reader that emits only typed records, a writer that never sees the original, a checker that may see both sides because judging doesn't write. Designed, not yet run. |
| ★ [The decision drain test](the-decision-drain-test.md) | Collect the human's pending decisions behind one tag and ask them in one batch per session. If the batch grows instead of shrinking, the process failed — stop adding structure. |
| ★ [The cross-model audit](the-cross-model-audit.md) | Transcripts tell you when your model changed. To learn whether its work was actually bad, re-check the claims with a different model. |
| [The session archive](the-session-archive.md) | Keep an immutable append-only archive of every session and subagent trace, before you know the questions. Transcripts are the only record of what the model actually did, harnesses delete them, and every number in these notes came out of the archive. |
| ★ [The rule-efficacy pipeline](the-rule-efficacy-pipeline.md) | Instruction files only grow. Transcripts can show which rules the current model still breaks, so pruning becomes data instead of guessing. |
| ★ [Vocabulary control](vocabulary-control.md) | Ban the model's metaphors where they collide with your domain terms. Check new terms for collisions. When a rule is broken while in context, turn it into a lint. Scoped to meaning bugs. |
| [The founding document](the-founding-document.md) | Write the constitution before the corpus exists: intent and rules, human-written, day one. Case law accretes later from incidents. Never bootstrap the instruction file from auto-memories — that is model sediment as founding text. |
| [Memory belongs in the repo](memory-belongs-in-the-repo.md) | An out-of-repo memory mechanism is the instruction file with worse properties: unversioned, unshared, unlinted, a second load, growing in the dark. Fold findings into the repo; memory keeps only what can't live there. |
| ★ [Decide the shape first](decide-the-shape-first.md) | A plan that lists only steps lets the code's structure be decided by accident — one chat feature became an 872-line object nobody designed. Design the types and boundaries at planning time, not just the behavior. |
| [The tools you never use](the-tools-you-never-use.md) | Every connected tool, plugin, and MCP server costs context and startup whether or not it is called; 0.6% of one project's tool calls used a server, and ~15 loaded packs were never called. Curate per project. |
| ★ [Where the savings are](where-the-savings-are.md) | You cut agent cost only by taking off the bill what you didn't need or already had — do the work once, write the scar tissue so a run doesn't fail, unload unused tools, cache what repeats — and never under-buy the model the job needs. |
| [Where scar tissue comes from](where-scar-tissue-comes-from.md) | The retro — asking why the green checks missed it, not why the bug happened — is the ritual that mints each instruction-file rule. Leans KNOWN (SRE postmortems, escaped-defect analysis); the framing is the delta. |
| [The face transplant](the-face-transplant.md) | Applying a mock feels like a face transplant — graft the design on — and that's the model that fails. The working move is the opposite: keep the system's face and reshape it to match the mock held beside it. One frozen frame you can gate; every other state, you validate by hand. |

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

## Contact

Corrections and prior art belong in an issue — show me earlier work for any
claim here and it becomes a citation:
[file one](https://github.com/mivanov93/ai-agent-field-notes/issues/new).
The source is at
[github.com/mivanov93/ai-agent-field-notes](https://github.com/mivanov93/ai-agent-field-notes)
if you want to clone it. Everything else, including what I would most like to
hear about, is on the [contact page](contact.md).

---

Mihail Ivanov, first public draft 2026-07-30, restructured 2026-07-31.
[MIT license](LICENSE).
