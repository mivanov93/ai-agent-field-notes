# The decision drain test

**Claim:** a solo maintainer's pending rulings should be one greppable batch,
asked in one pass per session — and the process must carry its own
falsification condition: if the batch grows across sessions, or any entry
outlives two sessions, the bottleneck is decidability, not filing. Stop
adding structure and investigate why the questions are unanswerable.

## The incident

My project — one human, many AI sessions — developed a 600-line TODO
file nobody could navigate. The diagnosis, once counted, was not volume: AI
reviews generated *verified* findings faster than I could rule on them, and a
finding with no legal resting place stayed "open" forever. Six "open"
checkboxes were actually rulings I had already made, with nowhere to be
filed. My summary at the time: "I can't see what's happening."

The obvious fix — more tracker structure (a roadmap file, a backlog file, a
decisions file) — was run through a multi-agent review, and its devil's
advocate landed the punch: *a decisions file institutionalizes the backlog; a
place where rulings wait instead of getting drained.* Six pending rulings
don't need a schema. They need to be asked.

## The rule

- Every item only I can move carries one blocker tag (`owner`), in
  the same tag scheme as everything else. `grep` assembles the batch.
- A session ends by putting the open batch to me in chat, each item
  one line with options and a recommendation. Shorthand answers are valid
  rulings ("1-5 go, 9 option B").
- The session that receives a ruling files the resulting work and drops the
  tag in the same change — decisions cannot re-orphan in prose.
- **The drain test:** the batch must visibly shrink. If it grows across
  sessions, or any entry survives two sessions unanswered, the process has
  failed by its own definition — the constraint is decidability (the
  questions need more data to be answerable), and no filing structure will
  fix that. Stop building; investigate the questions instead.

## Why it works

The rulings are a *stock*; the review-to-decision imbalance is a *flow*.
Asking once drains the stock. The per-session ritual handles the flow. The
falsification clause is what keeps the mechanism honest: most process
machinery fails silently by relocating a problem, and this one is designed
to be caught doing that within two sessions.

## Prior art

- Rust's rfcbot **Final Comment Period** — the real ancestor for batched
  async sign-off instead of ambient pings (rust-lang/rfcbot-rs).
- The HITL "piling problem" / approval-fatigue literature names the
  bottleneck (MindStudio; Velt's approval-layer guide, 2026-06; arXiv
  2606.05770 "Human Oversight and Overload") but proposes routing, SLAs, or
  confidence thresholds — never a process test that names its own failure
  condition.

**The delta:** no source I found combines the greppable batch, the
single-pass ritual, and a built-in kill criterion. The kill criterion is the
part that matters.
