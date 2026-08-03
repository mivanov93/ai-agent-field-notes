# What's actually going on

*A plain-English walkthrough of the hardlink hazard: why sharing
`node_modules` between worktrees can make a test fail in a directory nobody
touched. Companion to [the note](the-hardlink-hazard.md) and the
[reproduction](examples/hardlink-repro/).*

## The short version

If you run several AI coding agents at once, you give each one its own copy of
your project so they don't trip over each other. Copying the project is cheap.
Copying `node_modules` is not — it's hundreds of megabytes and hundreds of
thousands of files.

So people share it. One popular way is `cp -al`, which makes a copy where the
files aren't really duplicated; they're just given a second name. It's
instant and free.

The catch: some of those files aren't inert library code. Your test runner
keeps a small scratch file in there. When it updates that file, it doesn't
create a new one — it writes over the old one. And because the file has two
names, writing through one name changes what you see through the other.

So a test run in agent A's directory can quietly rewrite a file in agent B's
directory. In the case I hit, that changed the *order* B ran its tests in, and
because the suite had one test that depended on another running first, B's tests
failed. B's code was fine. B's tests were fine. Nothing in B had changed.

That's the whole thing. And then, checking whether other tools had the same
problem, I found a second one that doesn't need hardlinks at all: a plain
ordinary copy of `node_modules` can carry a stale build record into a fresh
worktree, after which TypeScript reports success and produces no output
whatsoever.

The rest of this explains each step, what I got wrong the first time, and how
far the problem actually reaches.

## Why anyone is doing this in the first place

The reason this matters *now* is that people started running coding agents in
parallel.

If you have four agents working on the same repository at the same time, they
can't all share one directory — they'd overwrite each other's edits. The
standard fix is a **git worktree**: git can check out the same repository into
several directories at once, each on a different branch. Agent A works in one,
agent B in another. Their source files are properly separate.

But `node_modules` — the folder holding your project's downloaded dependencies
— isn't tracked by git. Each new worktree starts without one. Running a fresh
install in every worktree takes minutes and eats a gigabyte a time.

So the obvious optimisation is to share it. Every guide on parallel agents
discusses some version of this. And in principle it's a great idea:
dependencies are supposed to be read-only. You downloaded them; you don't edit
them. Why store six copies?

## What a hardlink is

On disk, a file is really two separate things: the actual data, and a *name*
pointing at it. Usually there's one name per lump of data, so the distinction
never comes up.

A **hardlink** is a second name for the same data. Not a copy, not a shortcut —
a genuinely equal second name. If you have `a.txt` and you hardlink it to
`b.txt`, there's still only one lump of data on disk with two names pointing at
it. Delete `a.txt` and `b.txt` still works. There's no "original."

`cp -al` copies a directory tree this way. It recreates all the folders for
real, then, instead of copying each file, gives it a second name. Copying a
500 MB `node_modules` this way takes a second and uses almost no extra space.

The property that makes it fast is the same property that causes the bug:
**there is only one copy of the data.** If anything writes to that data through
one name, everyone looking through any other name sees the change. There's no
copy-on-write, no isolation, no protection. Hardlinks share; that's what they
are.

This is not obscure. Backup tools have used `cp -al` for decades to make
snapshots that share unchanged files, and "don't edit files inside a snapshot,
you'll corrupt all of them" is long-standing folklore in that world. pnpm — one
of the most popular JavaScript package managers — is built entirely on this
trick, and its documentation warns that editing a file in `node_modules` will
corrupt the shared store for every project on your machine.

So the mechanism is old news. What surprised me is where it turned up.

## The part everyone assumes is safe

The assumption underneath sharing `node_modules` is: *dependencies are
read-only.* Nothing writes to them, so sharing them is free.

That assumption is wrong, and it's wrong in a boring way. Build tools need
somewhere to keep scratch data — what did I compile last time, how long did
each test take, which files failed. They need a folder that's per-project,
already ignored by git, and automatically wiped when you reinstall.

`node_modules` is exactly that folder. So that's where a lot of tools put their
caches. Vite uses `node_modules/.vite`. Vitest keeps its results cache in
there. Others use `node_modules/.cache`.

