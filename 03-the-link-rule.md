# The link rule

**Claim:** when an AI agent reports "X shows Y", the measurement X is
usually real. The error is in the jump from X to Y, which nobody checked.
Checking that jump usually takes one command. "Verify your work" fails as
advice because it does not say what to check. The link rule does.

## The incidents

Six wrong claims shipped in one day's work. I caught every one by asking a
simple question. The agent caught none:

- A visual check reported 61 PASS / 0 FAIL, and the agent wrote that this
  proved new GPU flags were safe. The check's own argument list showed it
  had launched without the flags. The 61/0 was real. The conclusion was
  not.
- Two test runs failed 45 and 46 times against a normal ~20. The agent
  blamed the new GPU flags and produced a confident explanation about
  rendering under load. The log said, twice, in plain English: a leftover
  server was holding a port, and every test on one worker failed because of
  it. The counts were real. The explanation was invented.
- "WebKit passed everything it ran." It ran nothing. The project filter did
  not include the new WebKit targets, so 90 tests were skipped.

Same shape every time. The numbers were never faked. The jump from the
numbers to the sentence was never checked. Each check took seconds: grep
the arguments, grep the log, count passes per project.

## The rule

- Treat "X shows/proves/confirms Y" as a claim about the jump. Check the
  jump: did X actually exercise Y? One command, almost every time.
- In review, ask "what did the author claim without checking" before "is
  the logic right". A review weighted that way found 44 problems in the arc
  above. Most were claims that no longer matched the code, not logic bugs.
- Where a wrong conclusion is cheap to reach, make the machine say the
  truth loudly. The held port now fails the test run up front, naming the
  port. The jump you forget to check is the one that gets you.

## Prior art

- moonrunnerkc, "AI coding agents lie about their work" (dev.to,
  2026-03-29). States the mechanism almost word for word — "the measurement
  itself is accurate, but the inference is broken" — then prescribes
  verification tooling rather than the cheap targeted check.
- Patrick Hughes, "Your AI Agent Says 'Done.' Make It Prove It."
  (2026-06-24). "A log line is a statement; proof is a check against the
  world." Aimed at claims in general.
- Anthropic, "Building verification loops in Claude Code with skills"
  (2026-07-22). Run-the-check guidance, without separating a real
  measurement from a wrong conclusion drawn from it.
- Academic ancestor: "Let's Verify Step by Step" (arXiv:2305.20050) —
  checking the process, not just the outcome, for training reward models.

**What I think is new:** the closest writing circles the idea but never
names the practice — the measurement is fine, check the jump, it costs one
grep.
