# The crash lands on the innocent process

*Status: searched 2026-08-26. The incident is measured; the
generalization is mechanism.*

**Claim:** `/dev/shm`, `/tmp`, the Docker store and the package caches are
machine-wide, fixed-size, and unowned. Nothing attributes them to a consumer,
no error message names them, and the process that dies is rarely the process
that filled them. Agents make this sharply worse — they multiply the number of
processes drawing on the same pool, and their recovery behaviour draws harder.
Every fix is a quota or a sweep you impose yourself; nothing volunteers one.

## The incident

An Electron app of mine started white-screening. Refresh brought it back for a few
seconds, then white again, then a crash. The log said:

```
Main webview render process gone: { reason: 'crashed', exitCode: 4 }
TypeError: Failed to fetch dynamically imported module: .../assets/v1/cd2515372-CzpK5M2O.js
[spa] chunk preload failed; running diagnostics, then reloading
```

That reads as a network fault. It wasn't — `curl` to the same asset host
returned `HTTP 200` in 1.3s throughout. Chromium backs network response
bodies with shared memory, so when `/dev/shm` is full a fetch fails *as if*
the network were down. The app's own chunk-failure handler then reloads,
which is the white screen coming back after every refresh.

`/dev/shm` was capped at 1 GB in `/etc/fstab`. Sitting in it: **42 segments of
10.5 MB — 416 MB — held by a completely different application's browser
subprocess** (a JetBrains IDE's out-of-process CEF, segments named `R<pid>_N`).
They arrived in pairs, which is double-buffered off-screen rendering: one
browser view leaked, 21 times over. Chromium wanted ~700 MB on top. 416 + 700
crosses 1024, and the app that died was the one that asked last.

The timeline closes it: 20 of those 42 segments were allocated between 20:50
and 21:34; the first crash was 21:19 and the storm 21:36–21:43. I raised the
cap and the crashing stopped instantly. The IDE never noticed anything was wrong.

**The tell is `du` versus `df`.** `df` reported 1.1 GB used where `du` could
see only 416 MB of files. Chromium creates a segment, maps it, and unlinks it
— still allocated, no longer a directory entry. If those two numbers disagree,
something is holding memory you cannot `ls`.

## Four more of the same shape

Measured on my machine, the same day:

- **`/tmp` is RAM.** It is a 3 GB `tmpfs` here, already 54% full. 598 MB of
  that is agent scratchpads — 36 session directories, one per session, none
  cleaned up. Another 827 MB is six leftover `mktemp -d` trees from *this
  repo's own demo page*, which cheerfully says "paste as often as you like."
  Each paste of that demo installs `vitest` and leaves ~137 MB in memory.
  A tmpfs `/tmp` and a disk `/tmp` are the same command and different failure
  modes, and nothing in the command tells you which one you have.
- **The Docker store has no quota by default.** 62 images at 83.8 GB, 13
  volumes at 9.1 GB, and a build cache of **513 entries at 110.7 GB** — 62 GB
  of it reclaimable, on a filesystem that is 79% full. Nothing here was
  decided; it accreted. An agent that rebuilds to check its work adds a layer
  set per attempt, and `docker build` never says what it cost.
- **Package caches are unbounded too.** 3.4 GB of npm `_cacache`. This is the
  benign one — it is at least *reuse* — but it is on the same volume as the
  Docker store, and the two failures arrive together.
- **CPU cores are a pool too.** In another project of mine, the same week —
  numbers from its fix agents' reports, not re-run by me — the compose stack
  shipped with no CPU limits until I caught the test runner using five cores
  at once and demanded caps; and a diagnosis agent traced a Kafka container's
  spikes to its own healthcheck: a JVM cold-started every four seconds, with
  97% of all the CPU the container used sitting inside those probe windows.
  The probe starved the workload it was guarding, and nothing volunteered a
  limit.

## Why agents make it worse

Three multipliers, none of which the model reasons about:

1. **Fan-out multiplies consumers.** Every lane is a process with a scratch
   directory, and the session sizes fan-out by task shape, not by what the
   machine can hold ([the session has no concurrency model](the-session-has-no-concurrency-model.md)).
2. **Retry multiplies work.** "Try again" re-runs the install, re-pulls the
   image, re-builds the layer. The loop that feels like progress is the loop
   filling the disk.
3. **Recovery draws hardest at the worst moment.** During the crash loop above,
   the app's child-process count went 6 → 16 → 27 → 36 in six minutes as each
   reload respawned its tooling before the old set was reaped. The response to
   resource exhaustion was to consume more.

And the diagnosis is mis-aimed by construction. Ask an agent why an app is
white-screening and it investigates *that app* — its logs, its config, its
network. The evidence is in another process's shared memory, and nothing in
the failing app's own telemetry can point there. This is the orthogonality
problem in a new place ([the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)):
the axis is not "which app is broken," it is "which resource is gone."

## The rules

- **Check the shared pools before the app.** `df -h /dev/shm /tmp /`, then
  `docker system df`. Three commands, ahead of any log reading.
- **When `du` and `df` disagree, believe `df`** and go looking for a process
  holding unlinked segments — `grep -l <name> /proc/*/maps` names the owner.
- **Size `/dev/shm` for every browser on the box, not one.** A 1 GB cap is a
  single-Chromium budget. Persist it in `/etc/fstab`; a live `mount -o
  remount` is gone on reboot, and the crash comes back looking new.
- **Give agents a scratch directory you can measure and delete** — one path,
  per session, swept on a schedule. Never the shared `/tmp` by default.
- **Put a quota on the Docker build cache** rather than trusting a cleanup
  step, and prune on a timer. `--filter until=` beats remembering.
- **Demos that allocate must say what they cost and how to reclaim it.** A
  paste-able reproduction is a resource commitment; ours did not say so
  until this note forced the fix — the demo pages now carry their cost
  and cleanup.

The pattern underneath: cleanup is exactly where the model's diligence runs
out ([the leak is in the cleanup](the-leak-is-in-the-cleanup.md)), and a
resource nobody is billed for is a resource nobody frees.

## Prior art

**Verdict: PARTIAL — searched 2026-08-26.** The base facts stay KNOWN as
assumed: the Docker `--shm-size` Chromium-in-CI lore, tmpfs `/tmp`
exhaustion, `docker system prune` guidance. The victim-not-culprit
framing exists, but scattered: Autoheal's 2026 OOM debugging guide says
it nearly verbatim for memory — the killed process "was a victim, not
the cause" — Kubernetes disk-pressure guides send you to node-level
inspection because the evicted pod's own signals can't explain it, and
Amazon's AgentCore observability post (2026) carries the agent half for
tool errors ("the problem may not be in your agent"). Nobody located
treats `/dev/shm`, `/tmp`, the Docker store, and the package caches as
one family of unowned pools whose exhaustion cannot be diagnosed from
the dying process's own telemetry — that framing survives. The
agent-load claim, meanwhile, is now publicly documented, not just
measured here: a Codex CLI fan-out wrote 731.5 GiB of session logs
across 2,393 child sessions (openai/codex#34061); 121 unswept session
directories filled a sandbox disk until `useradd` itself failed
(anthropics/claude-code#59856); a crash-recovery respawn storm grew 864
processes to 73,217 in about an hour (anthropics/claude-code#23484);
and `storage_ballast_helper` is a practitioner tool built explicitly
against agent swarms filling disks faster than operators react. Still
not found: Docker build-cache growth from agent retry loops, named as
its own pattern.