It's a perfectly reasonable choice, *as long as nobody shares `node_modules`*.
The moment you do, you've merged two things that should never have been merged:
a pile of immutable downloaded code, and a pile of mutable per-directory
scratch state.

## What actually went wrong

The incident that started this: agents were reviewing a TypeScript frontend.
Each agent had its own worktree, so their source files were isolated. The
`node_modules` folders were shared with `cp -al`.

Two agents then failed to reproduce a test failure that the main session had
reproduced four times. Not "got a different error" — just couldn't make it
happen.

The natural conclusion is that the failure isn't real, or that the agents are
broken. Both were wrong. The trees were leaking into each other through a
shared cache file, and a deliberately-planted defect in one tree looked
identical to a genuine failure in another. A wrong diagnosis shipped that day.

That's the part worth dwelling on. The failure mode isn't a crash or an error
message. It's *your tests quietly telling you something false*, in a setup whose
entire purpose is to check work in parallel and trust the answers.

## Testing it properly

A story about a confusing afternoon isn't evidence. So I built a reproduction
that either shows the effect or doesn't.

The setup: a small project with vite and vitest. Install dependencies once. Run
the tests once in the main directory — this matters, and I'll come back to why.
Then make three copies:

- **A** and **B** share `node_modules` via `cp -al` (hardlinked).
- **ctl**, the control, gets a real `cp -r` copy.

All three have identical source code. Then:

1. Run B's tests. They pass.
2. Go to **A**, break one of A's own test files, run A's tests. They fail —
   as they should, the defect is real and it's in A.
3. Go back to **B**. Change nothing. Run B's tests again.

If the trees are isolated, B passes again. Here's what actually happens:

```
B on its own:                    GREEN seed use
A ran red — a defect planted in A's sources only
B again, sources untouched:      RED use seed
control stayed GREEN through the same provocation
```

B goes red. The control, which got a real copy, sails through the identical
provocation untouched. So it isn't timing, or the test runner being flaky, or
my test project being cursed. It's the hardlinks.

The `seed use` / `use seed` part shows the mechanism. Those are the two test
files, in the order they ran. B's own order was `seed` then `use`. After A's
run, B ran them backwards.

Why does order matter? `seed` creates a fixture file that `use` needs. Run them
in order, everything passes. Run `use` first and the fixture doesn't exist yet,
so it fails. That's an order-dependent suite — very common in real projects,
where one spec seeds a database or writes a shared setup file.

And why did the order change? Vitest keeps a small file recording how long each
test took and whether it failed, so next time it can run the slow and
previously-failing ones first. That's a sensible optimisation. But that file
was hardlinked between A and B. When A's tests failed, vitest wrote "this test
failed" — into a file B is also using. B read it, dutifully moved that test to
the front, and broke itself.

Two more details make it work. The cache folder is named after a hash that
comes out identical in every worktree. And the entries inside are keyed by file
path *relative* to the project root — a deliberate choice, so the cache works
the same in CI as locally. Both mean A's entries aren't just physically in B's
file; they're semantically valid there. B has no way to tell they're foreign.

## Why it doesn't always happen

This is the part I got wrong initially, and it's the part that makes the bug so
annoying. Five things all have to be true. Break any one and nothing happens.

**1. Everything is on one filesystem.** Hardlinks can't cross drives. If they
can't be made, `cp -al` fails loudly, so this never bites you silently. (I
managed to trip over this myself while writing the repro: I pointed it at a
directory on a different device and got several thousand error messages.)

**2. The file already exists when you copy.** This is the big one. `cp -al`
gives second names to files that exist *at that moment*. It creates the folders
fresh. So anything written afterwards is a genuinely new file in one tree only.

Worth killing a natural misreading: this is **not** about how deeply nested the
file is. `cp -al` recurses all the way down, and the file causing all this
trouble sits four folders deep. Folders matter only because they're recreated
rather than shared — so a brand-new file written into a folder both trees have
exists in one tree only, even though everything that folder already contained is
shared. Time, not depth.

