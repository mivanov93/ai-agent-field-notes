# Context

## What this repo is about

Everything here is about using AI models and agents for **software
engineering** — developing, fixing, extending, testing, and documenting
software. The incidents behind the notes are coding sessions: an agent writing
a feature, a refactor that passed its tests and broke the product, a fan-out
of review agents, an instruction file that grew too fast. When a note says
"the model," it means a model doing engineering work on a real codebase,
supervised by a human who is also an engineer.

## How far it generalizes

I believe most of it is general-purpose. The deepest findings are about how
the model behaves, not about any one language or stack — that a model makes
more of whatever the corpus already is, that it can't reliably check its own
work without something that can reject it, that you can't buy quality by asking
for it. Those should hold for most software work, whatever the tools.

But some specifics may not carry to an entirely different kind of work. If you
are using a model for something that isn't engineering — writing a fantasy
novel, composing music, other open-ended creative work — the mechanics can
differ: what "good" means, what counts as a check it can fail, what a corpus
teaches, and whether there is a test to pass at all. Read these as
software-engineering field notes. Carry them to another domain if they fit, but
re-measure there rather than assuming — the same thing the repo already asks
you to do across models.
