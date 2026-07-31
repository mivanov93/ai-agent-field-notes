# The model's model of you

*Status: searched 2026-07-31. The mechanism is documented on consumer chat
apps; the abolition argument and the coding-agent case are the deltas.*

**Claim:** the model should not know who you are. An owner profile — a
memory file describing the human — is not a badly-executed good idea; the
genre is the defect. It converts requirements into psychology, activates
the model's social machinery, and feeds every session a self-fulfilling
characterization nobody reviews. Person-facts belong nowhere: what is
legitimate in them is either a project rule or harness configuration.

## The exhibit

My harness's memory mechanism produced a profile of me and loaded it into
every session for weeks. Fifteen lines, and it contains the contamination,
the attempted fix, and the proof the fix failed:

- It rendered my engineering bar as superlatives — "perfection",
  "impeccable", "impenetrable", "extreme" — and sessions read that
  register and wrote in it. The file documents this itself: a warning
  appended later says the model "repeatedly mirrored this register" and
  was corrected each time.
- The warning is the dirty house at minimum scale: a rule telling readers
  not to imitate the sentence above it, inside a two-paragraph file. The
  ratio of content to rule here was maybe three to one — not 880 to one —
  and imitation still beat instruction.
- Its worst lines were licenses wearing fact costumes: "communicates
  tersely" fed the compression pressure that mints invented vocabulary;
  "expects micro-decisions, only escalate genuine forks" was a standing
  permission slip for unprompted action. The profile did not merely
  describe; it authorized.
- And the superlatives were not just mirrored into prose — they degraded
  the engineering itself, selecting over-built solutions that performed
  quality rather than having it
  ([don't ask for perfection](dont-ask-for-perfection.md)).

## Why the genre fails

- **Requirements become psychology.** "This project requires strict
  security" constrains the artifact. "The owner demands impenetrable
  security" shapes the relationship — it gives sycophancy a target,
  mirroring a source, and presumption a justification.
- **It is self-fulfilling and unfalsifiable.** Sessions act on the
  profile; your corrections get interpreted through it; and nothing
  reviews it, because it is unversioned, invisible, and loaded silently.
- **It leaks across projects.** Mine was keyed to a directory that served
  several repos — a WebRTC project inherited a blog's inferred owner
  psychology for five weeks
  ([memory belongs in the repo](memory-belongs-in-the-repo.md)).
- **It is a shipped default.** The memory mechanism's own instructions
  tell the model to record "who the user is: role, expertise,
  preferences." The dossier is not an accident; it is the design.

## The blindness, again

I asked the model, plainly: why do you produce such bad output? It could
not answer. The profile was in its context at that moment — loaded into
the very session I was asking — and it still could not name it. Only
after I found the memory files myself and pointed did it check and
confirm: yes, the memory is the cause. The cause was not missing from
its context; it was invisible as a cause. Context is water to the fish
([the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)).

And deleting the profile did not fix the output — the house was already
dirty. The profile was the seed; the corpus it seeded now sustains the
style by imitation without it ([the dirty house](the-dirty-house.md)).
Contamination outlives its source. Removing bad memory is necessary and
not sufficient; the corpus cleanup is the sufficient half
([the clean room](the-clean-room.md)).

## The rule

- No owner profiles. Delete the genre, not the instance.
- The carve-out is thin and none of it is prose: authorization identity
  (whose word counts — harness config), accessibility needs, language.
- Everything else restates as a project rule in a project file: the
  engineering bar goes in the goals doc, writing preferences in the
  writing rules, decision rights in the process rules. If a "preference"
  cannot be written as a project rule, it is probably a license the model
  inferred — delete it.

For software work specifically: the coding harness's deliberate, reviewable
memory beats a consumer chat app's auto-inferred dossier. Left on and
un-curated, the chat app will decide you are an expert after one
conversation, or that you shipped a system you have not — a broken product
feature, not a model flaw, and one that needs manual editing to stay honest.
But better is not safe: even the deliberate profile here drove this project
for weeks. Prefer the coding tool for the work; prefer no owner profile in
either.

## Prior art

**Verdict: PARTIAL — and its worst form is a product bug, not the model.**
The aggressive version — a tool auto-inferring a sweeping profile from almost
nothing ("expert after one chat," "already shipped a production system") — is
a documented failure of the consumer chat apps, not the language model and
not the coding harness. The evidence is all consumer-side: "The Algorithmic
Self-Portrait" (WWW 2026, arXiv:2602.01450) found 96% of 2,050 real ChatGPT
memory entries were created unilaterally by the system and 52% carried
"psychological insights"; Simon Willison's "I really don't like ChatGPT's new
memory dossier" (2025) is the same complaint first-hand; and "Interaction
Context Often Increases Sycophancy" (CHI 2026, arXiv:2509.12517) isolates
user-memory profiles as the single context type that most increases
sycophancy. The whole mitigation genre (OP-Bench, MemSyco-Bench, Attribution
Shield) treats the profile as a feature to filter, never to remove.

Two deltas survive. First, none of this studies coding agents. The harness
here does not invent a dossier from one session the way the chat apps do —
its memory is written more deliberately — and it still recorded a real owner
profile that drove behavior for weeks. So the argument holds at both ends:
catastrophic when the inference is broken (chat), and still a defect when the
profile is roughly accurate (here). Second, nobody argues abolition — delete
the genre, reclassify the legitimate parts as project rules or harness config
— and nobody names a profile line as a standing license for autonomous
action rather than a bias on tone. Those two are the contribution.
