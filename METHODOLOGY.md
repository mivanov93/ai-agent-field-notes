# Methodology

How the notes in this repo were derived, written, and checked. The short
version: the findings are mine, drawn from real incidents on a real project;
the prior art is searched and cited honestly; and the pages were drafted with
the same models they study and then read and vetted by hand before anything
was published.

## Where the findings come from

Each note began as an incident on a live project — a WebRTC project in Go
with a TypeScript web client, built almost entirely through AI coding
sessions over 2026. Something went wrong even though the right
guidance was already in the model's context, and the note is what fell out of
asking why. The method is the one the notes describe: when work ships wrong
despite green checks, ask why the checks missed it, and write the answer down.
I derived the findings this way, myself — and the ★-marked ones especially are
my own, not restatements of something I read.

## The honest caveat on originality

I cannot fully separate my own derivation from what a model surfaced along the
way. Some of these conclusions were reached while running the models this repo
is about — including deep-research passes that fetched and summarized public
material — and the models themselves carry who-knows-what in their training
data. So when a page says "I think this is new," it means two specific things:
I worked it out in my own project, and I did not find it in my prior-art
sweep. It does not mean I can prove first invention, and I don't claim it. "I
have not found prior art" means "not found in this sweep," never "first" — and
if you know earlier work, an issue turns the claim into a citation.

## How prior art was searched

For each note I ran parallel research agents over public 2024–2026 material —
arXiv, GitHub, vendor docs, practitioner writing — and graded the result KNOWN
(cite it, don't claim it), PARTIAL (neighbors exist; the stated delta is
what's claimable), or NOT FOUND (a clean first sweep, not proof). The closest
work found is cited on each page; the fuller record is in
[PRIOR-ART.md](PRIOR-ART.md). I re-checked the load-bearing citations myself
rather than trusting a summary, because models — including the ones I used —
do occasionally invent a plausible-looking reference.

## How the pages were written and vetted

I drafted these with the same models the notes study. That is the honest
situation, and I would rather state it than hide it. But nothing was published
unread: I read every page by hand, checked that each claim matched what I
actually observed, cut the parts that read as filler, and verified the
citations before they went in. The model helped write; the judgment about what
is true and what ships is mine.
