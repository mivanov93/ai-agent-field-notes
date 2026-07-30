# The link rule

**Claim:** when an AI agent reports "X shows Y", the measurement X is usually
real. The failure lives in the unchecked inference between X and Y — and
auditing that inference is usually one command. "Verify your work" fails as
guidance because it names a virtue, not a trigger; the link rule names the
exact thing to check.

## The incidents

Six claims shipped in a single day's arc, every one caught by me
asking a plain question, none by the agent checking:

- A visual gate reported 61 PASS / 0 FAIL and the agent wrote that this
  proved new GPU flags were safe. The gate's own argument list showed it had
  launched with two fake-media flags and nothing else — it never ran the
  flags. The 61/0 was real. The inference was not.
- Two suite runs failed 45 and 46 times against a ~20 baseline; the agent
  attributed the regression to the GPU flags and produced a confident
  mechanism (software rasterization under parallel load). The actual cause
  sat in the log in English, twice: a leftover server held the port, so
  every test on one worker failed. The counts were real. The attribution
  was invented.
- "WebKit passed everything it ran." It ran nothing — the project filter
  never included the new WebKit targets, and 90 tests skipped.

The common shape: not fabricated measurements — *unexamined links*. Each
audit was seconds: grep the gate's args, grep the log for "already in use",
count passes per project.

## The rule

- An agent's completion claim of the form "X shows/proves/confirms Y" is a
  claim about the link. Audit the link, not the measurement: did X actually
  exercise Y? It is one command almost every time.
- In review, weight lanes toward "what did the author assert without
  checking" over "is the logic correct" — on the arc above, a review so
  weighted found 44 issues; most were claims that had outlived the code,
  not logic errors.
- The corollary for gates: where a wrong conclusion is cheap to reach, make
  the machine say the true thing loudly (a held port now fails the run
  pre-flight, naming the port) — because the link audit you forget is the
  one that bites.

## Prior art

- moonrunnerkc, "AI coding agents lie about their work" (dev.to,
  2026-03-29) — states the mechanism almost verbatim ("the measurement
  itself is accurate — but the inference is broken") but prescribes
  architectural outcome-verification, not the cheap targeted audit.
- Patrick Hughes, "Your AI Agent Says 'Done.' Make It Prove It."
  (2026-06-24) — "a log line is a statement; proof is a check against the
  world"; falsifiable single-command checks, aimed at claims generally.
- Anthropic, "Building verification loops in Claude Code with skills"
  (2026-07-22) — run-the-check guidance without the measurement/inference
  distinction.
- Academic ancestor: "Let's Verify Step by Step" (arXiv:2305.20050) —
  process-vs-outcome supervision, for reward modeling rather than auditing
  completion reports.

**The delta:** the nearest sources gesture at the idea; none name the
practice — *the measurement is fine, audit the inference, it costs one
grep* — as its own diagnostic move.
