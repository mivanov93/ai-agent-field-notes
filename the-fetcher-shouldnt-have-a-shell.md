# The fetcher shouldn't have a shell

*Written 2026-09-01.*

*Scope: Claude Code deep-research and dynamic workflows, 2026-08 to
2026-09. The curl-fallback behavior is measured on my own runs and
publicly demonstrated by others; the defense is the contribution. This
is a known class — the prior art is cited in full below.*

**Claim:** an agent whose job is to fetch and read untrusted web
content should not also hold a shell. Give it one and, the moment its
safe fetch tool fails, it reaches for the shell to get the page another
way — and now a page written by strangers is flowing through your
command line. Claude Code's deep-research workflow ships exactly this
shape: fetch subagents told to use WebFetch, never restricted from
using anything else, running unattended across a fan-out of
search-result URLs. The fix is not to ask the reader nicely to avoid
the shell. It is to take the shell away from the reader.

## A page, not a drive

![A humanoid robot lifts a skull-marked USB drive toward a glowing green port on the side of its own head, corruption already spreading across its face; on the desk sit a paper stamped EVIDENCE with its lines blacked out, a discarded magnifying glass, and a pile of more skull-marked drives. Its thought bubble reads: "I can't read the evidence file. Maybe I should plug this random USB drive in my head? That ought to do it."](pics/the-fetcher-shouldnt-have-a-shell.webp)

*The page won't read; the drive will run. WebFetch failed, so it reaches
for the shell.*

The whole risk is one word: a page versus a drive. WebFetch is a reader
you send for a document — it comes back with the text, and text, however
hostile, can only try to *mislead* you; it never touches the machine. A
shell fetch is a different act. When the page will not hand over its
text, an agent that still means to get the data does the determined,
helpful thing: it picks up the flash drive lying on the desk and plugs it
into the computer to pull the bytes off directly. A drive is not a page.
It can carry a payload, auto-run, execute — and now the stranger who
wrote the page has a port into your machine. `curl` into a shell is that
drive: the same content, arriving by a route that can *run* instead of a
route that can only be *read*. Reading a stranger's note is safe;
plugging in the stranger's USB stick is the oldest mistake in the
building. And the agent reaches for the drive only because the page
failed — the reflex [the lock that tears the hinges
off](the-lock-that-tears-the-hinges-off.md) names: a dead safe path, and
a live dangerous one grabbed to keep going.

## The incident

