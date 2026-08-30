# Move the code, lose the test

*Written 2026-07-31.*

**Claim:** when you pull duplicated code into one shared place, the tests
that used to cover it can quietly stop covering it — and everything stays
green. Combining code is supposed to be safe because the tests still pass.
Sometimes they still pass only because they can no longer see the part that
would break.

## The incident

Two screens in an app had drifted apart. One still had a small safety
check; the other had lost it. The fix looked obvious: pull the shared piece
into one place both screens call, safety check included, so neither screen
can lose it again.

But once the piece was shared, it stopped deciding that check for itself.
It now took the answer from whichever screen called it. Both screens passed
an answer. Nothing tested that either screen passed the right one.

To measure the hole, I set both screens to pass the harmless, do-nothing
answer and ran the whole suite. All 1250 tests passed. The old tests had
checked the shared piece; not one of them checked that the screens handed
it the correct input. The bug I had just "fixed" could come straight back
and the suite would stay green.

## The rule

Whenever you move shared logic into one place and it starts taking its
inputs from the callers, the callers' job of supplying the right input is
now untested. The old tests covered the logic, not the hand-off.

So after any such move: set each new input to its harmless value on
purpose, and run the tests. Anything still green there is code with no test
behind it — write that test before you trust the merge.

## Prior art

**Verdict: PARTIAL** — the two halves exist separately, welded here for the
first time the sweep could find. The move is Fowler's "Parameterize Function"
(refactoring.com) — merge near-identical routines by taking the difference as
a caller-supplied argument. The check is Jon Reid's "Who Tests the Tests?"
(Quality Coding, 2016): deliberately corrupt a value and re-run — if nothing
goes red, it has no test; manual mutation testing, the same ritual this note
prescribes. "Rotten green tests" (RTj, ICSE 2020, arXiv:1912.07322) names
suites that pass while an assertion never runs. The delta: the specific
class — consolidation turning an inline value into a caller-supplied input
whose correctness no existing test checks — and the post-refactor gate scoped
to it. The ritual itself is not new (Reid, 2016); the named failure class and
the trigger are.
