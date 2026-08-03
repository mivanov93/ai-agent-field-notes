#!/usr/bin/env bash
# Is YOUR stack exposed to the hardlink hazard?
#
#   ./detect.sh /path/to/your/project "npm test"
#
# Takes a project that already has node_modules, makes two hardlinked worktrees
# of just the dependency tree, runs your command in one, and reports every
# shared file the run wrote through to the other.
#
# Your project is never hardlinked to anything this script writes to. It is
# first copied ONCE, for real, into a staging directory; the two worktrees are
# hardlinked off the staging copy. That real copy is slow and needs the disk,
# and it is not optional: hardlinking your actual node_modules into a tree we
# then run a build in would corrupt your project with the very bug this script
# looks for. A self-check at the end verifies your tree was left alone.
#
# Any file listed at the end is a channel between worktrees. An empty list
# means that command, on this project, at this moment, is not a channel.

set -u

# Uses only POSIX tools (cksum, find -print0, xargs -0) so it runs on Linux and
# macOS/BSD alike. A degraded run must never be able to report "untouched"
# without having measured anything, so the primitives are proven up front.
for t in cksum xargs find; do
  command -v "$t" >/dev/null 2>&1 || { echo "missing $t — cannot run."; exit 1; }
done
printf '' | xargs -0 true 2>/dev/null || { echo "xargs lacks -0 on $(uname -s) — cannot run safely."; exit 1; }

SRC="${1:-}"; CMD="${2:-npm test}"
[ -d "${SRC:-/nonexistent}/node_modules" ] || {
  echo "usage: $0 /path/to/project \"command to run\""
  echo "       (the project must already have node_modules installed)"; exit 1; }
SRC="$(cd "$SRC" && pwd)"

WORK="${TMPDIR:-/tmp}/hl-detect.$$"
mkdir -p "$WORK" || exit 1
trap 'rm -rf "$WORK"' EXIT

# Hardlinks cannot cross filesystems; the scratch dir must share one with SRC.
if ! ln "$(find "$SRC/node_modules" -type f 2>/dev/null | head -1)" "$WORK/.hltest" 2>/dev/null; then
  echo "cannot hardlink from $SRC into $WORK — different filesystems."
  echo "re-run with TMPDIR set to something on the same device as the project."
  exit 1
fi
rm -f "$WORK/.hltest"

echo "project : $SRC"
echo "command : $CMD"

# Fingerprint the caller's tree so we can PROVE we did not touch it.
# NUL-delimited + xargs: an unbounded `md5sum $(cat list)` blows past ARG_MAX on
# a real node_modules, md5sum never runs, and the check then "passes" having
# measured nothing. This must fail closed, not fail silent.
find "$SRC/node_modules" -type f -print0 > "$WORK/src-files.z" 2>/dev/null || true
SRC_N=$(tr -dc '\0' < "$WORK/src-files.z" | wc -c | tr -d ' ')
[ "$SRC_N" -gt 0 ] || { echo "could not enumerate $SRC/node_modules — refusing to run."; exit 1; }

# cksum is POSIX and identical on GNU/BSD. Path last so spaces survive.
fingerprint() {   # $1 = output path
  xargs -0 cksum < "$WORK/src-files.z" 2>/dev/null \
    | awk '{c=$1"-"$2; $1=""; $2=""; sub(/^[ \t]+/,""); print $0"\t"c}' \
    | sort > "$1"
  local got; got=$(wc -l < "$1" | tr -d ' ')
  if [ "$got" -ne "$SRC_N" ]; then
    echo "CANNOT VERIFY your tree: fingerprinted $got of $SRC_N files."
    echo "Refusing to certify that your node_modules was untouched."
    exit 1
  fi
}
fingerprint "$WORK/src-before.txt"

echo "staging a real copy of node_modules (slow, but keeps your tree safe)..."
mkdir -p "$WORK/stage"
cp -r "$SRC/node_modules" "$WORK/stage/node_modules" || {
  echo "staging copy failed — out of disk?"; exit 1; }

echo "building two worktrees with hardlinked node_modules..."
for t in A B; do
  mkdir -p "$WORK/$t"
  # source files: real copies, so only node_modules is shared
  tar -C "$SRC" --exclude=node_modules --exclude=.git -cf - . 2>/dev/null \
    | tar -C "$WORK/$t" -xf - 2>/dev/null
  # hardlink off the STAGING copy, never off the caller's tree
  cp -al "$WORK/stage/node_modules" "$WORK/$t/node_modules" 2>/dev/null
done

# Fingerprint every file B shares with A (same inode = same storage).
echo "fingerprinting shared files..."
find "$WORK/B/node_modules" -type f -links +1 -print0 2>/dev/null > "$WORK/shared.z"
SHARED=$(tr -dc '\0' < "$WORK/shared.z" | wc -c | tr -d ' ')
# path first, then hash, so both snapshots sort identically for comm
xargs -0 cksum < "$WORK/shared.z" 2>/dev/null \
  | awk -v pre="$WORK/B/" '{c=$1"-"$2; $1=""; $2=""; sub(/^[ \t]+/,""); sub("^"pre,""); print $0"\t"c}' \
  | sort > "$WORK/before.txt"
echo "  $SHARED files in B share storage with A"

echo "running the command in A..."
(cd "$WORK/A" && eval "$CMD") >"$WORK/cmd.log" 2>&1
echo "  exit $? (output in $WORK/cmd.log, deleted on exit)"

xargs -0 cksum < "$WORK/shared.z" 2>/dev/null \
  | awk -v pre="$WORK/B/" '{c=$1"-"$2; $1=""; $2=""; sub(/^[ \t]+/,""); sub("^"pre,""); print $0"\t"c}' \
  | sort > "$WORK/after.txt"

echo
echo "=============================================================="
CHANGED="$(comm -13 "$WORK/before.txt" "$WORK/after.txt" | cut -f1)"
if [ -z "$CHANGED" ]; then
  echo "CLEAN — the run in A changed no file that B shares."
  echo
  echo "Caveats: this is one command, one moment. A cache that did not exist"
  echo "when you copied cannot be shared yet (that is the usual precondition),"
  echo "so re-run after the project has been built and tested at least once."
else
  echo "EXPOSED — the run in A wrote through to B via these shared files:"
  echo "$CHANGED" | sed 's/^/  /'
  echo
  echo "Each of these is a channel between worktrees. Whether it changes a"
  echo "RESULT depends on whether the tool reads it back and whether its keys"
  echo "collide across trees — but the isolation is already gone."
fi
echo "=============================================================="

# Self-check: this tool must not commit the bug it looks for.
fingerprint "$WORK/src-after.txt"
if diff -q "$WORK/src-before.txt" "$WORK/src-after.txt" >/dev/null 2>&1; then
  echo "self-check: all $SRC_N files in your node_modules byte-identical. Untouched."
else
  echo "SELF-CHECK FAILED — this script modified your project's node_modules:"
  diff "$WORK/src-before.txt" "$WORK/src-after.txt" | grep '^[<>]' \
    | sed 's/^[<>] //' | cut -f1 | sed 's/^/  /' | sort -u
  echo "That is a bug in this script. Please report it."
  exit 1
fi
