# The tools you never use

*Written 2026-07-31.*

**Claim:** every tool, plugin, and integration you connect to an agent
costs something on every session — context space, startup time, a longer
menu the model has to read before it can begin — whether or not it is ever
used. Left unmanaged, most of them are never used, and you pay for all of
them anyway.

## The incident

I counted the tool calls across a month of one project. Of 11,669 calls,
0.6% went to connected tool-servers, and only three servers were ever
touched at all. Around fifteen more — a legal pack, a database integration,
two source-host integrations for a repo that has no remote, several
language servers for languages the project does not use — were loaded on
every single session and called zero times. Each still added to startup, to
sign-in noise, and to the list the model reads before starting work.

This runs exactly opposite to the direction that helped elsewhere: the
model's vendor removed most of the agent's built-in preamble with no loss,
because less to read helped. Meanwhile the project was loading a large menu,
almost none of which it needed.

## The rule

Treat the connected-tool list as something you curate per project, not a
pile you accumulate. Turn off the packs this project has no use for. The
test is empirical: look at what actually got called over real sessions — that
count comes straight out of [the session archive](the-session-archive.md), the
same record the other measurements here run on — and disconnect the rest. This
is a different question than mining the archive for a model regression: same
instrument, you are just asking what you loaded and never called.

## Prior art

**Verdict: PARTIAL** — phenomenon and fix are KNOWN, even productized; the
measurement and framing are the delta. Audit tools already prune by call
count: unclog (2026) flags MCP servers uncalled in 30 days as "paying schema
rent for nothing"; mcp-tidy does the same. The costs are measured: Scott
Spence and EclipseSource (2025–26) report tool definitions eating tens of
thousands of tokens before work starts, and RAG-MCP (arXiv:2505.03275) shows
tool-selection accuracy collapsing with too many tools. The vendor-direction
source is Anthropic's context-engineering post (2026-07-24): "removed over
80% of Claude Code's system prompt … with no measurable loss." The delta: the
specific measurement (0.6% of 11,669 calls used a server; ~15 loaded and
never called) and the framing as the local inversion of that 80% trim — the
same logic one layer down, at the tool-server layer.
