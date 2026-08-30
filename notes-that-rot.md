# Notes that rot

*Written 2026-07-31.*

**Claim:** the model tends to explain its code by pointing at its own
work-session — "step 6," "round 2," "the earlier fix" — instead of at the
reason. Those pointers mean something for one afternoon and nothing forever
after. The words in the comment are usually fine; the reference is the rot.

## The incident

I suspected that months of writing under strict style rules had left the
codebase full of bad, over-worked prose. I had it measured: 1296 comments
graded. The prose was mostly clean — and there were zero of the invented
metaphors I had spent weeks fighting. But one defect dominated, 85% of
every failure: comments that cited a session label. "(item 6, round A.)"
"(the round-C report.)" Notes pointing at a conversation no future reader
would ever have.

The comment beside the label almost always already carried the real reason.
The label added nothing and pointed nowhere.

## The rule

A comment or a doc should point at something a future reader can actually
reach: the decision record, the reason itself, the ticket. Never at the
session that produced it. If the reason is worth noting, state the reason.
Enforce it cheaply — these labels come in a few shapes ("item N," "round
X"), so a grep in the merge check catches them before they land.

## Prior art

**Verdict: PARTIAL, and the closest to unfound of the set.** Adjacent
categories exist: an LLM-generated-comment taxonomy (arXiv:2607.01867) has
"PastFuture" / "Meta" buckets that could house session labels but doesn't
isolate them; "TODO: Fix the Mess Gemini Created" (arXiv:2601.07786) studies
comments admitting AI authorship; "context rot" for stale AI config artifacts
(arXiv:2606.09090); and pre-AI comment-rot work (comment-vs-code drift). None
names the specific defect — a comment whose prose is fine but whose pointer
to the generating session ("item 6, round A") is dead — nor reports a
measurement isolating it (~85% of comment failures against near-zero invented
metaphors), nor the merge-time grep for a few label shapes. Mechanism +
measurement + fix appears original to this write-up as far as the sweep
found. Distinct from banning invented words: there the words are the problem;
here the words are fine and the reference is dead.
