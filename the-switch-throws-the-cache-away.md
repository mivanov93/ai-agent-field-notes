# The switch throws the cache away

*Written 2026-09-01.*

*Scope: measured on Claude and Claude Code, 2026-09, against Anthropic's
own docs (a scoped fetch of their hosts). Read the split carefully,
though. The model half — switching models forces a full recompute — is
not Anthropic policy and not a Claude quirk: a prompt cache is a KV
cache, and a KV cache cannot cross models by construction (the mechanism
explains why), so this holds for essentially any transformer LLM behind a
cache. What *is* Anthropic-specific: keying the cache to effort as well,
the Fable-5 classifier fallback, the fallback credit, and the
API-versus-subscription billing — those a vendor can do differently, so
re-measure them off Claude. The quotes are theirs; the framing is mine.*

**Claim:** in Claude Code, the prompt cache is bound to the model and to
the effort level. Switch either mid-session and the whole request is recomputed
from cold on the new setting — the warm cache does not carry over. That
is a full re-read of the entire conversation, and it costs: dollars on
the API, usage-quota plus latency on a subscription. Anthropic ships a
"fallback credit" that undoes this, but only on the API and only for the
one involuntary Fable→Opus flip its classifier forces. So on the
subscription most people run, every switch — involuntary or manual — is
an uncredited full recompute. Switching models is not free, and the
thing that would make it free is not on your plan.

## The mechanism

Claude Code's prompt-caching page is explicit that the model and the
effort are both part of the cache key: "each model has its own cache.
Switching models recomputes the entire request even when the content is
identical," and "changing effort mid-session recomputes the entire
request." The cache is a warm prefix keyed to one (model, effort); change
either and there is no warm prefix to read, so the new setting processes
the whole context as a cache write. On the API a cache read costs about a
tenth of a write, so the switch turns a cheap turn into a full-price one.

## A KV cache can't cross models

This half is not Anthropic policy, so it travels. A prompt cache is a KV
cache: the attention keys and values a model computes for the prefix
tokens, kept so the next turn skips recomputing them. Those values are a
function of the model's weights. A different model has different weights,
so its keys and values would be different — the saved cache is nonsense
to it, and there is nothing to read. You cannot share a KV cache across
models; a vendor that offered to "keep the cache" through a model switch
would be recomputing underneath and absorbing the cost, which no one
does. So the model half of this note holds for essentially any
transformer LLM behind a cache, not just Claude.

Effort is the softer case, and the one that is a choice. The same model's
prefix KV could in principle be reused across effort levels, so keying
the cache to effort — as Claude Code does — is a policy, and another
vendor could decide it differently. The model boundary is physics; the
effort boundary is a decision.

## The credit, and where it stops

There is a mechanism that undoes the cost — narrowly. When the safety
classifier makes Fable decline and the request retries on Opus 4.8,
fallback credit bills the already-cached prefix at the read rate, "as
though the conversation had been on the new model all along." Two hard
limits, both from the docs:

- **It covers one transition: the involuntary decline-and-retry.** A
  manual switch is not a decline-and-retry. So a manual Opus→Fable, or
  the manual switch *back* to Fable that recovers from a classifier
  degrade, gets nothing — full recompute.
- **It is an API feature.** Fallback credit is documented "in beta on the
  Claude API, Amazon Bedrock, … Google Cloud, and Microsoft Foundry."
  Subscriptions — Pro, Max — are not named anywhere on the page. There is
  no documented fallback credit for a subscription.

## The two regimes

On the **API**, the switch costs money: the full-price re-read, minus the
one credited flip. Real, but bounded, and the involuntary flip is
refunded.

On the **subscription** — what most Claude Code sessions run on — the
switch costs *usage*. The plan is metered in tokens, a recompute spends
more of them, and you hit your caps sooner; the re-read also just takes
longer. Anthropic tracks this directly: `/usage` lists "cache misses"
among the behaviors it flags "when one accounts for 10% or more of recent
usage." And because fallback credit is API-only, even the involuntary
classifier flip — the one the API refunds — appears to burn subscription
quota with no refund. The plan most exposed to the classifier's
switching is the plan with no credit for it.

## It compounds with the classifier

[The classifier reads the costume](the-classifier-reads-the-costume.md)
flips your model for you, sometimes many times in a session — ten in the
incident there. Each flip is a recompute, and its own recommended
recovery, switching back to Fable by hand, is a manual switch: an
uncredited full re-read on either regime. So that incident was not only a
model swap and a miscount — every one of those switches, and the fix for
them, quietly re-read the whole context.

## The rule

- **Pick the model and the effort at the start of a task and hold them.**
  Every mid-task change to either throws the warm cache away and re-reads
  the whole context.
- **Don't casually drop to a cheaper model mid-session to save money.**
  The cheaper model can't read the pricier one's cache, so the switch
  turn pays full price; any saving starts only on later turns, and only
  if you then stop switching.
- **Assume no refund on a subscription.** Fallback credit is an API
  feature; on Pro or Max, treat every switch — the involuntary classifier
  flip included — as spending real usage, and check `/usage` for the
  cache-miss flag.
- **If the classifier keeps flipping you, don't fix it by flipping back —
  restart on the model you want.** A clean session starts one warm cache;
  a flapping one pays a recompute each direction.

## Prior art

**Verdict: PARTIAL — verified against the docs 2026-09-01.** The
mechanism is Anthropic's own documented design and well-worn among
practitioners: the per-model and per-effort cache, the full recompute on
switch, the roughly ten-to-one read-versus-write gap, and the advice to
pick a model and stop switching are all on the Claude Code prompt-caching
page and across cost write-ups. Fallback credit is documented too. What I
did not find stated anywhere: that fallback credit is API-only and so
does *not* reach the subscription most Claude Code users are on — leaving
the involuntary classifier flip an uncredited usage cost on the plan most
exposed to it — and the framing of a switch's cost as quota-and-latency
rather than dollars for those users. Two things I deliberately do not
lean on: the exact cache TTL (the docs give five minutes for the API and
a longer figure for subscribers, and a 2026 change muddies it), and a
verbatim statement that a subscription cache miss over-consumes tokens
(the `/usage` behavior flag strongly implies it; the docs do not spell it
out). Adjacent: [the classifier reads the
costume](the-classifier-reads-the-costume.md) (the involuntary switches
this prices) and [old sessions run the old
rules](old-sessions-run-the-old-rules.md) (the other half of the same
prompt-caching page — the instruction file loaded once).