A `node_modules` straight out of `npm ci` has no cache folder at all. Copy that
and share nothing — each tree makes its own cache later, privately. The hazard
needs someone to have run the tests in the main directory *before* the copies
were made. Which is, of course, exactly how you normally end up making copies:
you were working, and then you spun up agents.

That's the whole explanation for the intermittency. Same commands, same tools,
and whether you're exposed depends on something you did earlier and didn't
think about.

**3. The tool overwrites in place.** Two ways to update a file. Open the
existing one and write over it — this goes through the hardlink and everyone
sees it. Or write a new temporary file and rename it over the old name —
this *replaces the name*, breaks the link, and touches nobody else.

Vitest does the first. Vite's dependency optimiser does the second.

**4. The cache key means the same thing in both trees.** Covered above:
relative paths collide, absolute paths wouldn't.

**5. Something reads it back and acts on it.** Vitest's file only controls
ordering. But ordering is enough when a suite has any order-dependent test.

## There are actually two problems

Everything above is about hardlinks: two names for one lump of data, so writes
travel between trees. Call that **live contamination**. It keeps happening, in
both directions, for as long as the links exist.

While checking whether other tools were affected, I found a second problem with
nothing to do with hardlinks at all.

TypeScript can compile "incrementally": it keeps a file recording what it built
last time so it can skip unchanged work, and that file is often configured to
live in `node_modules`. Copy `node_modules` into a new worktree and the new tree
inherits a record of a build that happened *somewhere else*:

```
base tree compiled normally: dist/a.js exists
hardlinked tree: tsc exited 0 and emitted NOTHING (dist/ empty)
cp -r tree:      SAME silent empty build
delete the inherited buildinfo and it compiles
```

TypeScript reads the inherited record, sees "these outputs already exist",
believes it, and exits with a success code having produced no files. Your build
says it worked. Your output folder is empty.

Note the third line. The `cp -r` control — a real, honest copy, the thing I'd
been recommending as safe — fails exactly the same way. The problem isn't that
the file is *shared*; it's that the file was *copied at all*. Any copy carries
it: `cp -r`, `tar`, `rsync`, a Docker build, a CI cache restore.

So there are two channels. **Live contamination** needs hardlinks and keeps
propagating forever, both ways. **Copy-time contamination** needs only that the
cache existed when you copied, and every copy method does it. A cache can be on
both — vitest is. The fixes differ: copy-time dies if you delete the cache
directories after copying; live needs genuinely separate dependency trees.

## What decides whether a cache is dangerous

I measured four. Two properties decide everything, and neither is visible from
outside:

| Cache | Written in place? | Keys | What you get |
|---|---|---|---|
| vitest `results.json` | yes | relative | wrong test results |
| tsc `tsbuildinfo` | yes | relative | silent empty build |
| eslint `.eslintcache` | yes | absolute | propagates, can't collide |
| vite `deps/` | no — rename | — | harmless |

**Written in place** decides whether it rides the live channel. Overwrite the
existing file and the change goes through every hardlink; write a temp file and
rename it and the link breaks harmlessly.

**Relative or absolute keys** decides whether one tree's entries mean anything
in another — which is what turns "a shared file" into "a wrong answer". ESLint
is the instructive one: it writes in place exactly like vitest, so the file
really is shared, but it records **absolute** paths. Tree A's entries are about
`/home/you/treeA/src/app.js`, which tree B will never look up. Both trees
scribble into one file without ever reading each other's entries — messy, not
wrong. Vitest records paths **relative** to the project root, deliberately, so
the cache works the same in CI as locally. Which also makes tree A's entries
perfectly valid lookups in tree B, with no way for B to tell they are foreign.
One design decision, made for a good reason, is the whole difference between
"harmless" and "your tests lie to you".

And vite is the reason you cannot do this from reputation. Its dependency cache
is the big conspicuous one, so it looked like the guilty party; it is the only
one here that is completely safe, because it happens to rebuild into a temp
folder and rename. I measured it: the file gets a brand-new identity and the old
one stays behind, intact, for whoever else was using it. The tool that looked
dangerous is fine and the small forgettable one is the problem, for no deeper
reason than which write strategy each happened to pick.

