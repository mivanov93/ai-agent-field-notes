# hardlink hazard — reproduction

Evidence for [two worktrees, one node_modules](../../two-worktrees-one-node-modules.md),
which explains what the results mean. This file is just how to run them.

```bash
./repro.sh                                    # 11 experiments, 26 assertions
./detect.sh /path/to/your/project "npm test"  # check your own stack
```

First run installs the pinned toolchain into `.deps/` (under a minute on a warm
npm cache, a few minutes cold); a pass then takes about half a minute.

## Cost and cleanup

The toolchain in `.deps/` is a few hundred MB and persists on purpose so
reruns are fast; `rm -rf .deps` reclaims it. The experiments clean their
own work directories as they go. `detect.sh` works in
`${TMPDIR:-/tmp}/hl-detect.<pid>`; if it dies hard, delete that directory
yourself. And check where your `/tmp` lives before running anything from
it — on many systems it is RAM, and what a demo leaves there is memory
gone until reboot
([the crash lands on the innocent process](../../the-crash-lands-on-the-innocent-process.md)).

**One requirement, checked up front and fatal rather than degraded:** everything
on one filesystem, because hardlinks cannot cross devices. Both scripts also
prove their own inode/checksum primitives work before trusting a comparison.
Linux and macOS/BSD are handled; verified on Linux only, since I have no Mac.
The hazard itself is not platform-specific — only these helpers ever were.

## what each experiment asserts

| | |
|---|---|
| **E0** | `cp -al` shares inodes. In-place writes propagate; write-then-rename does not. |
| **E1** | All three trees share one inode for `.vite/vitest/*/results.json` (`nlink=3`). |
| **E2** | A run in A rewrites that file — same inode — while nothing runs in B. |
| **E3** | B inherits A's `failed` flag, reorders, goes red; forcing the right order makes it pass, so order was the cause. `cp -r` control stays green. |
| **E4** | A truncated cache does *not* crash vitest — it is silently swallowed. |
| **E5** | Counter-example: vite's dep prebundle is rename-swapped, so it never propagates. |
| **E6** | Precondition: a never-run `node_modules` shares nothing. |
| **E7** | Deps symlinked outside the tree are shared by every copy, `cp -r` included. |
| **E8** | Mitigation: one line of `cacheDir` config and B stays green. |
| **E9** | Copy-time channel: `tsbuildinfo` rides `cp -r` too, and tsc emits nothing. |
| **E10** | The discriminator: eslint propagates but its keys are absolute, so it can't collide. |

## detect.sh

Points two hardlinked worktrees at your own project and lists every shared file
your command wrote through to the other. Anything it lists is a channel.

It stages one real copy of your `node_modules` first and hardlinks the worktrees
off *that* — slow, disk-hungry, and not optional. The first version skipped it,
hardlinked your actual tree, and corrupted the caller's project with the exact
bug it looks for. A self-check now fingerprints your tree before and after,
reports the file count it verified, and refuses to certify anything it could not
measure.

Run it after the project has been built and tested at least once. On a never-run
`node_modules` it correctly reports nothing — which is exactly the trap.

Pinned to vite 8.2.0, vitest 4.1.10, typescript 5.9.3, eslint 9.39.5,
node 24.16.0. Write strategies and key formats are unversioned implementation
details, which is why `detect.sh` exists: measure your own stack rather than
trusting a table.
