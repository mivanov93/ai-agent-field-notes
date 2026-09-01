# AI Agent field notes

![Robots and construction machines building the Colosseum and the pyramids — the monuments that took lifetimes, going up in an afternoon](main.webp)

Notes on making AI coding agents behave. They come from months of running a
real project — a WebRTC project in Go with a TypeScript web client — almost
entirely through AI coding sessions. Each note started as a real incident:
something went wrong even though the right guidance was in the model's
context. Each note ends with something enforceable — a check, a lint, a
ritual — not just advice.

**Scope:** everything here was observed on Claude Opus 4.8, Opus 5, and
Fable 5 — the session models — in the Claude Code harness, June–August
2026. Sonnet 5 and Haiku 4.5 appear only in delegated agent subtasks,
such as the prior-art research fan-outs, never as the session driving
the work. By this repo's own argument, findings are model-relative —
re-measure before assuming they hold for yours. They are also scoped to one kind of work — using AI agents
for software engineering; see [CONTEXT.md](CONTEXT.md) for what that scopes
in and out.

Each finding has its own page, cross-linked to the others. Every page cites
the closest published work I found and says exactly what I think is new.
The full search record is in [PRIOR-ART.md](PRIOR-ART.md), and how the
findings were derived, written, and vetted is in
[METHODOLOGY.md](METHODOLOGY.md); the prose diseases these pages are
checked against are in [PLAGUE.md](PLAGUE.md). Order within each section
is by importance, not by when I learned it.

All of it comes from one story — a blog project where I asked for
perfection, a WebRTC project built on hand-written code where the docs
rotted while the code stayed clean, and the year of memory filth in
between. **Start with [the story](the-story.md)**; the pages are its
chapters. And if you'd rather have the repo working for you before you
read it, **[CONSUME.md](CONSUME.md)** is the fast path — copy-paste
prompts that make your session teach you, check your setup, and
install the skills.

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
[examples/CLAUDE.md](examples/CLAUDE.md). And the enforceable half of some
notes ships as installable Claude Code skills in [skills/](skills/README.md)
— the first is [deep-research-cheaper](skills/deep-research-cheaper/README.md),
the built-in research harness re-tiered onto cheaper models, its upstream
history and provenance documented the way this repo documents prior art.

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

