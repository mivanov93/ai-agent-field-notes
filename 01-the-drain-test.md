# The decision drain test

**Claim:** collect the pending human decisions behind one tag and ask them
in one batch per session. Build the failure condition into the process: if
the batch grows across sessions, or one entry survives two sessions, filing
was never the problem — the questions are too hard to answer as asked. Stop
adding structure and find out why.

## The incident

My project — one human, many AI sessions — grew a 600-line TODO file nobody
could navigate. When I finally counted, the problem was not volume. AI
reviews produced verified findings faster than I could rule on them. A
finding with no place to go stayed "open" forever. Six "open" checkboxes
were decisions I had already made, with nowhere to be filed. My words at
the time: "I can't see what's happening."

The obvious fix was more structure: a roadmap file, a backlog file, a
decisions file. I ran that plan through a multi-agent review, and the
devil's advocate killed most of it with one argument: a decisions file is a
place where decisions wait. Six pending decisions don't need a schema. They
need to be asked.

## The rule

- Every item only I can decide carries one tag (`owner`). `grep` collects
  the batch.
- A session ends by asking me the whole batch in chat: one line per item,
  with options and a recommendation. Short answers count ("1-5 go, 9
  option B").
- The session that gets an answer files the follow-up work and removes the
  tag in the same change.
- **The drain test:** the batch must shrink. If it grows across sessions,
  or one entry stays unanswered for two sessions, the process failed. The
  bottleneck is not filing — the questions need more information before
  they can be answered. Stop building structure and go get it.

## Why it works

The pending decisions are a pile. The review-versus-decision imbalance is a
flow. Asking once clears the pile; the per-session ritual handles the flow.
The built-in failure condition is the important part: most process changes
fail quietly by moving the problem somewhere else. This one gets caught
doing that within two sessions.

## Prior art

- Rust's rfcbot Final Comment Period: batched sign-off instead of constant
  pings (rust-lang/rfcbot-rs). The real ancestor.
- The "approval fatigue" writing on human-in-the-loop agents names the
  bottleneck (MindStudio's piling-problem post; Velt's approval-layer
  guide, 2026-06; arXiv 2606.05770). The fixes proposed there are routing,
  SLAs, and confidence thresholds — never a process that states its own
  failure condition.

**What I think is new:** the combination — one greppable batch, one ask per
session, and a built-in kill criterion. The kill criterion is the part that
matters.
