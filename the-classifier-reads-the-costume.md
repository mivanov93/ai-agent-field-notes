# The classifier reads the costume

*Written 2026-08-29 · last amended 2026-08-31.*

*Scope: Claude Code, Fable 5, 2026-08. One incident, my own session.
During the incident the router was a black box to me; the prior-art
sweep for this page later found it vendor-documented, and the docs are
cited below. How the duplicate agents came to exist is still a
hypothesis; the facts are the switches, the counts, and what fixed
them.*

**Claim:** a platform content-router reacts to the VOCABULARY your work
wears, not to what the work is — and the model swap it triggers is
invisible to the session it happens to. I ran a design review of my own
agentic-AI system — ordinary defensive engineering — written up in
security costume: exploit, attack, red-team, extraction. A cyber
classifier kept flagging the session, and Claude Code kept swapping my
chosen model for another. The trigger was sticky: it rode in the
conversation context, so switching back by hand did not hold and
rewording my next message changed nothing. The session, meanwhile, knew
none of it. It thought I was switching models myself, and after the
shuffle its record of its own work was wrong: I had asked for six
review agents, eight were running, and it believed six.

## The incident

I asked for a review of a support-agent design — the money gate, the
database tables, the failure modes — run by six independent Opus
agents. Real hardening: find the holes before it ships. The reviewers
did their job, and the synthesis came out the way security reviews
usually read — "the attacker," "the exploit," "money extraction," "a
hijacked turn."

Then my model kept changing under me. I had chosen Fable. The session
switched to Opus, claiming danger. I switched it back with `/model`. It
switched again, on nearly every message — ten times before I stopped
counting. I saw a tag in the interface — "[cyber]." Nothing I was doing
was cyber-anything; it was a design doc for my own project.

