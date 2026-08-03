#!/usr/bin/env bash
# Reproduction for "the hardlink hazard".
#
# Question: if two agent worktrees share node_modules via `cp -al`, can a test
# run in one tree change what happens in the other?
#
# Usage:  ./repro.sh          (first run installs deps into .deps/, ~3 min)
#
# Runs on Linux and macOS/BSD (the platform-specific bits are shimmed below).
# NOTE: the HAZARD is not platform-specific at all — hardlinks are POSIX, and
# the copy-time channel needs no hardlinks whatsoever. Only these helpers were.
# Everything must sit on one filesystem, or hardlinks are impossible.

set -u
ROOT="$(cd "$(dirname "$0")" && pwd)"
DEPS="$ROOT/.deps"
PASS=0; FAIL=0

say()  { printf '\n\033[1m== %s\033[0m\n' "$*"; }
ok()   { PASS=$((PASS+1)); printf '  \033[32mPASS\033[0m %s\n' "$*"; }
bad()  { FAIL=$((FAIL+1)); printf '  \033[31mFAIL\033[0m %s\n' "$*"; }
info() { printf '       %s\n' "$*"; }

# Portability shims. GNU and BSD/macOS spell these differently; cksum is POSIX
# and identical on both, which is plenty for "did this file change".
case "$(uname -s)" in
  Darwin|*BSD*)
    ino()   { stat -f '%i' "$1"; }
    nlink() { stat -f '%l' "$1"; }
    ;;
  *)
    ino()   { stat -c '%i' "$1"; }
    nlink() { stat -c '%h' "$1"; }
    ;;
esac
sum()     { cksum "$1" | awk '{print $1"-"$2}'; }
resolve() { (cd "$1" 2>/dev/null && pwd -P); }   # readlink -f is not portable
rescache() { find "$1/node_modules/.vite/vitest" -name results.json 2>/dev/null | head -1; }

# Run a tree's suite from a clean slate. Echoes "GREEN <order>" / "RED <order>".
# Order comes from the test files themselves, so it is reporter-independent.
run_tree() {
  local d="$1" out st
  rm -f "$d/order.log" "$d/fixture.json"
  out="$(cd "$d" && npx vitest run --no-file-parallelism 2>&1)"; st=$?
  local order; order="$(tr '\n' ' ' < "$d/order.log" 2>/dev/null)"
  [ $st -eq 0 ] && echo "GREEN ${order}" || echo "RED ${order}"
}

write_sources() {
  local d="$1"; mkdir -p "$d/src"
  cat > "$d/package.json" <<'EOF'
{ "name": "hl", "private": true, "type": "module",
  "devDependencies": { "vite": "8.2.0", "vitest": "4.1.10", "lodash-es": "4.18.1",
                       "typescript": "5.9.3", "eslint": "9.39.5" } }
EOF
  cat > "$d/index.html" <<'EOF'
<!doctype html><script type="module" src="/src/slow.js"></script>
EOF
  cat > "$d/src/slow.js" <<'EOF'
import { sum } from 'lodash-es'
export const spin = (ms) => { const t = Date.now(); while (Date.now() - t < ms); return sum([1,2,3]) }
EOF
  # An order-dependent pair: `seed` creates the fixture, `use` needs it.
  # Common shape in real suites (global setup, shared temp dir, seeded DB).
  # `seed` is slow and `use` is fast, so the duration-sorted order is seed->use
  # and the suite is green.
  cat > "$d/src/seed.test.js" <<'EOF'
import { appendFileSync, writeFileSync } from 'node:fs'
import { test, expect } from 'vitest'
import { spin } from './slow.js'
appendFileSync('order.log', 'seed\n')
test('seed writes the fixture', () => {
  expect(spin(240)).toBe(6)
  writeFileSync('fixture.json', JSON.stringify({ ready: true }))
})
EOF
  cat > "$d/src/use.test.js" <<'EOF'
import { appendFileSync, readFileSync } from 'node:fs'
import { test, expect } from 'vitest'
import { spin } from './slow.js'
appendFileSync('order.log', 'use\n')
test('use consumes the fixture', () => {
  expect(spin(5)).toBe(6)
  expect(JSON.parse(readFileSync('fixture.json', 'utf8')).ready).toBe(true)
})
EOF
}

