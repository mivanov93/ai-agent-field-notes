# The docs aren't on the test

*Written 2026-07-31.*

**Claim:** the public benchmarks that decide which coding model is "best" —
and the reward signals those models are trained on — score one thing:
whether the tests pass. Not whether the code reads well, and not whether the
docs or comments are any good. A model is optimized hard for the graded
property and not at all for the ungraded one. So it writes code that works
and documentation that rots, and that is not a mystery — it is the incentive
showing through.

## What the benchmarks actually measure

Every mainstream coding benchmark scores functional correctness by running
tests: SWE-bench and its Verified and Pro variants, HumanEval and HumanEval+,
MBPP, LiveCodeBench, BigCodeBench, the Aider leaderboard. Apply the patch,
run the suite, count what passes. None has a line for documentation or
comment quality. The training target has the same shape: the dominant
post-training method for coding models rewards a solution when its unit tests
pass — a binary signal, docs invisible to it.

The benchmarks that do touch "documentation" are a different task wearing the
same word: given a function, generate a summary of it, scored by n-gram
overlap against one reference string. That measures whether a generated blurb
resembles a reference, not whether the docs a model leaves in a real repo are
clear and useful — and the overlap metrics are known to track human judgment
weakly. They are also mostly legacy, off to the side of the leaderboards that
actually drive model development.

## What follows

This is the incentive-side half of [the dirty house](the-dirty-house.md).
That note shows the model makes more of whatever the corpus already is —
clean code on a hand-written floor, rotting docs on a model-written one. This
is why the asymmetry starts: the model arrives already sharpened on code that
passes tests and never sharpened on good prose, because nothing ever graded
the prose. Corpus imitation does the rest.

So do not expect benchmark-driven quality where the benchmark never looked.
If you want good docs and comments, you supply the standard the leaderboard
doesn't — an example the model imitates, a review that judges readability, a
check it can fail ([a gate you can fail](a-gate-you-can-fail.md)). Left to the
incentive it was built with, the model optimizes the test, and the docs were
never on it.

## Prior art

The benchmark facts are verifiable and were confirmed across the current
suite (SWE-bench / Verified / Pro, HumanEval+, MBPP, LiveCodeBench,
BigCodeBench, Aider — all test-pass only), and the training point is the
reinforcement-learning-with-verifiable-rewards line, where the reward is
unit-test pass. The documentation-generation benchmarks (CodeXGLUE
code-to-text, CodeSearchNet) are BLEU/ROUGE-scored summary generation, widely
noted as weak quality proxies. One emerging 2026 counter-signal to watch,
"Needle in the Repo," a maintainability benchmark that may blend in
documentation-adjacent factors — new, academic, not yet leaderboard-driving,
and not verified in full here. *Status: the benchmark facts are KNOWN; the
delta is the framing — benchmark blindness to docs as the incentive-side
cause of documentation rot, the missing half of
[the dirty house](the-dirty-house.md).*
