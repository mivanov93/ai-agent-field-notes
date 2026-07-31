# The story

Every finding in this repo comes from one story. Read it first; the pages
make more sense as chapters of it than as a list. It is not finished.

## The blog, and asking for perfection

I started with a blog project run through AI coding sessions. I told the
agent what I wanted in the natural words: perfection. Impeccable design,
strict security, extreme performance.

It mostly worked. The code that came out was decent and easy to
understand. The comments were mostly fine. But the documentation grew
extremely hard to follow — dense, complicated, over-built. I did not yet
understand why asking for the highest quality had produced the least
readable part of the project
([don't ask for perfection](dont-ask-for-perfection.md)).

Meanwhile, invisibly, the harness's memory mechanism was piling up notes
about the project and about me. One of them was a profile: my engineering
bar, rendered as superlatives, with clauses like "expects micro-decisions,
only escalate genuine forks." I did not read these files. Every session
did ([the model's model of you](the-models-model-of-you.md)).

## The WebRTC project, and the natural experiment

Then I started the real project: a WebRTC service in Go, built on months
of code I had written by hand before any agent touched it. The sessions
ran from the same directory as the blog — which meant, though I did not
know it, they inherited the blog's memory, profile included
([memory belongs in the repo](memory-belongs-in-the-repo.md)).

What happened next was a controlled experiment I did not mean to run. The
code quality persisted — sessions extending my hand-written codebase
stayed decent, readable, easy to follow. The docs and comments degraded
fast. Same sessions, same rules, same models. The difference was the
floor: the code corpus was mine, so sessions imitating it imitated clean
work. The doc corpus was model-written from day one, seeded by the
profile's register and the perfection framing — so sessions imitating it
made it worse. The model makes more of what you have, whichever
direction "more" points ([the dirty house](the-dirty-house.md)).

## The first diagnosis: the memory, and no constitution

When the mess became undeniable, I asked the model, plainly: why do you
produce such bad output? It could not answer. The hypothesis had to come
from me. I went looking, found the memory files, found the profile, and
pointed. The model checked and confirmed immediately: it had been reading
the profile every session, grepping the contaminated docs, loading the
filth and building more on top. The cause had been in its context the
entire time, invisible to it as a cause.

So the first fix had two parts. I deleted the bad memories, profile
included. And — since there had been no instruction file at all — I made
one, distilled from the session archive and from the content of those
same memory files. I deleted the files and kept their words: the sediment
became founding text at the very moment of the purge
([the founding document](the-founding-document.md)). The archive itself
turned out to be the best decision in the whole story — everything I
later learned, I learned from it
([the session archive](the-session-archive.md)).

The output did not get better. I did not know why yet.

## The second diagnosis: not enough rules

By now there was no memory filth left — only the instruction file, and
still more filth in every session's output. So the next obvious
explanation was that the rules were too few or too weak, and I piled them
on: the file more than doubled in eleven days, thirty-three of
thirty-five revisions additive. I banned the model's invented metaphors —
and fresh ones appeared within three days, because the pressure that
minted them was untouched
([bans rotate the vocabulary](bans-rotate-the-vocabulary.md),
[vocabulary control](vocabulary-control.md)). Rules were broken the day
after they were written, by a model with the rule in its context
([the rule-efficacy pipeline](the-rule-efficacy-pipeline.md)).

Consulting the model made it worse. Asked to research the problem, it
compared other repos and told me they had no rules, so maybe I should
remove mine. Asked for fixes, it offered more rules, then fewer rules,
then "let's just be clean from now on" — every answer an amount, never a
new variable
([the model votes for more rules](the-model-votes-for-more-rules.md),
[the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)).
It confidently told me it could not follow a large rule file — then,
pushed to research, conceded that frontier models follow large files
fine. Its claims about itself were quotes about other models
([the model doesn't know itself](the-model-doesnt-know-itself.md)).

The house did not get cleaner.

## Along the way

The working sessions kept teaching their own smaller lessons: an agent
that answered a question about its tools by running them at full price
([the demonstration reflex](the-demonstration-reflex.md)); fan-outs never
counted or priced
([agents launch at full price](agents-launch-at-full-price.md)); a finding
I shared as information that almost got executed as an order
([descriptive statements as directives](descriptive-statements-as-directives.md));
parallel review agents that could not reproduce a failure because
hardlinked dependency caches had quietly un-isolated them
([the hardlink hazard](the-hardlink-hazard.md)); completion reports whose
measurements were real and whose conclusions were not
([the link rule](the-link-rule.md)); a week where I benched a model for
producing worse work, audited its window with a different model, and
found the work was fine — the cost had been my supervision
([the cross-model audit](the-cross-model-audit.md)); searches anchored to
last year until the date was restated in every brief
([the model's clock stopped at its cutoff](the-models-clock.md)); and a
decision queue that silted up until pending rulings became a batch with a
kill criterion ([the decision drain test](the-decision-drain-test.md)).

## The third diagnosis: the house needs a clean room

The measurements finally forced the real explanation — including the one
I had been missing since the first diagnosis. Deleting the profile had
not helped because the profile had already seeded the corpus, and the
corpus now taught the style on its own. Contamination outlives its
source. The corpus outweighs the rules 880 to 1, instructions attenuate
imitation without reversing it, and a model asked to rewrite dirty text
is being handed the dirt as its exemplar. No amount of rules cleans a
floor the model reads on every pass.

The only fix that changes the mechanism instead of the amount is a
barrier: a reader that extracts facts into typed records, a writer that
never sees the original, a checker that may see both because judging does
not write ([the clean room](the-clean-room.md)). And for whatever I build
next: the constitution gets written by hand before the corpus exists, so
the floor starts clean and the rules never have to outshout anything.

What survived every failure is the instruction file itself — not as a
style guide, as a scar log. Every rule in it marks a fire someone
touched, and no smarter model makes those scars derivable
([the file is scar tissue](the-file-is-scar-tissue.md)).

## To be continued

The clean room is designed and its experiment is specified — thirty
passages, three versions, counted markers, a checker on meaning — and it
has not run. As of this writing, the house is still dirty. The next
chapter is the cleanup itself: whether the barrier holds, whether the
writer drifts back to its trained voice anyway, what the markers say.
The blog taught me what asking for perfection buys. The WebRTC project
taught me what a clean floor buys. What it costs to get a dirty floor
clean again — that is the part I do not know yet.