# make the suite fail in one tree only (tree's own sources)
plant_failure() {
  cat > "$1/src/use.test.js" <<'EOF'
import { appendFileSync } from 'node:fs'
import { test, expect } from 'vitest'
appendFileSync('order.log', 'use\n')
test('use consumes the fixture', () => { expect(1).toBe(2) })
EOF
}

# ------------------------------------------------------------------- preflight
# Prove the shims work on THIS platform before trusting a single inode compare.
if [ -z "$(ino "$0")" ] || [ -z "$(nlink "$0")" ] || [ -z "$(sum "$0")" ]; then
  echo "could not read inode/link-count/checksum on $(uname -s) — unsupported platform."
  exit 1
fi

# Hardlinks cannot cross filesystems. If .deps is a symlink to another device
# (easy to do by accident), cp -al fails thousands of times and every result
# below is meaningless — so fail loudly here instead.
mkdir -p "$DEPS"
if ! ln "$0" "$DEPS/.hltest" 2>/dev/null; then
  echo "cannot hardlink from $ROOT into $DEPS — different filesystems?"
  echo "put the whole directory (including .deps) on one device and re-run."
  exit 1
fi
rm -f "$DEPS/.hltest"

# ---------------------------------------------------------------- install once
if [ ! -d "$DEPS/node_modules" ]; then
  say "one-time install into .deps (a few minutes)"
  mkdir -p "$DEPS"; write_sources "$DEPS"
  (cd "$DEPS" && npm install --no-audit --no-fund) || exit 1
  rm -rf "$DEPS/node_modules/.vite"
fi

# ------------------------------------------------------------------ E0 primitive
say "E0  what cp -al actually shares"
P="$ROOT/e0"; rm -rf "$P"; mkdir -p "$P/orig"
echo "v1" > "$P/orig/f"
cp -al "$P/orig" "$P/copy"
[ "$(ino "$P/orig/f")" = "$(ino "$P/copy/f")" ] \
  && ok "cp -al gives both trees one inode (nlink=$(nlink "$P/orig/f"))" \
  || bad "cp -al did not share storage — is this all one filesystem?"

printf 'v2\n' > "$P/orig/f"
[ "$(cat "$P/copy/f")" = "v2" ] \
  && ok "in-place write in tree 1 shows up in tree 2   <-- the hazard" \
  || bad "in-place write did not propagate"

printf 'v3\n' > "$P/orig/.tmp" && mv "$P/orig/.tmp" "$P/orig/f"
[ "$(cat "$P/copy/f")" = "v2" ] \
  && ok "write-then-rename leaves tree 2 alone (link broken, not followed)" \
  || bad "rename unexpectedly propagated"
info "so the hazard only fires for tools that overwrite a file in place."

# ------------------------------------------------------- base + three worktrees
say "E1  three worktrees, node_modules shared with cp -al"
rm -rf "$ROOT/base" "$ROOT/A" "$ROOT/B" "$ROOT/ctl"
mkdir -p "$ROOT/base"; write_sources "$ROOT/base"
cp -al "$DEPS/node_modules" "$ROOT/base/node_modules"
# Warm the caches in base first — i.e. you worked in the main tree before
# spinning up worktrees. That is what puts cache files into the copy set.
# Seed the two files in order so the baseline cache is all-green; on a cold
# cache vitest orders by file size, which is not what we are testing here.
(cd "$ROOT/base" && rm -f order.log fixture.json \
   && npx vitest run src/seed.test.js >/dev/null 2>&1 \
   && npx vitest run src/use.test.js  >/dev/null 2>&1)
(cd "$ROOT/base" && npx vite optimize --force >/dev/null 2>&1)
BASECACHE="$(rescache "$ROOT/base")"
grep -q '"failed":true' "$BASECACHE" 2>/dev/null \
  && { echo "baseline cache is already red — aborting"; exit 1; }