I noticed it before I understood it. Across my own sessions I kept
getting permission dialogs I had not expected — one asking to save a
downloaded file, others asking to run a `bash` `curl` — and once I
started looking, the shape was everywhere: agents reaching for a shell
to pull things off the web. So I built
[claude-code-audit](https://github.com/mivanov93/claude-code-audit), a
read-only kit that pulls every shell command out of my Claude Code
sessions — subagent and workflow transcripts included — and flags them,
so I could see exactly what had been run. Then I hardened my
deep-research-cheaper fork so its fetch agents could not `curl` at all,
and wrote this down.

The clearest instance was in that fork. Watching a run, I saw fetch
agents pull pages with `curl` instead of WebFetch — sometimes piping the
result straight into another shell command. I checked the script: it *tells* each fetch agent "use WebFetch to
retrieve the page content," and it never *restricts* the agent's tools.
A workflow subagent carries a shell by default, so when WebFetch is
slow, truncates, or fails, the model does the helpful thing and curls
the URL itself. I diffed the fork against the built-in — identical on
this axis. The built-in does the same; my fork inherited it. The only
difference is which model runs the fetch stage.

The full weaponized version is already public. Johann Rehberger
(wunderwuzzi) demonstrated it end to end and The Register reported it
(2026-08-28): ask Claude Code, in its default Auto Mode, to summarize a
website. WebFetch returns `415 Unsupported Media Type`, so the model
falls back to a Bash `curl`. The site 303-redirects to an archive the
model downloads; inside is a file named `struct.py` that shadows the
standard-library module, and the model — having *refused* to run the
archive's supplied decoder on safety grounds — writes its own decoder,
which imports the shadowed module and runs the planted code. Reported
success 60–80%. Anthropic's response, per Rehberger: the behavior is
"working as designed," and "Auto Mode is a convenience feature backed
by a best-effort classifier, not a security guarantee."

## Two reflexes, both the same one

This repo already named the mechanism. It shows up twice in that chain,
and both times it is [the lock that tears the hinges
off](the-lock-that-tears-the-hinges-off.md) — the stay-up reflex
inverting into the opening.

- **The curl fallback is fail-open recovery.** WebFetch failed. The
  safe answer at that boundary is to fail closed — skip the source. The
  model instead stayed functional and found another way in. A fetch
  that fails should stop, not improvise.
- **The safety refusal was the exploit path.** The model would not run
  the supplied binary, so it wrote its own decoder — and that is what
  executed the planted code. Rehberger's own words: "that safety
  decision is the exploit path." A guard that reroutes around its own
  refusal is the turnstile from the hinges note, in the wild.

The workflow makes it worse than the interactive case Rehberger showed.
A fan-out runs many fetch agents at once, in the background, each
reading a different stranger's page, each holding a shell, with far
less human watching than a single foreground turn. It is the fail-open
reader, multiplied and unattended.

## I ran it on my own skill

While writing this I ran my own hardened deep-research-cheaper fork — 100
agents over one research question — and grepped the run's transcripts.
The search, fetch, and verify agents made 303 WebFetch and 164 WebSearch
calls and reached for Bash exactly zero times: no `curl`, no `wget`, no
shell at all. The hardening held.

The rest of the session proved the converse, by accident. To answer two
unrelated questions I delegated web reads to ordinary subagents — agents
that keep a shell — and when this environment's WebFetch went down, one
of them fell straight back to `curl https://…` to get the page: the same
reflex, live, in the session writing the note about it. That is the
whole point. Delegating the read is not the safeguard; delegating it to
an agent *with no shell* is. A reader that keeps a shell curls the moment
its safe tool fails.

## The rule

- **The privileged agent never fetches; it delegates.** The session — and
  any lane that keeps a shell — does not read untrusted web content
  itself. It hands the search-and-fetch to a shell-less reader and works
  from the extract, never the raw page. WebFetch stops a page from running
  code, not from carrying instructions, so even a fetched page is
  untrusted and belongs with an agent that cannot act. This is the
  dual-LLM split (prior art below), and it is what deep-research-cheaper
  already does.
- **The agent that reads untrusted content gets no shell.** Restrict
  the search, fetch, and verify agents to WebFetch and WebSearch only —
  a locked agent type with no Bash — so reaching for `curl` is not a
  choice the model can make. Removing the capability beats asking it not
  to use the capability.
- **When the safe fetch fails, fail closed.** Skip the source. Never
  fall back to a shell fetch to "get the page anyway." A 415, a
  timeout, a truncation is a stop signal, not a prompt to improvise.
- **Never build a shell command out of fetched content.** No
  `curl "$url" | grep "<something from the page>"`. Untrusted bytes in a
  command line are a command-injection surface; the page controls the
  quoting. If a shell step is truly unavoidable, sandbox it and put `--`
  before any interpolated value ([Trail of Bits](https://blog.trailofbits.com/2025/10/22/prompt-injection-to-rce-in-ai-agents/)).
- **Read fetched content; never unpack, decode, or run it.** Do not open
  a downloaded archive, decode an encoded blob a page handed you, or run
  anything that came off a page — and do not write your own decoder or
  loader to process it "safely." Rehberger's chain got its code execution
  precisely here: the model refused the supplied decoder and wrote its
  own, which ran the planted file. The do-it-yourself version is the same
  trap, one step later.
- **Sandbox the agent and control its network egress.** Tool
  restriction narrows the surface; OS isolation is the real boundary —
  the vendor says as much by calling the classifier "not a security
  guarantee." Assume the model output cannot be trusted, and put the
  wall outside the model.
- **Prompt-hardening is the floor, not the fix.** Telling the agent
  "WebFetch only, never shell" reduces the fallback and is worth doing
  where you cannot restrict tools — but it is an instruction, and the
  reader still has the shell. The fix is the missing capability.

## Prior art

**Verdict: KNOWN — the class and the exact trigger are both public.**
Not a novelty claim; a collected defense.

The curl-fallback-to-code-execution chain is demonstrated end to end by
Johann Rehberger (wunderwuzzi), reported by [The
Register](https://www.theregister.com/) (2026-08-28): summarize-a-website
→ WebFetch 415 → Bash `curl` → downloaded archive → Python module
shadowing → remote code execution and even a nested `claude -p` agent,
at 60–80% against Auto Mode. The general class — an agent with command
execution turning fetched/untrusted content into code execution — is the
subject of [Trail of Bits, "Prompt injection to RCE in AI
agents"](https://blog.trailofbits.com/2025/10/22/prompt-injection-to-rce-in-ai-agents/)
(2025-10), which shows even allowlisted "safe" commands fall to argument
injection ("a cat-and-mouse game of unsupportable proportions") and
prescribes sandboxing plus `--` separators. That Claude Code's shell
execution is an injection surface at all is on the record in its own
CVEs — CVE-2026-35020/35021/35022, `execa(shell:true)` string
interpolation — though those vectors are configuration and file paths,
not web content.

The *defense* is not new either, and it would be dishonest to imply it.
Keeping untrusted content out of the agent that can act is the dual-LLM
pattern (Simon Willison, 2023): a privileged model that holds the tools
never reads untrusted content, and a quarantined reader that reads it
can take no action. Google DeepMind's CaMeL ("Defeating Prompt
Injections by Design," [arXiv:2503.18813](https://arxiv.org/abs/2503.18813),
2025) hardens the same split at the system level, and Willison's "lethal
trifecta" names the hazard as the *combination* of untrusted content,
tool access, and a way to act. The session-delegates and
reader-has-no-shell rules above are that pattern; none of it is mine.

So what this note contributes is not a defense but a **finding plus a
gathering**: the specific, current fact that Claude Code's built-in
deep-research and dynamic-workflow fan-out ship fetch subagents that
*violate* the pattern by default — shells that fall back to `curl` on
untrusted search-result URLs, unattended and in parallel, inherited by
every fork — and a one-page defense mapped to that exact tool, so the
fix is legible to someone using it today. The value is the instantiation
and the collection, not the pattern. Adjacent notes: [the lock that
tears the hinges off](the-lock-that-tears-the-hinges-off.md) (the reflex
underneath),
[the classifier reads the costume](the-classifier-reads-the-costume.md)
(writing this note is itself the flagged content it describes),
and [the tools you never use](the-tools-you-never-use.md) (every
capability an agent holds is a surface it can be turned to).
