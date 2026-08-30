# The decision drain test

*Written 2026-07-30 · last amended 2026-08-31.*

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

## The ladder is the other answer

The [agreement ladder](settled-is-a-human-word.md) solves an overlapping
problem from the other side, and the two are alternatives, not layers. This
test collects the pending decisions and asks them, with a kill criterion: a
growing batch means the questions are too hard as asked, so stop adding
structure. The ladder instead gives every item a rung, keeps the owner
minting its status, and leans on a running handoff to stay oriented as the
list grows.

They fit different failures. This test was scar tissue from a project with
no way to see its own decision pile — so a growing pile was the alarm. A
project that already has that visibility, holds the model at L0 by default,
and audits stale rungs reconstructs this test's value by other means: the
handoff is the navigation, the ladder's audit catches the stuck item. There
a growing list is productive work to track, not a broken process to stop,
and this test's kill criterion would misfire — an owner running the ladder
over days reports exactly that. So reach for the drain test when the pile is
unnavigable and its growth may hide questions you cannot answer as posed;
reach for the ladder when the decisions are bulk and answerable and the risk
is their status rounding up.

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