for t in A B ctl; do mkdir -p "$ROOT/$t"; write_sources "$ROOT/$t"; done
cp -al "$ROOT/base/node_modules" "$ROOT/A/node_modules"     # hardlinked
cp -al "$ROOT/base/node_modules" "$ROOT/B/node_modules"     # hardlinked
cp -r  "$ROOT/base/node_modules" "$ROOT/ctl/node_modules"   # control: real copy

RA="$(rescache "$ROOT/A")"; RB="$(rescache "$ROOT/B")"; RC="$(rescache "$ROOT/ctl")"
if [ -n "$RA" ] && [ -n "$RB" ] && [ "$(ino "$RA")" = "$(ino "$RB")" ]; then
  ok "A and B share one inode for .vite/vitest/*/results.json (nlink=$(nlink "$RB"))"
else
  bad "results.json is not shared between A and B"
fi
[ -n "$RC" ] && [ "$(ino "$RC")" != "$(ino "$RB")" ] \
  && ok "control (cp -r) got its own inode" || bad "control unexpectedly shared"
info "cache dir is $(basename "$(dirname "$RB")") — the same name in every worktree,"
info "and vitest keys it by path relative to the tree root, so keys collide too."

# ------------------------------------------- E2 A's run rewrites B's cache file
say "E2  does a run in A change B's cache file?"
BEFORE="$(sum "$RB")"; BINO="$(ino "$RB")"
(cd "$ROOT/A" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
if [ "$BEFORE" != "$(sum "$RB")" ]; then
  ok "B's results.json changed while nothing ran in B"
  [ "$BINO" = "$(ino "$RB")" ] && info "same inode $BINO — written through the link, not replaced"
else
  bad "B's results.json was untouched by A's run"
fi
CBEFORE="$(sum "$RC")"
(cd "$ROOT/A" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
[ "$CBEFORE" = "$(sum "$RC")" ] && ok "control's cache untouched by A's run" \
                                || bad "control's cache changed"

# ------------------------------------ E3 the payload: A's run turns B's suite red
say "E3  does that change B's RESULT?  (sequencer rule: 'run failed first')"
B1="$(run_tree "$ROOT/B")"
info "B on its own:                    $B1"
C1="$(run_tree "$ROOT/ctl")"

plant_failure "$ROOT/A"          # the defect exists ONLY in A's sources
(cd "$ROOT/A" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
info "A ran red — a defect planted in A's sources only"

# Assert the mechanism, not just the outcome: A's run must actually have
# written failed:true into the shared file, or a later RED proves nothing.
if grep -q '"failed":true' "$RB" 2>/dev/null; then
  ok "the shared cache now carries A's failed flag (read via B's own path)"
else
  bad "A's run did not poison the shared cache — the rest of E3 is meaningless"
fi

B2="$(run_tree "$ROOT/B")"       # B's sources never changed
info "B again, sources untouched:      $B2"
# Strict gate. A mere reorder that stays green is NOT the claim, and must not
# be allowed to pass as if it were.
if [ "${B1%% *}" = "GREEN" ] && [ "${B2%% *}" = "RED" ]; then
  ok "B's suite went RED because of a run in a different worktree"
  info "A's 'failed' flag reordered B: use.test.js ran before seed.test.js,"
  info "so the fixture did not exist yet. B's code and tests are fine."
else
  bad "expected B GREEN then RED, got '$B1' then '$B2'"
fi

# And prove the ORDER is what did it: with the poisoned cache still in place,
# force the correct order and B must pass. Rules out "B's sources are broken".
(cd "$ROOT/B" && rm -f order.log fixture.json \
   && npx vitest run src/seed.test.js >/dev/null 2>&1 \
   && npx vitest run src/use.test.js  >/dev/null 2>&1) \
  && ok "same poisoned cache, forced seed-then-use: B passes — order was the cause" \
  || bad "B fails even in the right order — something other than order is wrong"

C2="$(run_tree "$ROOT/ctl")"
if [ "${C1%% *}" = "GREEN" ] && [ "$C1" = "$C2" ]; then
  ok "control stayed GREEN through the same provocation ($C1)"
else
  bad "control is not a clean baseline: $C1 -> $C2"
fi

# ------------------------------------------------ E4 a half-finished write
say "E4  what a torn concurrent write does"
: > "$RB"                        # writeFile truncates first; this is that window
OUT="$(cd "$ROOT/B" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism 2>&1)"
if printf '%s' "$OUT" | grep -q "Test Files"; then
  ok "a zero-length results.json does NOT crash vitest — it is swallowed"
  info "vitest wraps readFromCache() in try{}catch{}, so the shared cache just"
  info "silently resets. Damage is lost state, not a stack trace."
else
  bad "vitest crashed on the truncated cache"
fi
(cd "$ROOT/B" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
info "(a 6-round concurrent-write race lived here and never once fired; the"
info "deterministic check above is the part that actually demonstrates anything.)"

# --------------------------------------- E5 the part of the claim that is wrong
say "E5  counter-example: vite's dep prebundle"
DA="$ROOT/A/node_modules/.vite/deps/lodash-es.js"
DB="$ROOT/B/node_modules/.vite/deps/lodash-es.js"
if [ -f "$DA" ] && [ "$(ino "$DA")" = "$(ino "$DB")" ]; then
  info "deps/lodash-es.js starts out shared (inode $(ino "$DA"))"
  BSUM="$(sum "$DB")"
  (cd "$ROOT/A" && npx vite optimize --force >/dev/null 2>&1)
  if [ "$BSUM" = "$(sum "$DB")" ] && [ "$(ino "$DA")" != "$(ino "$DB")" ]; then
    ok "re-optimising in A did NOT touch B — vite swaps the dir via rename"
    info "node_modules/.vite/deps is therefore not a channel between trees"
  else
    bad "vite's dep cache propagated across the link"
  fi
else
  info "dep cache absent or already unshared; skipping"
fi

# ------------------------------------------------ E6 the precondition everyone misses
say "E6  precondition: was the cache there when you copied?"
rm -rf "$ROOT/cold1" "$ROOT/cold2"
for t in cold1 cold2; do mkdir -p "$ROOT/$t"; write_sources "$ROOT/$t"; done
# .deps has never had a test run in it, so it holds no .vite directory at all
cp -al "$DEPS/node_modules" "$ROOT/cold1/node_modules"
cp -al "$DEPS/node_modules" "$ROOT/cold2/node_modules"
(cd "$ROOT/cold1" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
(cd "$ROOT/cold2" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
K1="$(rescache "$ROOT/cold1")"; K2="$(rescache "$ROOT/cold2")"
if [ -n "$K1" ] && [ -n "$K2" ] && [ "$(ino "$K1")" != "$(ino "$K2")" ]; then
  ok "copied COLD (never-run node_modules): each tree made its own cache, no sharing"
  info "cp -al only links files that exist at copy time. .vite is created later,"
  info "so a fresh npm ci + immediate cp -al is not exposed — until someone"
  info "runs the suite in the main tree first. That is why this is intermittent."
else
  bad "cold copy unexpectedly shared the cache"
fi

# --------------------------------- E7 the other channel: symlinked local deps
say "E7  symlinked local deps — a second, worse channel"
Y="$ROOT/sym"; rm -rf "$Y"
mkdir -p "$Y/extlib" "$Y/app/node_modules" "$Y/app/packages/wslib"
echo "module.exports = 'v1'" > "$Y/extlib/index.js"
echo "module.exports = 'v1'" > "$Y/app/packages/wslib/index.js"
echo '{"name":"app","private":true}' > "$Y/app/package.json"
ln -s "$Y/extlib"         "$Y/app/node_modules/ext-abs"   # npm link  -> absolute, outside
ln -s "../../extlib"      "$Y/app/node_modules/ext-rel"   # file:../  -> relative, outside
ln -s "../packages/wslib" "$Y/app/node_modules/ws"        # workspace -> relative, inside
cp -al "$Y/app" "$Y/appA"      # hardlink copy
cp -r  "$Y/app" "$Y/appR"      # the "safe" copy

KEPT=1
for t in appA appR; do for l in ext-abs ext-rel ws; do
  [ -L "$Y/$t/node_modules/$l" ] || KEPT=0
done; done
[ "$KEPT" = 1 ] \
  && ok "cp -al AND cp -r both keep symlinks as symlinks (neither dereferences)" \
  || bad "a copy dereferenced a symlink"

echo "module.exports = 'v2-CHANGED'" > "$Y/extlib/index.js"
SEEN=0
for t in appA appR; do
  grep -q CHANGED "$Y/$t/node_modules/ext-abs/index.js" && SEEN=$((SEEN+1))
  grep -q CHANGED "$Y/$t/node_modules/ext-rel/index.js" && SEEN=$((SEEN+1))
done
[ "$SEEN" = 4 ] \
  && ok "a dep symlinked OUTSIDE the tree is shared by every copy — cp -r included" \
  || bad "expected all 4 external-link copies to see the change, saw $SEEN"

[ "$(resolve "$Y/appA/node_modules/ws")" != "$(resolve "$Y/appR/node_modules/ws")" ] \
  && ok "a workspace dep symlinked INSIDE the tree resolves per-tree — isolated" \
  || bad "workspace link did not resolve per-tree"
info "so cp -r is only safe if nothing symlinks out of the worktree. And unlike"
info "hardlinks this is live: new files are shared too, and write-then-rename"
info "does not help, because the rename happens inside the shared target."

# ------------------------------------------ E8 mitigation: get caches out of node_modules
say "E8  mitigation: move the cache out of node_modules"
mkcfg() { printf "export default { cacheDir: './.vitecache' }\n" > "$1/vite.config.js"; }
rm -rf "$ROOT/fbase" "$ROOT/fA" "$ROOT/fB"
mkdir -p "$ROOT/fbase"; write_sources "$ROOT/fbase"; mkcfg "$ROOT/fbase"
cp -al "$DEPS/node_modules" "$ROOT/fbase/node_modules"
(cd "$ROOT/fbase" && rm -f order.log fixture.json \
   && npx vitest run src/seed.test.js >/dev/null 2>&1 \
   && npx vitest run src/use.test.js  >/dev/null 2>&1)
if [ -z "$(rescache "$ROOT/fbase")" ] && [ -f "$ROOT/fbase/.vitecache/vitest/"*/results.json ]; then
  ok "with cacheDir set, nothing lands in node_modules"
else
  bad "cache still inside node_modules"
fi
for t in fA fB; do
  mkdir -p "$ROOT/$t"; write_sources "$ROOT/$t"; mkcfg "$ROOT/$t"
  cp -al "$ROOT/fbase/node_modules" "$ROOT/$t/node_modules"
  cp -r  "$ROOT/fbase/.vitecache"   "$ROOT/$t/.vitecache"
done
F1="$(run_tree "$ROOT/fB")"
plant_failure "$ROOT/fA"
(cd "$ROOT/fA" && rm -f order.log fixture.json && npx vitest run --no-file-parallelism >/dev/null 2>&1)
F2="$(run_tree "$ROOT/fB")"
info "B before: $F1"
info "B after:  $F2"
if [ "${F1%% *}" = "GREEN" ] && [ "${F2%% *}" = "GREEN" ]; then
  ok "same provocation as E3, but B stays GREEN — one config line fixes it"
  info "covers only the caches you know about; does nothing for E7 or for a"
  info "tool that writes into the packages themselves."
else
  bad "B still moved with the cache outside node_modules: $F1 -> $F2"
fi

# ------------------------- E9 the OTHER channel: stale cache rides any copy
say "E9  copy-time contamination — not a hardlink problem at all"
write_ts() {
  local d="$1"; mkdir -p "$d/src"
  cat > "$d/tsconfig.json" <<'EOF'
{ "compilerOptions": { "incremental": true, "tsBuildInfoFile": "node_modules/.cache/tsbuildinfo",
    "outDir": "dist", "strict": true, "skipLibCheck": true }, "include": ["src"] }
EOF
  echo 'export const x: number = 1' > "$d/src/a.ts"
}
rm -rf "$ROOT/tbase" "$ROOT/tA" "$ROOT/tC"
write_ts "$ROOT/tbase"; cp -al "$DEPS/node_modules" "$ROOT/tbase/node_modules"
(cd "$ROOT/tbase" && npx tsc -p tsconfig.json >/dev/null 2>&1)
[ -f "$ROOT/tbase/dist/a.js" ] \
  && ok "base tree compiled normally: dist/a.js exists" \
  || bad "base tree did not emit — setup problem, later results are meaningless"

write_ts "$ROOT/tA"; cp -al "$ROOT/tbase/node_modules" "$ROOT/tA/node_modules"   # hardlink
write_ts "$ROOT/tC"; cp -r  "$ROOT/tbase/node_modules" "$ROOT/tC/node_modules"   # real copy
(cd "$ROOT/tA" && npx tsc -p tsconfig.json >/dev/null 2>&1); AS=$?
(cd "$ROOT/tC" && npx tsc -p tsconfig.json >/dev/null 2>&1); CS=$?
if [ ! -f "$ROOT/tA/dist/a.js" ] && [ "$AS" = 0 ]; then
  ok "hardlinked tree: tsc exited 0 and emitted NOTHING (dist/ empty)"
else bad "hardlinked tree emitted normally"; fi
if [ ! -f "$ROOT/tC/dist/a.js" ] && [ "$CS" = 0 ]; then
  ok "cp -r tree: SAME silent empty build — so cp -r does not save you here"
  info "tsc inherited a buildinfo saying the outputs already exist, believed it,"
  info "and exited 0. A build that reports success and produces nothing."
else bad "cp -r tree emitted normally — copy-time channel not reproduced"; fi
rm -f "$ROOT/tC/node_modules/.cache/tsbuildinfo"
(cd "$ROOT/tC" && npx tsc -p tsconfig.json >/dev/null 2>&1)
[ -f "$ROOT/tC/dist/a.js" ] \
  && ok "delete the inherited buildinfo and it compiles — that file was the cause" \
  || bad "still no output after removing the buildinfo"
# Same check on the hardlinked tree. If only tC recovered, the two trees would
# differ for some reason other than the buildinfo, and the attribution is unsafe.
rm -f "$ROOT/tA/node_modules/.cache/tsbuildinfo"
(cd "$ROOT/tA" && npx tsc -p tsconfig.json >/dev/null 2>&1)
[ -f "$ROOT/tA/dist/a.js" ] \
  && ok "the hardlinked tree recovers the same way — no confound between them" \
  || bad "hardlinked tree stayed broken after removing the buildinfo — confound"
info "two different channels: this one rides ANY copy of node_modules (cp -r,"
info "tar, rsync). E1-E3 was the live one, which needs hardlinks."

# ------------------------------- E10 why eslint does NOT produce a wrong answer
say "E10 the discriminator: absolute keys vs relative keys"
rm -rf "$ROOT/el"; mkdir -p "$ROOT/el/src"
cp -al "$DEPS/node_modules" "$ROOT/el/node_modules"
printf 'export default [{ files: ["**/*.js"], rules: { "no-unused-vars": "error" } }]\n' \
  > "$ROOT/el/eslint.config.js"
echo 'export const y = 1' > "$ROOT/el/src/a.js"
EC="$ROOT/el/node_modules/.cache/.eslintcache"
(cd "$ROOT/el" && npx eslint src --cache --cache-location "$EC" >/dev/null 2>&1)
if [ -f "$EC" ]; then
  rm -f "$ROOT/el/probe"; ln "$EC" "$ROOT/el/probe"
  BI="$(ino "$EC")"
  echo 'export const y = 2' > "$ROOT/el/src/a.js"
  (cd "$ROOT/el" && npx eslint src --cache --cache-location "$EC" >/dev/null 2>&1)
  [ "$BI" = "$(ino "$EC")" ] \
    && ok "eslint also writes its cache in place — it propagates too" \
    || bad "eslint replaced the file"
  if grep -q "$ROOT/el/src/a.js" "$EC"; then
    ok "but its keys are ABSOLUTE paths, so they cannot collide across trees"
    info "shared file, disjoint entries: you get lost updates, not wrong answers."
    info "vitest's keys are relative — that one difference is what makes E3 bite."
  else
    bad "expected absolute paths in the eslint cache"
  fi
else
  info "eslint cache not produced; skipping"
fi

say "result: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