Which cuts both ways: these results are pinned to specific versions (vite 8.2.0,
vitest 4.1.10). If vitest switched to rename-based writes tomorrow the bug would
quietly vanish; if vite switched the other way it would get much worse. Neither
would be announced, because from the tools' point of view none of this is a
supported use case.

One last thing I expected and didn't get: a crash. If two agents run tests at
the same moment, one can read the shared file halfway through the other writing
it, and I assumed that would produce an obvious error. It doesn't — vitest wraps
that read in a "if this fails, carry on regardless", so a mangled cache is
silently discarded and rebuilt from nothing. Reasonable defensive coding, and it
means the corruption never announces itself.

That is the pattern across every failure here. The suite reorders without
telling you. The build reports success and emits nothing. The cache resets and
nobody hears. Not one produces a stack trace, which is precisely why it cost a
day.

## The second door

While checking this I found a related problem the original note missed, and
it's worse.

If your project uses `npm link`, or a `file:../some-lib` dependency, then the
entry in `node_modules` isn't a folder — it's a **symlink**, a pointer to a
directory somewhere else.

Neither `cp -al` nor `cp -r` follows symlinks. Both copy the pointer as a
pointer. So if it points somewhere outside your project, every copy points at
the same place. All your worktrees share that library — not a snapshot of it,
the live thing.

That's worse than the hardlink problem in three ways. It isn't frozen at copy
time, so new files are shared too. The temp-file-and-rename trick doesn't save
you, because the rename happens inside the shared folder. And it's your actual
code, not a metadata file — if one agent rebuilds that library while another is
testing against it, the second agent is testing a moving target.

Most importantly: **`cp -r` doesn't protect you here.** My original advice said
a plain `cp -r` was one of the safe options. For this case it isn't.

One reassuring exception: packages linked *inside* your project — normal
monorepo workspace packages — use relative pointers that resolve within each
copy. Those stay properly isolated.

## The accident that taught me the most

Demonstrating in-place writes, I appended a single comment line to
`node_modules/lodash-es/sum.js` in one tree.

That file had six names. The line appeared in all six trees at once —
including the pristine install I'd been keeping aside as a clean reference, and
two directories set up specifically to demonstrate isolation.

One stray write, in one directory, silently rewrote a dependency for six
projects including the one that was supposed to be untouchable.

That reframes the whole thing. Caches are the *common* trigger, because they're
what gets written during an ordinary test run. But the exposure isn't caches.
It's every file that was in `node_modules` when you copied — including the
library code your tests import. Anything that edits dependencies in place
writes through to every tree: `patch-package`, postinstall scripts,
`npm rebuild`, code generators that emit into `node_modules`.

(A footnote on repairing it: the obvious fix, `sed -i`, would have made things
worse. `sed -i` writes a temp file and renames — so it would have fixed the one
tree and left the other five clobbered. I had to overwrite the file in place.
The same distinction that makes vite safe makes the obvious fix wrong.)

## What to do

**The reliable answer:** any agent that writes files gets its own worktree *and*
its own dependency tree. A real install, or keep the agent read-only. It works
because it doesn't require knowing where every tool hides its cache.

**If you must share,** in order of strength:

- **Delete the caches after copying**, however you copied:
  `rm -rf node_modules/.cache node_modules/.vite`. Kills the copy-time channel
  outright, and it's the one people miss because it applies even to copies
  everyone assumes are safe.
- **Move the caches out.** `export default { cacheDir: './.vitecache' }` takes
  vite and vitest's state out of `node_modules` entirely, killing both channels
  for those tools.
- **Check for symlinks pointing outside your project** before assuming any copy
  method saved you.
- **Prefer package managers designed for sharing.** pnpm's store does this
  deliberately, with the immutability assumption made explicit rather than hoped
  for.

The first two are things you have to *know to do*, about tools you have to
*know* keep state there. That's why they rank below separate trees — and why
the repro ships a detector:

```bash
./detect.sh /path/to/your/project "npm test"
```

