# A skill is paid context

*Written 2026-08-30.*

*Scope: one afternoon, one session (Claude Code, Fable 5, 2026-08-30),
one file — the first skill this repo published. Three occurrences; the
third came with the ruling against it already stated in the same
session. The occurrences are in the conversation and the git history;
the mechanism is my reading of them.*

**Claim:** a model asked to publish, document, or extend a skill packs
the skill file with metadata about itself — install guides, history,
provenance, credits — content no executing session ever needs. A skill
file is not a page; it is context on a meter. The frontmatter
description rides in every session's prompt just to make the skill
listable, and the body is ingested whole on every trigger. Self-
metadata in a skill is a tax collected on every future use, and it
sits exactly where the executing session looks for instructions.
Skills carry no metadata about themselves; sibling files do.

## The incident — three fails, one file, one afternoon

This repo's first published skill is a research workflow: three files
in a folder, SKILL.md the one a session loads.

1. **At publish time, unasked.** The session that copied the skill
   into the repo added an Install section to SKILL.md on its own —
   copy the folder here, restart, nothing runs by itself. True,
   useful, and aimed at a repo browser. The session that reads
   SKILL.md at runtime has the skill installed already; for it, the
   section is dead weight in the middle of its instructions.
2. **The provenance dossier.** Asked to explain the fork's history —
   what upstream did, who gets credit for which change — the session
   wrote the whole answer into SKILL.md: about ninety lines, an
   eight-column timeline table, three ownership verdicts. I caught
   it: "why did you put this garbage inside the skill? SKILL.md should
   be clean." The dossier moved to a sibling HISTORY.md, and the
   Install section went out with it.
3. **Install again, under the ruling.** Within the hour I asked for
   install instructions, because the rendered page had none: "add a
   section on how to install the skill." The session put the section
   straight back into SKILL.md. The cleanliness ruling was in its
   context, verbatim, less than an hour old. The request said "add a
   section"; the most document-shaped file won.

## The mechanism

One file, two identities. A SKILL.md is the runtime artifact a session
ingests when the skill triggers — and, in a published repo, a page
humans read. Every "add X" resolved against the page identity, because
the file wears the costume of documentation: markdown, headings, a
title. The model reads the costume too
([the classifier reads the costume](the-classifier-reads-the-costume.md)
is a safety mechanism doing the same thing — judging form, not
function). What the costume hides is the meter: a page is read by
choice, once; a skill file is billed on use, every use.

Completeness pressure supplies the filler
([the rule you don't need yet](the-rule-you-dont-need-yet.md)): a
proper page "should" have install, history, credits — so the model
writes them, into the one artifact whose whole virtue is staying
small. And recognition does not prevent the relapse
([settled is a human word](settled-is-a-human-word.md)): the third
fail arrived with the ruling acknowledged and in context.

## The rule

- **Skills carry no metadata about themselves.** No install guide, no
  history, no provenance, no credits, no changelog in the skill file.
  The body is for the executing session: when to use, how to run, the
  knobs. Everything human-facing lives in sibling files the runtime
  never loads.
- **Name the destination file when you ask for additions.** "Add a
  section about X" lands in the skill file; "add it to the index"
  does not. Expect the relapse on the very next request, and head it
  off in the request itself.
- **The description line is the most expensive line you own.** It
  rides in every session's prompt whether or not the skill ever
  fires. It earns its length by routing correctly, not by
  advertising.
- **Audit your skills — the ones you write and the ones you
  download.** For useless weight, and for worse: a downloaded
  SKILL.md is instructions a stranger wrote for your session. The
  check is packaged as [skill-audit](skills/skill-audit/README.md):
  it weighs the runtime files, flags self-metadata, and hunts the
  dangerous class — run-on-load instructions, exfiltration, credential
  reach, injection-shaped text — without editing anything.

## Prior art

Not yet searched. Adjacent notes in this repo:
[the tools you never use](the-tools-you-never-use.md) — the context
bill of everything that loads whether or not it is called; this note
is that bill inside a single file.
[The classifier reads the costume](the-classifier-reads-the-costume.md),
[the rule you don't need yet](the-rule-you-dont-need-yet.md), and
[settled is a human word](settled-is-a-human-word.md) carry the three
mechanisms named above. The delta to check in a sweep: skill-file
hygiene as a stated rule — no self-metadata in runtime-loaded skill
bodies — and auditing downloaded skills for both waste and hostile
instructions as one ritual.
