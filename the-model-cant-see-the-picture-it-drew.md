# The model can't see the picture it drew

*Status: DRAFT — not yet walked through for publication; prior-art sweep not
yet run. One artifact type is measured (a mermaid state diagram; evidence
from five session transcripts spanning the design session and a later
docs pass); the wider rendered-artifact class is mechanism, not
measurement. The render probe below was run while writing this note.*

**Claim:** the model can see — seeing just costs extra. A generated
diagram exists as source until a render step turns it into a picture, and
inspecting the picture costs a command plus the tokens to read the image
back. Left to its defaults the model never buys the look. It iterates on
the artifact from the text side, substitutes properties of the source
(edge counts, label lengths, acyclicity) for properties of the picture
(readable, uncrossed, unsquashed), and reports that substitution in the
grammar of verification. The human eye becomes the only render gate in
the loop — one round-trip per guess — and when the model finally named
the gap, it named it as incapability, not as a look nobody had bought.

## The incident

A design session produced a case state machine as a mermaid diagram. I
rejected it visually three times running: "the diagram on the
states is unreadable, it's squashed" — then, a fix later, "the arrow
labels still go through multiple arrows and it's hard to read" — then,
after the next fix, "removing the arrows back is not good, we need to
know the information."

That middle round is the one to study. The model reasoned about the
renderer from memory — "Dagre can't lay out hub-and-spoke with returns
cleanly, no matter the labels" — and its fix was to **delete the five
return edges**, demoting that information to a prose rule above the
chart. It committed, then asserted a pixel-space claim it had never
observed: "The chart is now eleven forward edges and no cycles … **each
label sitting on its own arrow**." Its offered escalation — per-flow
mini-diagrams — was another guess about pixels it had not seen. Only my
third rejection forced the fix that kept the information (the hub
drawn twice, returns as forward arrows).

Sessions later, scaling the same discipline across a whole docs pass, the
model said the quiet part: "One honest caveat: **I can't render mermaid
from here**, so verification was by the structural discipline that's
worked so far — short labels, forward arrows, the duplicated hub. Two
charts are worth an eyeball on your side." No render command appears
anywhere in the five session transcripts. Verification by looking had
been replaced by self-invented source-side heuristics, and the looking
was delegated to me.

## The mechanism: sight is priced, and the default never pays

While the model writes diagram source there is no picture; the picture
exists only after a render it must spend to produce and spend again to
inspect. Nothing in the default loop budgets that spend, so the loop
ships without its gate — silently. The model did not decline the look; it
never surfaced that a look was for sale. What it offered instead reads
exactly like verification: "structural discipline," true statements about
the source standing in for unchecked statements about the picture. A
suite that asserts nothing about the rendered artifact is green over that
artifact in name only ([all green, still broken](all-green-still-broken.md)) —
and here there was no render step for the diagram to fail
([a gate you can fail](a-gate-you-can-fail.md)).

And the one time the gap was named, it was named wrong. "I can't render
mermaid from here" is a capability claim the session never tested — no
attempt, no failed command in the record — from a model that had shell
access and had been committing with it. The honest sentence was "a render
costs a command and an image read, and I haven't spent it." Mislabeling
an unpaid cost as an impossibility is
[the model not knowing itself](the-model-doesnt-know-itself.md), with
["it can't be done" is usually out of date](it-cant-be-done-is-usually-out-of-date.md)
as the standing correction.

The self-report is not even stable. The same capability draws opposite
answers on different days — I have watched other sessions offer to
render and inspect the picture; this one declared it impossible — on
tooling that, on this machine at least, did not change (the probe below
confirms it was present). That variance is
[the model not knowing itself](the-model-doesnt-know-itself.md) in its
purest form: "can I see?" is answered by completion, not introspection,
so the answer tracks the phrasing of the moment rather than the machine
it runs on. The stable
fact is the price of the look; the unstable one is the model's account
of it.

The mechanism is not mermaid-specific: any artifact whose acceptance
lives in a rendered space — plots, slide layouts, PDF pagination, UI —
sits behind the same unpaid look. One artifact type is measured here;
the rest is the same loop by construction.

## The probe, run

Writing this note ran the probe the incident skipped. On the same
machine as the sessions: `mermaid-cli` 11.16.0 resolved with no install;
the incident's own state machine rendered to a PNG in about three
seconds, one command; a model then read the image. Two results. "I
can't render mermaid from here" was false — the look was for sale at
exactly the price this page claims, one command and one image read. And
the blind claim "each label sitting on its own arrow," checked against
the actual picture months late, is roughly true for most of the chart
and false exactly where the reasoning was blind: at the
return-convergence on the duplicated hub, curves cross and several
labels float between arrows. The render gate would have caught in three
seconds what three rounds of my pushback caught by hand.

## The rules

- **Buy the look.** Render in the loop and hand the image back to the
  model — the blindness is in the loop, not the model. It costs tokens;
  that is the price of a gate, and the gate is the wrong place to save
  ([you can't ask for cheaper](you-cant-ask-for-cheaper.md)).
- **Pixel-space assertions require a render.** "Readable," "no
  overlaps," "each label on its own arrow" are banned sight-unseen. The
  honest status for an unrendered diagram is "unverified: never
  rendered," not a description of how it looks.
- **Source discipline is not a verdict on pixels.** Short labels and
  forward arrows are good habits; they verify the source. Only a look
  verifies the picture.
- **Trading information for layout is a scope decision** — the owner's,
  made in the open. The deleted return edges were a silent one.
- **The model's account of its own eyes is not evidence — in either
  direction.** Sometimes it offers the look, sometimes it denies having
  one; both are completions. Only an attempted render command settles
  it, and it settles it in seconds.

## Prior art

**Verdict: NOT YET SEARCHED.** Render-feedback loops exist in public
work — screenshot-driven UI iteration is widely demonstrated, and
vision-in-the-loop generation is an active research area — so the
mechanics of the fix are presumably KNOWN. What has not been checked:
the default-loop framing (the model never volunteers to buy its own
look), the substitution tell (source properties reported in the grammar
of pixel verification), and the mislabeling of the unpaid cost as
incapability. Adjacent here:
[the face transplant](the-face-transplant.md) (rendered states validated
by hand) and [where the savings are](where-the-savings-are.md) (the look
is a gate; gates are the wrong savings).