It stages one real copy of your `node_modules`, hardlinks two worktrees off that
copy, runs your command in one, and lists every shared file the run wrote
through to the other. Anything it lists is a channel. None of my measurements
are load-bearing for you: write strategies and key formats are undocumented
implementation details that can change in a patch release, so measure your own
stack.

That tool is also the best evidence for the thesis. Its first version hardlinked
your actual `node_modules` into the tree it then ran your build in — committing
the exact bug it exists to find, while its header claimed it was read-only. A
reviewer caught that. The second version fixed the design but proved its safety
with a check that silently measured nothing on any project big enough to matter,
and cheerfully printed *untouched*. That one took a third pass, caught by
running it rather than reading it. A check that passes without evidence is
indistinguishable from a check that passes.

**The general lesson:** `node_modules` is two things at once. It's the output of
an install — content-addressed, immutable, shareable. And it's a scratch
directory — mutable, per-project, definitely not shareable. Sharing is safe for
the first and unsafe for the second, and they live in one folder with nothing
marking which is which.

Every way of copying that folder gets one of those two jobs wrong. Hardlinks
break the mutable half. Plain copies carry stale state into a directory it
doesn't describe. Symlinks share the live thing outright. Three strategies,
three failures, one root cause.

None of it is a Linux problem, incidentally — my *scripts* leaned on
Linux-specific tools for a while, which is a different sentence entirely.
Hardlinks are POSIX, macOS supports them fine, and the copy-time channel needs
no hardlinks at all, so it reaches any copy of `node_modules` anywhere.

Everyone treats dependency sharing as a disk-space and speed question. It is
also a correctness question, and the tools give you nothing to reason about it
with.

## Is any of this new?

The mechanism: no, definitively not. Hardlink aliasing has worked this way
forever, backup tools have warned about it for decades, and pnpm documents the
identical hazard in the identical directory.

Worktrees for parallel agents: no. Widely written up through 2026.

Cache contamination between worktrees: discussed, but consistently blamed on
different things — build tools with shared or absolute-path cache directories,
symlinked `node_modules` breaking module resolution, or two agents sharing a
database.

What I couldn't find anywhere is the specific chain: a tool cache living inside
`node_modules` → carried or shared into a second worktree → that worktree
producing a wrong *result*. The closest is an open request on an AI coding tool
to hardlink `node_modules` into agent worktrees for speed, with no mention of
risk.

The TypeScript half deserves its own caveat. That tsc trusts its build record
over checking whether the outputs actually exist is a known limitation, and
people have run into it by deleting `dist/` by hand. What I haven't seen is
anyone pointing out that putting that record inside `node_modules` makes it
reachable *without anyone deleting anything* — you just make a new worktree the
ordinary way.

So the honest claim is narrow: not a new mechanism, but documented, measured
instances of old mechanisms producing wrong answers in a setup lots of people
are adopting right now — plus a map of which caches propagate and which don't,
which turns out not to be guessable, and a detector so nobody has to take my
map on faith.

## How to prove me wrong

The reproduction is a shell script. It prints PASS or FAIL per assertion, has a
control group, and takes a minute after the first install. If it doesn't
reproduce on your machine I'd genuinely like to know, and the most likely
reasons are interesting ones: a different vitest version that changed how the
cache is written, or a filesystem doing something I haven't accounted for.

The claims that would hurt most if wrong, in order:

1. That the reordering is what turns the suite red, rather than something else
   in my test project. The `cp -r` control is supposed to rule that out; if you
   think it doesn't, that's the argument I most want to hear.
2. That `cp -r` reproduces the TypeScript empty-build failure. That one
   surprised me enough that I re-ran it with the buildinfo deleted to confirm
   the cause, and it's the finding that most changes the practical advice.
3. That vitest writes its cache in place and vite's optimiser doesn't. Easy to
   check — the script prints each file's identity before and after.

The thing I'd most like corrected is the table of which caches are dangerous. I
measured four. There are dozens, on stacks I don't use, and the properties that
matter are undocumented implementation details that can change in a patch
release. `detect.sh` is there so you can extend that table for your own stack
instead of arguing with mine.
