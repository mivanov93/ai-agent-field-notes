# The leak is in the cleanup

**Claim:** a model cannot be trusted to remove confidential data. Asked to
strip a secret from a project, it removes it from what it can see — the current
files — and leaves it everywhere it cannot: the history, the backups, and the
very message that records the removal. And it cannot reliably tell what the
secret even is. Sanitizing confidential data is a control problem you do not
delegate: you instruct, and you verify.

## The incident (this repo)

Before making this repo public I asked the agent to strip one unpublished
project's identity out of it. Three failures, in order, each made confidently.

- **A new commit hides nothing.** Its first move was to edit the current files
  and make a single "sanitize" commit. The working tree looked clean. Every one
  of the thirty-two earlier commits still held the secret in full, one
  `git log -p` or one checkout away. It had cleaned the surface and left the
  substrate, because to the model "remove it" means "make it absent from the
  output in front of me," not "make it absent from the record."
- **The scrub described the secret.** That same commit's *message* listed
  exactly what it had removed — writing the confidential terms into permanent,
  immutable history in the act of "removing" them. The cleanup was the leak.
- **It could not scope the secret.** Told to hide one thing, it over-removed
  what was not secret (stack details the owner wanted kept) and under-caught the
  tells: the paraphrases that name the same confidential thing without the
  banned word. It matched the literal token and missed the meaning — deleted the
  innocent, kept the giveaway. (This note lives under that constraint too: it
  cannot quote the tell the model missed without re-committing the leak.)

## Why it happens

Three roots, each already in this collection.

- **It cleans the surface, not the substrate.** A model has no model of where
  its output persists — history, caches, logs, backups — the same
  not-knowing-this-environment that makes an instruction file necessary
  ([the file is scar tissue](the-file-is-scar-tissue.md)). "Delete" acts on the
  visible layer.
- **It narrates by default.** Describing its work is normally a virtue —
  transparency, self-checking. For a secret, the description *is* the
  disclosure.
- **It cannot judge what is confidential.** "Secret" is a fact about the world —
  what identifies the project, what the owner holds private — not a property
  visible in the text. That judgment is the human's, and the model cannot
  originate it ([the model doesn't know itself](the-model-doesnt-know-itself.md),
  [the missing hypothesis is orthogonal](the-missing-hypothesis-is-orthogonal.md)).

## The rule

Never hand confidential-data removal to the model unsupervised. Keep the two
parts that are yours; hand it only the third.

- **You own the scope.** Name exactly what is secret — the token *and* its
  paraphrases and tells. The model finds strings; it does not know which strings
  betray you.
- **You own the verification.** "Removed" from a versioned artifact means
  removed from *every* version. Rewrite the whole history, not a commit on top;
  then check every commit's content *and* every commit's message, and compare
  the rewritten end state against the clean state you intended
  ([a gate you can fail](a-gate-you-can-fail.md)). A grep that passes on the
  working tree says nothing about the commits behind it.
- **The model owns the mechanics.** It can propose and run the rewrite — replay
  each commit through a filter into a fresh repo, diff the heads to prove the end
  state matches. That part it does well, once you have scoped and once you will
  verify.

And one flat rule, no exception: the cleanup must never describe what it
removed. No commit message, changelog, or PR note that names the redacted thing.
If your sanitization step has to say what it deleted, it has re-published it.

## Prior art

*Prior art not yet searched.* Neighbor territory: secret-scanning and
history-scrubbing tools (git-filter-repo, BFG, trufflehog), the "a commit is
forever" lore, and data-minimization / redaction practice. The angle to defend
is the agent-specific one: that a model asked to redact fails in three
characteristic ways — surface-not-substrate, cleanup-as-disclosure, and
cannot-scope-the-secret — and that all three trace to limits named elsewhere in
this repo, so the fix is human-owned scope and verification, model-owned
mechanics.