| Finding | One line | Written |
|---------|----------|---|
| [The dirty house](the-dirty-house.md) | Whatever your corpus does, the model will do more of. Reading is training, and my corpus outweighs my rules 880 to 1. The rules describe what the house should be; the floor shows what it is; the model believes the floor. | 2026-07-31 |
| [The model doesn't know itself](the-model-doesnt-know-itself.md) | A model postdates its own training data, so everything it "knows about itself" is literature about predecessor models, worn in the first person. Capability questions are experiments, not interviews. | 2026-07-31 |
| [The model's clock stopped at its cutoff](the-models-clock.md) | The harness feeds it today's date and it still searches last year and recalls stale versions. Quoting the date is not operating from it — standing check-what-is-latest rules convert one into the other. | 2026-07-31 |
| [The model can't taste stale research](the-model-cant-taste-stale-research.md) | It knows the date is 2026 and still folds a correctly-dated 2023 finding into a present-day analysis as current fact — because staleness is a judgment it can't make. The clock note is the wrong *now*; this is the wrong *still-true*: it weights a source by whether it exists, not by whether the field it describes still does. | 2026-09-01 |
| [The missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md) | When something is wrong, the model offers plus or minus on the quantity your question named — more rules, fewer rules — and never a new variable. The sign oscillates; the axis never rotates. Reframes are your job. | 2026-07-31 |
| [The file is scar tissue](the-file-is-scar-tissue.md) | An instruction file carries non-derivable experience about one environment. Smarter models follow rules better; they do not know which stove is hot. A genius baby still touches the fire once. | 2026-07-31 |
| [A gate you can fail](a-gate-you-can-fail.md) | A model reliably fixes its own mistakes only when something can reject them. With no check to fail — the city gate that turns you away so you go wash — it walks in dirty and no one is told. Build the gate; it is worth more than the model choice. | 2026-07-31 |
| ★ [The lock that tears the hinges off](the-lock-that-tears-the-hinges-off.md) | The model's stay-up reflex — tolerate bad input, don't crash, don't lock anyone out — is right everywhere but a trust boundary, where refusing *is* the safety. So its checks cope instead of reject (a turnstile), and its recovery opens the door to fix the lock (fail-open). More defense, less safety — and asking for resilience is what builds the bypass. The [shared-key bug](a-lock-every-key-opens.md) was one shape; next time it's another. | 2026-08-31 |
| [AI is not Mr. Fix-IT](ai-is-not-mr-fix-it.md) | There is no incantation. "Fix it" in a loop does not converge, and bolting deep research or a bigger model onto it buys the same wrong answer at huge cost. You supply the decomposition, the missing fact, the reframe, and the check. | 2026-07-31 |
| ["It can't be done" is usually out of date](it-cant-be-done-is-usually-out-of-date.md) | When the model says something is impossible, it is often reporting its training cutoff or the one version you have installed. A limitation is a measurement to take today — check the current release. | 2026-07-31 |
| [The docs aren't on the test](the-docs-arent-on-the-test.md) | The benchmarks that rank coding models, and the rewards they train on, score test-pass only — never doc or comment quality. The model optimizes what is graded; docs rot because nothing grades them. | 2026-07-31 |
| [The month that takes a day](the-month-that-takes-a-day.md) | A model can't estimate its own work — it quotes the by-hand human price ("that's a month") for a job it does in a day with tools the estimate never counts: read the whole API, compile until it compiles, build a gate. It doesn't know what it can do, so it can't say how long. | 2026-07-31 |

## Failure modes — what goes wrong in practice

| Finding | One line | Written |
|---------|----------|---|
| [The model votes for more rules](the-model-votes-for-more-rules.md) | Ask the model how to fix the model and you get the five deflections: gate me harder, every codebase looks like this, clean from now on, other repos have no rules, your rule file is too big. Demand measurements and refutations, not advice. | 2026-07-31 |
| [Settled is a human word](settled-is-a-human-word.md) | The model promotes its own proposals to settled status — an ADR stamped "accepted" that nobody ruled, fixes "queued" in no queue, a tracker filing unverified findings as to-dos — and it keeps doing it after accurately admitting it, six catches counting the note's own first draft. The mechanisms only cheapen the catching: the owner is the mint, the log is the ledger, and the durable fix is the pushback itself. | 2026-08-26 |
| [The model's model of you](the-models-model-of-you.md) | An owner profile converts requirements into psychology: superlatives get mirrored, "expects micro-decisions" becomes a license, and the dossier is a shipped default nobody reviews. The model shouldn't know who you are. | 2026-07-31 |
| [Don't ask for perfection](dont-ask-for-perfection.md) | Quality words are causal for a human and correlational for a model: "impeccable" selects the aesthetic of quality — ceremony, layers, ornament — not the substance. Every quality adjective converts to a constraint, a budget, or a test, or gets deleted. | 2026-07-31 |
| ★ [Bans rotate the vocabulary](bans-rotate-the-vocabulary.md) | Ban an AI's invented words and new ones appear within days. The words are compression devices, and the instruction file's own rules are the mint. Fix the pressure; enforce mechanically. | 2026-07-31 |
| [The demonstration reflex](the-demonstration-reflex.md) | Ask an agent a question about its tools and it may answer by running the tools, at full cost. "Can you X" is a question, not a work order; capability is not demand. | 2026-07-30 |
| [Agents launch at full price](agents-launch-at-full-price.md) | The model never counts its fan-out and never downgrades a lane's model — every working economy in delegation is human-imposed and machine-enforced. Cheap variants of expensive skills exist only if you build them. | 2026-07-31 |
| [The session has no concurrency model](the-session-has-no-concurrency-model.md) | A session parallelizes by task shape, not data dependency: it edits under its readers, lets writers clobber each other, and won't wait, because idle feels stalled. Isolation and sequencing are imposed rules, never volunteered. | 2026-07-31 |
| [Descriptive statements as directives](descriptive-statements-as-directives.md) | Tell an agent "I found X better than Y" and it starts doing X and dismantling Y. A report is not an order — and when sharing knowledge with your agent needs a "just FYI" disclaimer, description has become dangerous. | 2026-07-31 |
| ★ [Two worktrees, one node_modules](two-worktrees-one-node-modules.md) | `node_modules` is an immutable install and a mutable scratch directory in one folder, so every way of copying it breaks something: hardlinks let one worktree's failing run turn another's passing suite red, and a plain `cp -r` hands you a green pipeline that compiled nothing and tested nothing. Two paste-able demos, no repo to clone. Hits CI `node_modules` caching too, not just agents. | 2026-08-03 |
| [The test that assumes it owns the table](the-test-that-assumes-it-owns-the-table.md) | The model's tests asserted over state they didn't create — a topic every suite parks to, a table a live service writes, a broker previous runs never wiped — so green was a bet that the world stayed quiet, and it lost as machine-load flakiness. Ownership nobody declares is ownership nothing checks; assert only over what you minted. | 2026-08-26 |
| [All green, still broken](all-green-still-broken.md) | A passing suite only proves what it checks. A mobile client shipped green while it sent zero packets — nothing asserted a packet left the browser, and the tests ran against a stand-in, not the real page. When a surface goes load-bearing, re-ask what its tests are for. | 2026-07-31 |
| [The model can't see the picture it drew](the-model-cant-see-the-picture-it-drew.md) | A model iterated a diagram blind through three rejections, called it readable sight-unseen, then claimed it couldn't render — the render was one command away, and nobody ran it during the incident. Run while writing this note, it took three seconds and caught what three rounds of pushback had caught by hand. The default loop never buys the look. | 2026-08-26 |
| [Move the code, lose the test](move-the-code-lose-the-test.md) | Pull duplicated code into one shared place and the tests that covered it can quietly stop, while everything stays green. After any such move, set each new input to its inert value and re-run — still-green is untested wiring. | 2026-07-31 |
| ★ [Notes that rot](notes-that-rot.md) | The model explains its code by pointing at its own work-session — "item 6, round A" — which means nothing to a later reader; 85% of comment defects were these dead labels. Cite the reason, not the session. | 2026-07-31 |
| ★ [Compression is what familiarity feels like from the inside](compression-is-what-familiarity-feels-like.md) | Right after digesting a large body of material the model reports in labels that resolve only inside its own context — expertise to the writer, noise to the reader — and the rule against it loses exactly then. Twice measured, the second time against this repo. | 2026-08-26 |
| [Don't interrupt a working agent](dont-interrupt-a-working-agent.md) | A steering message sent to a running agent can read like injected content and get refused as a hijack. Put everything in the launch prompt; if you must intervene, expect it may not land — stop and relaunch. | 2026-07-31 |
| [A skill is paid context](a-skill-is-paid-context.md) | The model packs install guides and provenance dossiers into the skill file itself — content every future run pays to load — three times in one afternoon, the last against a ruling less than an hour old. Skills carry no metadata about themselves; sibling files do. Vet what you write and what you download with [skill-audit](skills/skill-audit/README.md). | 2026-08-30 |
| [It's already written down](its-already-written-down.md) | The model re-derives an answer your own reference notes already hold, because it never checks whether the answer exists. Point it at the notes before it investigates; a note nobody reads is a note nobody has. | 2026-07-31 |
| [The rule you don't need yet](the-rule-you-dont-need-yet.md) | Mining another project's CLAUDE.md with the model is a lossy read: it drops the rules whose subject isn't active in the target yet — which are exactly the ones you can't re-derive when the hazard arrives. And a ruling you make in chat is orchestrator knowledge; only the file is read by your lanes. | 2026-08-04 |
| ★ [You can't ask for cheaper](you-cant-ask-for-cheaper.md) | "Use fewer tokens" cuts the tests, reviews, and docs first, and the savings come back as bugs — you can't raid the gate. The exception: genuinely throwaway work with one pass condition, the cheapest rental car you drive 100m and return. | 2026-07-31 |
| ↳ [Extension of Broekx: the shared git index](extends-broekx-shared-git-index.md) | Broekx named the shared-desk hazard and fixed it with worktrees; this adds the layer he skips — the shared git staging area, where an unscoped commit sweeps your half-staged work into the agent's. | 2026-07-31 |
| [The crash lands on the innocent process](the-crash-lands-on-the-innocent-process.md) | `/dev/shm`, `/tmp`, and the Docker store are machine-wide, fixed-size, and unowned: the process that dies is rarely the one that filled them, no error message names them, and agents multiply both the filling and the dying. Check the shared pools before the app. | 2026-08-04 |
| [The switch throws the cache away](the-switch-throws-the-cache-away.md) | The prompt cache is bound to the model and effort, so switching either mid-session recomputes the whole context from cold — a full re-read that costs dollars on the API and usage-quota plus latency on a subscription. Anthropic's fallback credit refunds it, but only on the API and only for the one involuntary classifier flip; on the Max/Pro plan most people run, every switch — even the involuntary one — is uncredited. Pick a model and hold it. | 2026-09-01 |

## Security — the agent as an attack surface

| Finding | One line | Written |
|---------|----------|---|
| [The fetcher shouldn't have a shell](the-fetcher-shouldnt-have-a-shell.md) | An agent that reads untrusted web pages shouldn't also hold a shell — give it one and, the moment WebFetch fails, it curls the URL itself and a stranger's page flows through your command line. Claude Code's deep-research ships fetch agents that do exactly this, unattended across a fan-out; Rehberger demonstrated the full chain to code execution. Take the shell off the reader; fail closed when the safe tool fails. | 2026-09-01 |
| [A lock every key opens](a-lock-every-key-opens.md) | The model wrote an Ed25519 JWT identity service that scored top marks on every axis — idiom, current libraries, a JWKS endpoint, a passing suite, a clean security-linter run — and voided all of it by loading the signing key as a file's first 32 bytes without checking the file was a seed. Every PEM then yields one public key. The `#nosec` suppression sat on the exact line, true and beside the point. Reproduced from scratch. | 2026-08-31 |
| [The classifier reads the costume](the-classifier-reads-the-costume.md) | Legitimate defensive-security work in exploit-and-attack vocabulary kept tripping a cyber classifier that silently swapped my model — the session blamed me for the switches and, after the shuffle, miscounted its own agents: six asked, eight running. Only the operator sees both cause and cost. Turn off `switchModelsOnFlag`, write it plain, de-trigger the artifact, restart clean. | 2026-08-29 |
| [Old sessions run the old rules](old-sessions-run-the-old-rules.md) | Claude Code reads CLAUDE.md once, at session start, and never reloads it — edit the file to add a rule or a defense and the running session keeps following the copy it loaded when it began. So a session open before you hardened the file stays unhardened, and the ones most likely to be unsafe are the ones least likely to carry the new rule. Restart after you harden. | 2026-09-01 |
| [The leak is in the cleanup](the-leak-is-in-the-cleanup.md) | A model can't be trusted to remove confidential data: it scrubs the current files but leaves the secret in all of history, re-lists what it removed in the cleanup's own commit message, and can't tell a paraphrased tell from the banned word. You own the scope and verification; the model owns only the mechanics. | 2026-07-31 |

## Methods — what actually works

| Finding | One line | Written |
|---------|----------|---|
| ★ [The link rule](the-link-rule.md) | When an agent says "X shows Y", X is usually a real measurement. The error is in the jump from X to Y. Checking that jump usually takes one command. | 2026-07-30 |
| ★ [The clean room](the-clean-room.md) | To clean a corpus without inheriting its style: a reader that emits only typed records, a writer that never sees the original, a checker that may see both sides because judging doesn't write. Designed, not yet run. | 2026-07-31 |
| ★ [The doctor doesn't catch the fever](the-doctor-doesnt-catch-the-fever.md) | A 100-document corpus of broken prose, cleaned with no reading barrier: name the diseases first with two frontier models, gate every artifact by hand, fix in small batches with a check pass, read everything yourself. One run, human-accepted; whether labels, batches, or gates did the protecting is unmeasured. | 2026-08-26 |
| ★ [The decision drain test](the-decision-drain-test.md) | Collect the human's pending decisions behind one tag and ask them in one batch per session. If the batch grows instead of shrinking, the process failed — stop adding structure. | 2026-07-30 |
| ★ [The cross-model audit](the-cross-model-audit.md) | Transcripts tell you when your model changed. To learn whether its work was actually bad, re-check the claims with a different model. | 2026-07-30 |
| [The session archive](the-session-archive.md) | Keep an immutable append-only archive of every session and subagent trace, before you know the questions. Transcripts are the only record of what the model actually did, harnesses delete them, and every number in these notes came out of the archive. | 2026-07-31 |
| ★ [The rule-efficacy pipeline](the-rule-efficacy-pipeline.md) | Instruction files only grow. Transcripts can show which rules the current model still breaks, so pruning becomes data instead of guessing. | 2026-07-30 |
| ★ [Vocabulary control](vocabulary-control.md) | Ban the model's metaphors where they collide with your domain terms. Check new terms for collisions. When a rule is broken while in context, turn it into a lint. Scoped to meaning bugs. | 2026-07-30 |
| [The founding document](the-founding-document.md) | Write the constitution before the corpus exists: intent and rules, human-written, day one. Case law accretes later from incidents. Never bootstrap the instruction file from auto-memories — that is model sediment as founding text. | 2026-07-31 |
| [Memory belongs in the repo](memory-belongs-in-the-repo.md) | An out-of-repo memory mechanism is the instruction file with worse properties: unversioned, unshared, unlinted, a second load, growing in the dark. Fold findings into the repo; memory keeps only what can't live there. | 2026-07-31 |
| ★ [Decide the shape first](decide-the-shape-first.md) | A plan that lists only steps lets the code's structure be decided by accident — one chat feature became an 872-line object nobody designed. Design the types and boundaries at planning time, not just the behavior. | 2026-07-31 |
| [The tools you never use](the-tools-you-never-use.md) | Every connected tool, plugin, and MCP server costs context and startup whether or not it is called; 0.6% of one project's tool calls used a server, and ~15 loaded packs were never called. Curate per project. | 2026-07-31 |
| ★ [Where the savings are](where-the-savings-are.md) | You cut agent cost only by taking off the bill what you didn't need or already had — do the work once, write the scar tissue so a run doesn't fail, unload unused tools, cache what repeats — and never under-buy the model the job needs. | 2026-07-31 |
| [Where scar tissue comes from](where-scar-tissue-comes-from.md) | The retro — asking why the green checks missed it, not why the bug happened — is the ritual that mints each instruction-file rule. Leans KNOWN (SRE postmortems, escaped-defect analysis); the framing is the delta. | 2026-07-31 |
| [The face transplant](the-face-transplant.md) | Applying a mock feels like a face transplant — graft the design on — and that's the model that fails. The working move is the opposite: keep the system's face and reshape it to match the mock held beside it. One frozen frame you can gate; every other state, you validate by hand. | 2026-07-31 |

## Skills — the notes, packaged to run

| Skill | One line |
|-------|----------|
| [deep-research-cheaper](skills/deep-research-cheaper/README.md) | The built-in deep-research harness with the fan-out re-tiered — search on Haiku, fetch and the 3-vote adversarial verify on Sonnet — and the freed budget spent on coverage: 25 verified claims where the then-current built-in capped at 8. Its page carries the upstream timeline and who-gets-credit. |
| [skill-audit](skills/skill-audit/README.md) | Vets a skill folder — downloaded or your own — for self-metadata riding in paid context and for dangerous instructions: run-on-load, exfiltration, credential reach, injection-shaped text. Report only, never edits. Minted from [a skill is paid context](a-skill-is-paid-context.md). |

Install by copying a skill's folder into `~/.claude/skills/`; details in
[skills/](skills/README.md). Nothing runs on install, and a session runs
a skill only when you ask it to.

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
