# The test that assumes it owns the table

*Status: DRAFT — not yet walked through for publication; prior-art sweep not
yet run. The incidents are measured; the "model default" reading is an
unverified hypothesis, and the claim below says which half is which.
Incidents from a two-day multi-agent build (Aug 2026), diagnosed by fix
agents whose reports are quoted below.*

**Claim:** in one fan-out, every lane that wrote tests against a shared
resource wrote single-tenant code. Not wrong locks — no locks, no
partition, no declared ownership: several packages, different lanes, the
same silent assumption, three different unseen co-tenants. Whether that is
the model's default or this project's draw, three incidents in one suite
cannot establish — that half stays hypothesis until someone measures it.
What the incidents do establish is structural, and it holds at any
rate. No gate can check an ownership requirement nobody declared, and a
lane cannot see its sibling lanes. So when the assumption is wrong, the
suite still passes — it just happens to pass because nothing else was
running. The failure surfaces later as flakiness that tracks machine
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
sibling tests, the project's own standing services, and the suite's own
previous runs — the first and last manufactured by the fan-out itself,
the middle one by the environment the project stands up and never
stops.

## Why a lane writes this

Each lane forks from the same snapshot and writes from a context in which
"I am alone" is true. A human team accretes tests serially — each new
author sees the existing suite; a fan-out's authors meet their siblings
only at run time. And the tenancy question sits on an axis the model isn't searching —
the same place the decisive hypothesis usually hides in a debugging
session ([the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)):
the model reasons about the code under test, not about the
environment's other occupants.

Honesty about the rate: the same transcripts show the opposite discipline
wherever a rule existed — worktree isolation held cleanly, and the fix
agents scoped correctly the moment the tenancy was visible. So the
candidate hypothesis is "doesn't volunteer the tenancy question," not
"can't answer it" — and it is testable: hand fresh contexts a test-writing
task beside a visibly shared resource, N trials, and grep the output for
the tell below. Until someone runs that, the default stays a hypothesis
and this page claims only the structure.

This is the sibling of
[the session has no concurrency model](the-session-has-no-concurrency-model.md),
not an instance of it. That note is the agents stepping on each other
*during* the session — edits under readers, writers clobbering. This one
is what they leave behind: the missing concurrency model compiled into the
artifacts, colliding at run time, forever, on machines the session never
saw. The suite was green throughout —
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

**Verdict: NOT YET SEARCHED.** Test pollution, hermetic tests, and
shared-fixture discipline are decades-old lore; the three incidents map
onto textbook flaky-test categories (async wait, order dependency,
resource leak) that published taxonomies already name, and the
individual fixes (scoped predicates, dedicated topics, per-test
databases) are standard.
What has not been checked: single-tenant-by-default as a *model* writing
behavior; the undeclared-ownership framing (the requirement no gate can
check because it was never stated); and the fan-out multiplier — one
orchestration acting as both the author of every exclusivity assumption
and the crowd that violates them. Until the sweep runs, assume the fixes
are known and only the mechanism framing is candidate. Adjacent here:
[the leak is in the cleanup](the-leak-is-in-the-cleanup.md) (the
never-wiped broker is a cleanup nobody owned).
