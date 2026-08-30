# The test that assumes it owns the table

*Written 2026-08-26.*

*Status: searched 2026-08-26. The incidents are measured; the "model default" reading is an
unverified hypothesis, and the claim below says which half is which.
Incidents from a two-day multi-agent build (Aug 2026), diagnosed by fix
agents whose reports are quoted below.*

**Claim:** every test the model wrote against a shared resource was
single-tenant code. Not wrong locks — no locks, no partition, no
declared ownership: several packages, the same silent assumption, three
different unseen co-tenants. Whether that is the model's default or
this project's draw, three incidents in one suite cannot establish —
that half stays hypothesis until someone measures it. What the
incidents do establish is structural, and it holds at any rate. No
gate can check an ownership requirement nobody declared, and the suite
runs in parallel, so the assumption eventually meets a crowd. Until
then the suite still passes — it just happens to pass because nothing
else was running. The failure surfaces later as flakiness that tracks machine
load, which is about the hardest kind of failure to trace back.

## Three tenants it didn't see

All from one project of mine: parallel lanes built a Kafka + Postgres
pipeline, each lane writing its own integration tests, my suite green at
ship. Three
failures surfaced afterward — diagnosed by fix agents whose reports I
quote below — and each had a different unseen co-tenant.

**The sibling tests.** A redrive test parked one record on the DLQ topic
and terminated by draining the topic to idle. But the topic is shared:
"under `go test ./...` every package's DLQ test parks to it at once, so
the pass keeps reading their records and never goes idle until the *whole
suite* quiets. Its duration is set by the suite's parking, not by its one
record." It passed at ~30s on one machine and failed at 42.6s on another —
"pure timing fragility." The diagnosing agent refuted its first hypothesis
by reproduction (a fresh broker passed in 13.26s), then made the failure
deterministic by flooding the topic: timeout at exactly 40.01s. Fix: cap
the pass at the one record the test owns (`max_events=1`).

**The standing services.** An ingest test counted its replayed rows with a
blanket `count(*) from batch_lines` — in the diagnosing agent's words,
"assuming the test owns the table." The test's DSN pointed at the same
database a live ingest service writes to, and the integration target never
stops services. Reproduced with a concurrent writer:
`lines after replay = 4502, want 2`. Fix: count `where batch_id = $1` —
assert only over rows the test itself minted.

**Its own previous runs.** The same suite, run over run, committed no
offsets and wiped nothing: every run re-read the entire topic from the
start and leaked one more consumer group onto the broker. Accumulated: 49
groups, 19 topics, package time creeping 30.7s → 39.2s until a 40s budget
burst. The co-tenant is yesterday's you.

No outside adversary appears in any of the three: the co-tenants were
the suite's own sibling tests, the project's own standing services,
and the suite's own previous runs. Everything that broke these tests
was the project itself.

## Why it gets written

The tenancy question sits on an axis the model isn't searching — the
same place the decisive hypothesis usually hides in a debugging session
([the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)):
the model reasons about the code under test, not about the
environment's other occupants.

I first blamed the fan-out — parallel lanes, each writing from a
context in which "I am alone" is true. That reading does not survive
its own prior art. The tests collide because they *run* in parallel,
not because they were *written* in parallel: a single session writing
the same suite serially could have read the earlier tests and, on the
evidence, would not have been saved by it — Luo's taxonomy below was
built from human teams writing serially, and it is full of exactly
these classes. Fan-out changes the tempo, not the mechanism: it mints
a whole suite's worth of the assumption before the first collision can
teach anyone anything, where a human suite accretes its flakiness
slowly enough to bite along the way.

Honesty about the rate: the same transcripts show the opposite discipline
wherever a rule existed — worktree isolation held cleanly, and the fix
agents scoped correctly the moment the tenancy was visible. So the
candidate hypothesis is "doesn't volunteer the tenancy question," not
"can't answer it" — and it is testable: hand fresh contexts a test-writing
task beside a visibly shared resource, N trials, and grep the output for
the tell below. Until someone runs that, the default stays a hypothesis
and this page claims only the structure.

This is not
[the session has no concurrency model](the-session-has-no-concurrency-model.md) —
that note is agents stepping on each other *during* the session. This
one is about the code the model writes, whoever runs it and however
many sessions wrote it: artifacts that assume an owner nobody
declared, colliding at run time, forever, on machines the session
never saw. The suite was green throughout —
[all green, still broken](all-green-still-broken.md) — because a pass
asserts nothing about who else was writing; the green was silently
conditioned on the world being quiet.

## The tell, and the rules

The tell is **universal quantification over state the test didn't mint**.
A blanket `count(*)`. Drain-until-idle. Assert-table-empty. A fixture
name every package shares. Each quantifies over the world, and so asserts
an ownership claim about the world — one nobody wrote down.

- **A test may only assert over what it minted.** Its own batch id, its
  own key range, its own dedicated topic. If the predicate has no key the
  test created, the test is claiming the world.
- **"Until quiet" is never a termination condition on a shared channel.**
  Terminate on your own records, counted, capped.
- **If a test genuinely needs exclusivity, that need is a gate to
  build, not a comment to write.** A declared claim helps only once a
  checker parses the declarations and flags collisions at integrate
  time. Until that checker exists, stick to the mint rule above — a
  register nothing reads is one more requirement nothing checks.
- **Cross-machine flakiness means undeclared tenancy until proven
  otherwise.** A test whose verdict tracks machine load is measuring the
  crowd, not the code.

## Prior art

**Verdict: PARTIAL — searched 2026-08-26.** The baseline is textbook,
and sharper than this page first assumed: two of the three incidents
fall into categories that Luo et al. had already named in "An
Empirical Analysis of Flaky Tests" (FSE 2014,
DOI:10.1145/2635868.2635920) — the blanket `count(*)` is an instance
of their "dependency on external resources" (the top cause inside
their Test Order Dependency category, with the same prescribed fix),
and the leaked consumer groups are an instance of their Resource Leak
category. Twelve years of warning existed before these tests were
written. The
sibling-test incident fits less cleanly: their taxonomy comes from
single-process suites, and cross-binary contention on one always-on
broker topic under `go test ./...` has no named category there — a
narrow gap, and honestly narrow. *Software Engineering at Google*'s
hermeticity chapter is the closest KNOWN answer to "declare your
dependencies," though its remedy is architectural — don't share the
resource — not a checkable claim over a deliberately shared one. On
the model side, Berndt et al. (ICSE-SEIP '26, arXiv:2601.08998)
establish that LLM-generated database tests are measurably flakier
than human-written ones — single-agent generation, no fan-out. Not
found in this sweep: ownership as a declared, gate-checkable artifact.
An earlier draft also claimed a fan-out-specific mechanism — the
orchestration as both author of the assumptions and the crowd that
violates them — and withdrew it during the owner's walk-through: Luo's
serially-written human suites contain the same classes, so parallel
authorship is tempo, not mechanism. Adjacent here:
[the leak is in the cleanup](the-leak-is-in-the-cleanup.md) (the
never-wiped broker is a cleanup nobody owned).
