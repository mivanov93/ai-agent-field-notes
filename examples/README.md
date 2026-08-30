# examples

A sample [CLAUDE.md](CLAUDE.md) distilled from every principle in this repo,
for a generic software project — not the project these notes came from. Each
rule links the note it comes from, and is tagged `[model]` / `[operator]` /
`[shared]` by who it addresses — the file is read by both the agent it steers
and the human running the project.

Adapt the bracketed constitution (§1) to your own project; the rest is
portable. It is a demonstration of what an instruction file that follows these
notes looks like — including following the notes' own advice about how to write
one: a hand-written constitution first, then rules that each carry their reason.
Read it, don't drop it in unread.

## Reproductions

Runnable evidence for the notes that need it — each folder has a README with
how to run it and what the result means:

- [hardlink-repro](hardlink-repro/) — the `node_modules` hardlink and stale-cache
  hazards behind [two worktrees, one node_modules](../two-worktrees-one-node-modules.md).
- [ed25519-seed-repro](ed25519-seed-repro/) — loading a signing key as the first
  32 bytes of a file, and why every PEM then yields the same public key.
