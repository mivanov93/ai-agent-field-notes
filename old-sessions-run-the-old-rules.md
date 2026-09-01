# Old sessions run the old rules

*Written 2026-09-01.*

*Scope: Claude Code, 2026-09. Harness behavior — CLAUDE.md load timing —
so re-measure before assuming it holds for your version; harnesses
change. Confirmed against the Claude Code docs and demonstrated in the
session that wrote it.*

**Claim:** Claude Code reads CLAUDE.md once, at session start, and holds
that copy for the life of the session. Edit the file mid-session — add a
rule, a check, a defense — and the running session does not pick it up;
it keeps operating on the version it loaded when it began. So every
session that was open before you added a rule runs without it. This is
most dangerous for defenses: you patch a hole in CLAUDE.md, the file now
says the right thing, and every already-open session is still unpatched.
A rule protects only the sessions born after it.

## The incident

I confirmed the mechanism and then watched it happen to me. Claude Code
loads the project and user CLAUDE.md at session start and keeps them in
memory; editing them mid-session does not apply until the next `/clear`,
`/compact`, or restart. There is no reload command, no file-watch, and
no `@`-reference that pulls an edit in. (Nested and `paths:`-scoped rule
files are the one exception — they load lazily, when a matching file is
first read, so an edit made *before* that load takes effect; after, they
freeze like the rest.)

The demonstration wrote itself. Earlier in this same session I added
four web-safety rules to my user CLAUDE.md — the session-delegates and
no-shell-for-readers rules from [the fetcher shouldn't have a
shell](the-fetcher-shouldnt-have-a-shell.md). The copy of that file this
session loaded at start still shows only the sections that predate them.
The rules are on disk; they are not in this session's instructions. I
am, right now, an old session running the old rules — I know the new
ones only because I typed them into the conversation, not because the
file reached me.

## Why it is worse than it looks

The trap is about security, and about timing. The moment you add a
defense is the moment your open sessions turn stale — and the sessions
that were open when you found a hole are exactly the ones most likely to
still be doing the dangerous thing, because they are the ones that were
doing it when you noticed. Hardening the file is not hardening the
running sessions. You feel safer the instant you save CLAUDE.md, and the
feeling is wrong for every session already running.

It compounds with anything that makes a session worth keeping open — a
warm cache, a long context, work in flight. The longer a session lives,
the more rules it has missed, and the further its loaded instructions
drift from the file everyone else now reads.

## The rule

- **After you add a defense or a check to CLAUDE.md, restart the sessions
  that should have it.** Do not trust a session older than the rule to be
  following it; `/clear` or `/compact` also reload the file if you cannot
  restart.
- **Treat "when did this session start?" as a security-relevant fact.** A
  session older than your latest rule is running without it, silently.
- **To make a new rule apply *now*, say it in the live session too, not
  only in the file.** The conversation is in context; the freshly-edited
  file is not. The file reaches the next session; the sentence reaches
  this one. This is the inverse of [the rule you don't need
  yet](the-rule-you-dont-need-yet.md): there a ruling lived only in chat
  and never reached the file; here it lives only in the file and never
  reached the running chat.
- **Prefer short sessions for anything security-sensitive.** A long-lived
  session accumulates staleness against a file that keeps improving.

## Prior art

**Verdict: PARTIAL — mechanism verified 2026-09-01** (against the doc, by
a scoped fetch of Anthropic's own hosts). The behavior is Claude Code's
documented design, not a quirk: its prompt-caching page states that the
project- and user-level CLAUDE.md are "read once at session start and
held in memory," that "editing them mid-session does not invalidate the
cache, but the edit also doesn't apply," and that "the new content loads
on the next `/clear`, `/compact`, or restart"
(code.claude.com/docs/en/prompt-caching). So the mechanism is KNOWN and
vendor-documented. What this note adds is the security framing: that
adding a defense to the instruction file leaves every open session
unprotected, and that the sessions most likely to be unsafe are the ones
least likely to carry the new rule. Adjacent notes: [the classifier reads the
costume](the-classifier-reads-the-costume.md) (restart clean; the old
session is the liability), [memory belongs in the
repo](memory-belongs-in-the-repo.md) (the file is the channel to
sessions — but only at load time), and [the rule you don't need
yet](the-rule-you-dont-need-yet.md) (chat-only rulings versus file-only
rulings).
