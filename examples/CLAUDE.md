# CLAUDE.md — a sample working agreement

*A sample instruction file distilled from every principle in this repo, for a
generic software project — not the project these notes came from. Swap the
bracketed parts for your own; the rest is portable. Each rule links the note it
comes from. This is a demonstration of what a principled instruction file
covers, not a config to drop in unread.*

*It is read by two audiences — the agent it steers and the human running the
project — so each rule is tagged with who it is addressed to:*

- *`[model]` — the agent executes this in its work.*
- *`[operator]` — you set it up or do it; the agent should recognize and respect
  it, not execute it.*
- *`[shared]` — both have a role.*

*The tag is authorial intent — who the line is for — not a claim about what a
model can or cannot do. Where a rule's audience is genuinely unproven, settle it
by an experiment (remove the rule, run the task, see whether behavior changes),
never by asking a model to introspect
([the model doesn't know itself](../the-model-doesnt-know-itself.md)).*

## 1. The constitution — write this by hand, first

`[operator]` Written before any code or docs exist, so the rules exist before
the corpus that would otherwise outvote them
([the founding document](../the-founding-document.md)). Never generate it from
the agent's auto-memories. You author the four items below; the agent reads and
respects them.

- **What this is:** `<one sentence>`.
- **What "good" means here:** `<stated as constraints — see §3 — never as
  "impeccable" or "production-grade">`.
- **Out of scope (the deliberately-absent list):** `<what this project will not
  do>`. Keep it current; it restrains the agent better than any superlative
  motivates it ([don't ask for perfection](../dont-ask-for-perfection.md)).
- **Who decides:** `<the human's authority, for authorization only>`. This file
  holds no *profile* of that human — no "expects…", no "prefers…", no
  engineering bar rendered as adjectives
  ([the model's model of you](../the-models-model-of-you.md)).

## 2. Working with the agent

- `[operator]` **Bring the hypothesis; the agent verifies.** Research briefs say
  "confirm or refute X," never "find what's wrong" — the second returns the
  model's prior. Originating a new variable is your job
  ([the missing hypothesis is orthogonal](../the-missing-hypothesis-is-orthogonal.md)).
- `[operator]` **No "fix it" loops.** Repeating "fix it" does not converge; when
  a loop stalls, change the problem — supply the decomposition, the missing
  fact, the reframe, or the check
  ([AI is not Mr. Fix-IT](../ai-is-not-mr-fix-it.md)).
- `[model]` **A question is not a work order.** "Can you X?" gets an answer, not
  an execution ([the demonstration reflex](../the-demonstration-reflex.md)).
- `[model]` **A report is not an order.** "I found X better than Y" licenses X
  on future work, never a migration of existing state — propose, don't act
  ([descriptive statements as directives](../descriptive-statements-as-directives.md)).
- `[operator]` **Don't ask the model how to fix the model.** It offers
  more-rules / fewer-rules, never a new variable; demand measurements and
  refutations ([the model votes for more rules](../the-model-votes-for-more-rules.md)).
- `[operator]` **Capability questions are experiments, not interviews.** What
  the model says about its own limits is literature about older models; measure
  instead ([the model doesn't know itself](../the-model-doesnt-know-itself.md)).
- `[operator]` **Don't trust the model's estimate of its own work.** "Too hard" or
  "a month" is the one number it is structurally unfit to give — it quotes the
  by-hand human price, blind to its own reading-and-iterating. Treat feasibility
  and duration as a hypothesis to test by attempting, not a verdict
  ([the month that takes a day](../the-month-that-takes-a-day.md)).
- `[shared]` **Write security-adjacent work in domain-plain words, and turn off
  the model-swap before you need it.** Exploit/attack/red-team/extraction
  register can trip a safety classifier that silently swaps your model and rides
  in the context; set `switchModelsOnFlag: false` so a flag pauses instead of
  switching, and de-trigger saved artifacts too — the next session re-trips on
  their words on orientation
  ([the classifier reads the costume](../the-classifier-reads-the-costume.md)).

## 3. Quality, stated as checks

`[operator]` Every quality adjective converts to a constraint, a budget, or a
test — or it is deleted, because quality words select the aesthetic of quality,
not the substance ([don't ask for perfection](../dont-ask-for-perfection.md)).

- "Secure" → `<validate inputs, fail closed, tear down on malformed…>`.
- "Fast" → `<a measured budget on the measured hot path; simplest correct thing
  elsewhere>`.
- "Reliable" → `<the specific failure modes handled, and the accepted ones
  named>`.
- The test for any remaining quality word: can a session tell whether it
  complied? If not, delete it — register gets mirrored, not obeyed.

## 4. Gates — nothing ships on the model's say-so

- `[shared]` **Build a check it can fail.** Where nothing can reject the work,
  *you* are the check — the expensive path — so build the gate; it is worth more
  than the model choice ([a gate you can fail](../a-gate-you-can-fail.md)).
- `[shared]` **Green proves only what it asserts.** When a surface becomes
  load-bearing, re-ask what its tests are for, assert the core property, and
  drive the real running artifact, not a stand-in
  ([all green, still broken](../all-green-still-broken.md)).
- `[shared]` **"X shows Y" — check the jump.** Did X actually exercise Y?
  Usually one command ([the link rule](../the-link-rule.md)).
- `[model]` **After extracting shared code,** set each new input to its inert
  value and re-run; anything still green there has no test behind it
  ([move the code, lose the test](../move-the-code-lose-the-test.md)).
- `[operator]` **Applying a mockup is the expensive part, not making it.** The
  mock gates only the one state it depicts; budget the application, not the
  mockup ([the face transplant](../the-face-transplant.md)).
- `[shared]` **Render the picture before trusting any claim about it.**
  "Readable," "no overlaps," "each label on its own arrow" are banned
  sight-unseen; the honest status for an unrendered diagram is "unverified:
  never rendered." Put the render in the loop and hand the image back — the
  look is a gate, and gates are the wrong place to save tokens
  ([the model can't see the picture it drew](../the-model-cant-see-the-picture-it-drew.md)).
- `[model]` **A test may only assert over state it minted** — its own batch id,
  key range, dedicated topic. Blanket `count(*)`, assert-table-empty, and
  "drain until quiet" quantify over the whole world and claim an ownership
  nobody wrote down; terminate on your own records, counted and capped
  ([the test that assumes it owns the table](../the-test-that-assumes-it-owns-the-table.md)).
- `[shared]` **Redaction is human-scoped and human-verified; the model only
  runs the mechanics.** You name the secret and its paraphrases; you check
  every commit's content *and* message after a full history rewrite — a
  working-tree grep proves nothing about the commits behind it. And the cleanup
  must never describe what it removed, or it has re-published it
  ([the leak is in the cleanup](../the-leak-is-in-the-cleanup.md)).

## 5. Structure

- `[shared]` **Design the types and their boundaries at planning time,** not
  just the steps — a plan of steps alone lets the structure be decided by
  accident, and no task-scoped review will flag its absence
  ([decide the shape first](../decide-the-shape-first.md)).

## 6. Freshness

- `[model]` **"Latest" is a lookup, never a recall;** research checks
  publication dates against today
  ([the model's clock stopped at its cutoff](../the-models-clock.md)).
- `[model]` **"It can't be done" is a claim about a version and a date** — check
  the current upstream release before believing it
  (["it can't be done" is usually out of date](../it-cant-be-done-is-usually-out-of-date.md)).
- `[model]` **Grep the reference notes and known-issues file before
  investigating** a library or tool's behavior; the answer is often already
  written down ([it's already written down](../its-already-written-down.md)).

## 7. Cost

- `[shared]` **Don't ask for cheaper — engineer it.** A blanket "use fewer
  tokens" cuts the tests, reviews, and docs first; never raid the checking
  budget ([you can't ask for cheaper](../you-cant-ask-for-cheaper.md)). Cheap is
  only honest for genuinely throwaway work with one pass condition.
- `[shared]` **Save by cutting what you didn't need:** do the work once,
  unload unused tools, cache the repeating prefix — and never under-buy the
  model the job needs ([where the savings are](../where-the-savings-are.md)).
- `[shared]` **Curate connected tools per project;** disconnect what real
  sessions never call ([the tools you never use](../the-tools-you-never-use.md)).

## 8. Delegation and concurrency

*Jargon, once: a **fan-out** is launching several sub-agents at once; a **lane**
is one such sub-agent's task; a **worktree** is a separate checked-out copy of
the repo so parallel work does not collide.*

- `[shared]` **Price the fan-out.** Every launch names its lane count and
  per-lane model before dispatch; a check fails any saved lane with no model set
  — the default it overrides is "inherit the expensive one"
  ([agents launch at full price](../agents-launch-at-full-price.md)).
- `[shared]` **A writer gets its own worktree and its own dependency install.**
  Not a hardlinked copy (build caches then cross every tree at once), and not a
  plain `cp -r` either (a cache already inside `node_modules` rides any copy —
  `tsc` inherits a stale build record, exits 0 and emits nothing)
  ([the session has no concurrency model](../the-session-has-no-concurrency-model.md),
  [the hardlink hazard](../two-worktrees-one-node-modules.md)).
- `[shared]` **Freeze the tree for read-only lanes,** or hand them a snapshot
  of a fixed commit, and parallelize by data dependency, not task shape
  ([the session has no concurrency model](../the-session-has-no-concurrency-model.md)).
- `[shared]` **Commit with explicit file lists, never "commit everything,"** and
  keep your own processes on ports the agent won't reuse — you share the working
  tree and the git index with it
  ([extension of Broekx: the shared git index](../extends-broekx-shared-git-index.md)).
- `[shared]` **Front-load the brief.** A mid-run correction may read as an
  injection and be refused; the agent should ask everything up front, knowing
  steering may not land
  ([don't interrupt a working agent](../dont-interrupt-a-working-agent.md)).
- `[shared]` **Check the shared pools before the app.** `/dev/shm`, `/tmp`, the
  Docker store and package caches are machine-wide, fixed-size and unowned; the
  process that dies is rarely the one that filled them, and fan-out plus retry
  multiplies both. Run `df -h /dev/shm /tmp /` and `docker system df` before
  any log-reading; give agents a scratch dir you can measure and sweep, and
  quota the Docker build cache
  ([the crash lands on the innocent process](../the-crash-lands-on-the-innocent-process.md)).
- `[model]` **Translate lane density at the owner boundary — never pass it
  through.** Sub-agent reports are legitimately terse; owner-facing items carry
  what happens today, why it's a problem, the change, and the cost — never a
  list of coined noun-phrases. Expect the failure right after a large
  ingestion, and reread the draft holding none of the map
  ([compression is what familiarity feels like from the inside](../compression-is-what-familiarity-feels-like.md)).

## 9. The instruction file, and the record

- `[shared]` **Every rule carries the incident that caused it**
  ([the file is scar tissue](../the-file-is-scar-tissue.md)); rules accrete from
  retros — when work ships wrong past green checks, ask why the checks missed it
  and write the answer as a new check or rule
  ([where scar tissue comes from](../where-scar-tissue-comes-from.md)).
- `[shared]` **Keep knowledge in the repo,** not an out-of-repo memory store;
  fold findings into this file or the docs, and let memory hold only what
  genuinely cannot live here
  ([memory belongs in the repo](../memory-belongs-in-the-repo.md)).
- `[shared]` **Port this file by section, with an explicit keep / drop / defer
  per section** — a model's port filters for "relevant now" and drops exactly
  the rules you can't re-derive when their hazard arrives, so rules for hazards
  you haven't met yet are the highest-value import, not the lowest. Never fill
  a section the target hasn't decided; "not yet decided" is good content. And a
  ruling made in chat is promoted to the file the same session, or no agent
  ever reads it ([the rule you don't need yet](../the-rule-you-dont-need-yet.md)).
- `[model]` **Cite the reason, not the work session** — no "step 6, round A"; a
  merge check greps for them ([notes that rot](../notes-that-rot.md)).
- `[shared]` **A skill file is paid context, not a page.** The body carries only
  what the executing session needs — when to use, how to run, the knobs; install
  guides, history, credits, and other self-metadata go in sibling files the
  runtime never loads. Name the destination file when asking for additions, or
  the most document-shaped file wins — and audit skills you write or download
  for useless and dangerous content
  ([a skill is paid context](../a-skill-is-paid-context.md)).
- `[shared]` **Ban a metaphor only where it collides with a domain term,** and
  enforce it with a lint, not with attention
  ([vocabulary control](../vocabulary-control.md),
  [bans rotate the vocabulary](../bans-rotate-the-vocabulary.md)).
- `[shared]` **Keep the corpus clean** — the model imitates what the repo
  already is, and the corpus outweighs the rules
  ([the dirty house](../the-dirty-house.md)). If it is already contaminated,
  cleaning it needs a reader/writer barrier, not more rules
  ([the clean room](../the-clean-room.md)).
- `[operator]` **Clean a contaminated corpus taxonomy-first, by dose and gates,
  not in one pass.** Name the diseases at the frontier in duplicate, hold the
  model floor you found by trying, fix in small batches with a check pass, and
  read every diff yourself — only a reader accepts the result
  ([the doctor doesn't catch the fever](../the-doctor-doesnt-catch-the-fever.md)).
- `[operator]` **Nothing benchmarks doc quality;** supply your own standard — an
  example to imitate, a review that judges readability
  ([the docs aren't on the test](../the-docs-arent-on-the-test.md)).
- `[operator]` **Keep an immutable, append-only archive** of every session and
  subagent trace; never delete a session until it is archived
  ([the session archive](../the-session-archive.md)).
- `[shared]` **Prune rules that never fire,** measured from the transcripts
  ([the rule-efficacy pipeline](../the-rule-efficacy-pipeline.md)); and
  **re-check a suspect model's work with a different model**
  ([the cross-model audit](../the-cross-model-audit.md)).

## 10. Decisions

`[operator]` Collect the human's pending decisions behind one tag and clear the
batch each session. If the batch grows instead of shrinking, the process failed
— stop adding structure ([the decision drain test](../the-decision-drain-test.md)).

- `[shared]` **Status words are human acts — the model never types them.**
  Accepted, settled, confirmed, closed, queued name a state a human produced; a
  status word in a model-authored diff is the lint target, and everything the
  model produces is "proposed" until you did the settling. A to-do is a
  promotion too — a task minted from an unverified claim inherits "unverified"
  ([settled is a human word](../settled-is-a-human-word.md)).