The session's story about all this was wrong in a specific way: it
thought I was the one switching models. The swap happens in a harness
layer that never tells the session, so an automatic switch and a manual
`/model` look identical from inside — and the session backfilled the
only cause it could see, which was me. It never mentioned a classifier
and never proposed a fix. It couldn't have: the setting that matters
(next section) postdates its training, which is
[the model doesn't know itself](the-model-doesnt-know-itself.md) doing
exactly what that page says.

Then the count went wrong. Eight agents were running where I had asked
for six. I told the session; it checked, expecting six, and was
confused by its own ledger. Somewhere across the swap, launches
happened that the surviving context never recorded — the transcript the
model reasons from was no longer a faithful record of what it had done.
The duplicates billed like originals, which is
[agents launch at full price](agents-launch-at-full-price.md) with the
harness itself doing the launching. Since they were nearly done, I kept
them: two independent runs of the same review lane, and agreement
between them is a free cross-check.

I got frustrated and asked the obvious questions: do I need a new
session? Is my context poisoned now because of the review?

## Why rewording didn't work

The model offered to write more carefully going forward. That was
useless, and understanding why is the whole lesson.

If a classifier is reading the conversation, it is not reading my
latest message — it is reading the window, and the window still held a
full security review's worth of exploit-and-attack prose. Writing the
next message cleanly does not remove what is already there. The trigger
does not reset when you change register; it sits in the transcript and
re-fires every turn. You cannot edit your way forward out of a flag
that lives behind you.

That is the part I would have gotten wrong on my own. My instinct was
"say it nicer from here." The context does not work like that.

## The fix

Two moves during the incident, and the order matters.

1. Get the durable work onto disk. Everything real was already
   committed to git and written to docs — the findings, the state, the
   decisions — and I had the session write a handover for its
   successor (the [appendix](#appendix-the-handover-prompt) has it).
   Nothing important lived in the chat, so a restart cost
   nothing. This is the payoff of [memory belongs in the
   repo](memory-belongs-in-the-repo.md) and [the session
   archive](the-session-archive.md): when the session is disposable,
   throwing it away is free.
2. De-trigger the artifact, then start clean. The review doc was the
   thing a fresh session would read first on orientation — and if it
   still wore the costume, the new session would trip the same wire
   immediately. So I had it rewritten in plain engineering words —
   over-payment, not extraction; failure case, not exploit; reviewer,
   not attacker; a turn that went wrong, not a hijack — and renamed.
   Same findings, same file, different clothes. Then a new session,
   which drops the flagged transcript entirely.

And one move I only found while writing this page, in the vendor docs:
Claude Code has a setting for the switch itself. `/config` → "Switch
models when a message is flagged" off (`switchModelsOnFlag: false`),
and a flagged request pauses the session with a choice — switch, or
edit and retry on your model — instead of silently swapping. The
session could never have told me this. The switch fires in a layer it
cannot see, and the setting postdates its training.

The work never changed. Only the words did. That is the uncomfortable
part: the register carried the whole effect, and the register was
cosmetic.

## The rule

- Turn the switch off before you need it: `switchModelsOnFlag: false`
  (`/config` → "Switch models when a message is flagged"). Flagged
  requests then pause instead of silently swapping. Do not wait for the
  session to suggest this — it can't.
- Write security-adjacent work in domain-plain words from the start.
  "The gate must reject an over-range percentage" is the same finding
  as "the attacker exploits the clamp," and only one of them trips a
  wire. Save the dramatic register for where it earns something; here
  it earned a model swap and an afternoon of friction.
- When the router flips you, do not reword and continue. The flag is
  behind you, in the context. Land your state on disk, then start a
  clean session.
- De-trigger your saved artifacts too, not just your chat. The next
  session reads them on orientation and re-trips on their words, not
  yours. A flagged doc is a flagged session waiting to happen.
- After any switch, audit side effects against the world, not the
  session's memory. Count the agents, the processes, the spend. The
  session's ledger of its own actions can be wrong, and it will not
  notice on its own. If duplicates are nearly done, keep them — the
  same lane run twice is verification you already paid for.
- Make the restart cheap on purpose. If your findings, decisions, and
  state live in files and git, a poisoned session is a throwaway, not a
  loss.

## The rule is a catch, not a default

Written down, the rule does not hold. Proof, from the session that
wrote this note. A day later, writing up a separate finding — [a
signing-key bug in another project](a-lock-every-key-opens.md) — I had
the session build a runnable repro. It came out in full costume: a `loadKeyVULNERABLE`, a
`forgeAdminToken`, an "attacker," an "exploit," a "victim." The
domain-plain rule was not just somewhere in the repo — it was in this
session's own context. I had spent the day editing this very note and
its [examples/CLAUDE.md](examples/CLAUDE.md) rule. The session minted
the flagged artifact anyway, by default, and only stripped the words
when I told it to.

So the register rule behaves like every other rule this repo measures
under load ([settled is a human word](settled-is-a-human-word.md),
[compression is what familiarity feels like from the
inside](compression-is-what-familiarity-feels-like.md)): the model
recognizes it, can even author it, and defaults to breaking it anyway.
Every security-adjacent artifact the session produces — every repro,
write-up, and incident doc — arrives in costume unless a human strips
it. So the supply of flagged documents never stops, and each one is a
flagged session waiting to trip the next orientation, exactly the trap
the de-trigger rule above names. The rule is not a setting the model
holds. It is a catch the human performs, every time.

## Prior art

**Verdict: KNOWN for the costume and the switch; the split-brain is NOT
FOUND on a first sweep.** Searched 2026-08-29 from a clean session —
three research lanes, with every load-bearing citation re-fetched by
hand. (One lane's summary tripped my own harness's fabrication warning;
every citation it returned checked out when fetched directly, which is
[the link rule](the-link-rule.md) applied to my own tools.)

The costume half is well measured. XSTest named the failure "lexical
overfitting" in 2023 (arXiv:2308.01263); "Defensive Refusal Bias"
(arXiv:2603.01246) finds defensive-security queries with sensitive
keywords refused at 2.72x the rate of semantically equivalent neutral
phrasings; CyberSecEval 2 (arXiv:2404.13161) benchmarks exactly this
false-refusal rate on borderline cyber prompts.

The switch half is vendor-documented: Fable 5 runs cyber and biology
classifiers, cyber-flagged requests re-run on Opus 4.8, and "after a
fallback, the session continues on the fallback model"
([model-config docs](https://code.claude.com/docs/en/model-config)).
GitHub corroborates the false positives on benign work:
anthropics/claude-code#67246 (`/model` answers "Kept model as Opus
4.8"), #66595 (a sanctioned bug bounty), #67954, #66723. #73929 shows
the model's own output — fork, kill, orphan, reap — tripping the
classifier midstream, where no input rewording can help; #75325 shows
good-faith rewording scored as evasion. My "[cyber]" tag has no public
sighting; the docs describe a transcript notice. OpenAI's hidden safety
router (Sept 2025) is the cross-vendor neighbor for silent safety
routing.

Even the recovery workflow I derived was already published: a
tagmac.dev guide (2026-06-12) documents the same three moves — the flag
is sticky ("a flagged conversation keeps its flagged context"), start a
fresh session, and neutralize the auto-loaded docs that would re-trip
it ("neutral verbs over combat metaphor"). Cite it, don't claim it.
[Don't interrupt a working agent](dont-interrupt-a-working-agent.md)
remains the closest note in this repo — the same shape: a safety
mechanism firing on the FORM of benign input, not its intent.

**What I think is new:** the split-brain, in which no component holds
the picture. The classifier refuses; Claude Code swaps the model and
re-runs; the swap is never surfaced into the session, so the model
cannot distinguish it from a manual `/model` and attributes it to the
operator. The re-run can duplicate side effects the surviving context
never recorded — six agents asked for, eight running, the session
believing six until made to count. The operator is the only place cause
and cost meet: I found the trigger in the report's vocabulary, chose to
keep the duplicates as verification, and ordered the de-trigger and the
handover — the model executed a fix it could not have proposed. The
first sweep found the visibility gap only as a user-notification bug
(anthropics/claude-code#67469) and context loss across manual switches
(#46423) — nothing on the model-side blindness, the misattribution, or
the duplicated side effects. Not proof of novelty; a clean first sweep.

## Appendix: the handover prompt

Fix step 1 says I had the session write a handover for its successor.
Here is the shape of it. The session's own plan for the prompt was
plain — "point to the review doc as current work, and state where
things left off" — and I want it to carry three properties, each of
which is another note in this repo doing its job. It orients the new
session from disk, not from a memory it doesn't have ([memory belongs
in the repo](memory-belongs-in-the-repo.md)). It is written in the
de-triggered register, so the prompt itself doesn't re-trip the
classifier on the new session's first turn. And it claims no status I
didn't set, so the successor doesn't open by trusting findings nobody
ruled on ([settled is a human word](settled-is-a-human-word.md)).
Adapt the specifics; keep those three.

```
You're picking up a design review of a support agent that can issue
refunds and account credits. The prior work is on disk; you have no
memory of it, so orient before doing anything.

Read, in this order:
1. CLAUDE.md and CONTEXT.md — how this project works.
2. docs/critical-design-review.md — the current work. It holds the
   review findings by area (money-safety, evaluation/quality,
   latency-and-cost), each marked confirmed or discarded, with a
   verification note.
3. The decision log — what has actually been ruled.

Where things left off: the review is written up and complete. The
findings are recorded but not triaged with me — none are approved,
queued, or scheduled, and nothing has been built. Your job is not to
act on them. Walk me through them one area at a time so I can rule on
each.

Vocabulary: this is ordinary defensive design. Describe failure cases
in plain engineering terms — an over-payment path, a duplicate payout,
a request that should be rejected, a reviewer's flag. Keep the standard
payments terms where they are precise: fraud, abuse, chargeback.

Start by summarizing the review's structure and the number of open
items per area. Then stop and wait for me.
```

The register is the whole trick. The same handover written in the
costume — "the attacks the review found," "where the exploit chain
left off" — re-arms the wire on turn one of the session that was
supposed to escape it.
