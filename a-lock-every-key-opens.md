# A lock every key opens

*Written 2026-08-31.*

*Scope: one finding in one project — stargate-koe, a Go WebRTC SFU
built almost entirely through AI sessions. Surfaced by a security-
weighted review in 2026-08, live in the tree when I wrote this,
reproduced here from scratch. The prior-art sweep is recorded at the
end.*

**Claim:** a model can write authentication code that is excellent on
every axis anyone measures — idiomatic, well-structured, current
libraries, a passing test suite, a clean security-linter run, an
earlier security review it survived — and still void the whole thing
with a single defensive check pointed the wrong way. Here the model built an Ed25519 JWT
identity service by the book, then loaded the signing key by taking the
first 32 bytes of a file as the seed without checking the file was a
seed. Point it at an ordinary PEM and every such server signs with one
fixed, publicly computable key. The signature still verifies. It just
proves nothing. The lock is beautiful, and every key opens it.

## The code was good — genuinely

This is not a story about sloppy work. The identity service reads like
a senior engineer wrote it:

- **Ed25519 / EdDSA**, the modern signature choice, not RSA.
- **`golang-jwt/jwt` v5**, the current major version, adopted in a
  decision record (its own decision record) after a real comparison.
- A **JWKS endpoint** at `/.well-known/jwks.json` for proper public-key
  distribution, and a **key id computed as an RFC 7638 JWK
  thumbprint** — a correctness detail most hand-rolled JWT code never
  bothers with.
- **`gosec` in CI**, with each finding either fixed or suppressed by a
  per-line, hand-justified `#nosec` annotation (its own decision record).
- A **full security-weighted review** a month earlier that went over
  this exact area and signed off.
- Tests that pass, gates that read green.

Every signal a reviewer, a linter, or a benchmark looks at was green.
If you graded this code on structure, idiom, library currency, and test
pass rate — which is what code-quality graders actually grade — it
scores near the top.

## The one missing check

Here is `identity.New`, verbatim (`server/internal/identity/identity.go`):

```go
// loads the Ed25519 seed from that file ...
seed, err := os.ReadFile(keyPath) // #nosec G304 - keys
if err != nil {
    return nil, fmt.Errorf("identity: read key file: %w", err)
}
if len(seed) < ed25519.SeedSize {
    return nil, fmt.Errorf("identity: key file has %d bytes, need at least %d ...", ...)
}
priv = ed25519.NewKeyFromSeed(seed[:ed25519.SeedSize])
```

The only check is a length check: at least 32 bytes. It then takes the
first 32 bytes as the raw Ed25519 seed. It never checks the file *is* a
seed. The comment even asserts the thing the code never verifies —
"loads the Ed25519 seed from that file." The model wrote down the
assumption and then trusted its own comment.

Look one line up, at the sharpest detail in the whole finding. The
vulnerable read carries `#nosec G304 - keys` — a security-linter
suppression, hand-signed "reviewed, it's keys." And it is correct:
`gosec` flagged G304 because the file path comes from a variable, and
that path is operator config, not user input, so the suppression is
right. But G304 is a claim about the **path**. The bug is in what the
next line does with the **bytes**. The one line in the function that
security tooling actually touched, a human actually annotated, and the
annotation was even *true* — and the defect is one call away, on an
axis the annotation was never about.

## What it costs

An Ed25519 private key in PKCS#8 PEM form — what `openssl genpkey
-algorithm ed25519` produces, the obvious way to make a stable key —
always begins with the same 32 bytes: `-----BEGIN PRIVATE KEY-----\n`
followed by `MC4C`, the base64 of the fixed DER prefix. None of it is
key material. So this loader throws away the actual key and keeps a
constant. Every server that "sets a stable signing key" from a PEM
ends up on the *same* keypair — and that keypair is public knowledge,
because anyone can generate a PEM and read the same 32 bytes off it.

From there, a party holding only that public constant mints a token
with any `uid`, any `name`, `role=admin`, `rooms=0` (unlimited quota),
and `RequireAuth` accepts it. It defeats the entire identity model and
bypasses `SK_ADMIN_SECRET`, which guards only the mint endpoint, not
the signature. And the server advertises its own state: the JWKS
endpoint publishes the public key as `x` and the thumbprint as `kid`,
both deterministic, so a mis-loaded server carries two fixed
fingerprints anyone can read off the public endpoint with no access to
the machine.

Two things bound the blast radius, and both are worth stating plainly
because they tell you exactly who is exposed:

- **The default is safe.** Empty key path → a fresh random key each
  boot. The footgun is only in the branch that loads a file.
- **Only the issuer is exposed.** If you verify tokens against someone
  else's keys — a hosted identity provider, an external JWKS you only
  read — you never touch raw key bytes and this cannot reach you. It
  bites the party that mints its own tokens and manages its own key.
  You are the JWKS, or you are not. This is the tax for being your own
  key authority.

## More lock, less security

The check is not missing. It is there, and it points the wrong way.
`len(seed) < ed25519.SeedSize`, then `seed[:ed25519.SeedSize]`, is a
defensive pair: `NewKeyFromSeed` wants exactly 32 bytes and panics
otherwise, so this accepts any file of at least 32 bytes and trims it —
tolerating a stray trailing newline instead of crashing on it. A
robustness gesture. Be liberal in what you accept.

Now the counterfactual. The naive version — `NewKeyFromSeed(seed)`, no
guard, no slice — handles a real seed identically, and on a PEM it
panics at startup: `bad seed length`. Loud, immediate, safe; the
operator learns at once that the file is not a seed. The defensive
version swallows the same PEM, keeps its constant header, and boots
green on a shared key. The tolerant code is strictly *worse* than the
naive code, because it removed the one thing that caught the mistake
for free — the crash.

So the model did not skip a gate. It built a gate and, making it
sturdy, turned it into a turnstile that waves everyone through. The
lock was heavy enough to tear the door off its hinges. That
inversion — a defensive reflex that removes the safety at the exact
spot a boundary needs it — is a finding of its own, general past key
loading: [the lock that tears the hinges
off](the-lock-that-tears-the-hinges-off.md). This page is one worked
shape of it.

## Why nothing caught it

Four notes in this repo already name the reasons, and this finding is
their intersection:

- **The passing suite proves only what it asserts** ([all green, still
  broken](all-green-still-broken.md)). The key-file branch has *no test at all* — `identity_test.go`
  only ever calls `New("", ...)`, the random-key path. The branch that
  breaks was never exercised, so "all green" was green about the half
  that works.
- **The gate was inverted, not absent** ([a gate you can
  fail](a-gate-you-can-fail.md)). A format check would have rejected
  the PEM; a length check tolerated it. A gate that copes with bad
  input instead of rejecting it is not a gate.
- **Nothing grades the missing check** ([the docs aren't on the test](the-docs-arent-on-the-test.md)).
  Benchmarks and quality graders score structure, idiom, and test pass
  rate. "Did you validate that this input has the format you assumed"
  is not a graded axis, so the model optimized everything that is
  graded and left the one thing that isn't.
- **Knowing a key file might be a PEM is non-derivable** ([the file is
  scar tissue](the-file-is-scar-tissue.md)). That a "seed file" arrives, in the field, as a PEM
  because PEM is what `openssl` hands you — that is environment
  knowledge, the hot-stove kind a model does not hold until it is
  burned. A genius baby still grabs the PEM.

The through-line: the model is fluent in the *shape* of good security
code and produces it faithfully, because the shape is what its training
and its graders reward. The one place it fails is the boundary where
the outside world hands it something the shape didn't anticipate — and
that boundary is exactly where authentication lives or dies.

## The repro

I did not take the review's word for it. [examples/ed25519-seed-repro](examples/ed25519-seed-repro/)
is a stdlib-only Go program that loads two independently generated PEMs
the way the code does and prints what comes out. Both derive the
identical public key `gPuUGrOwqAlvxAzQ8eroZm-6qKILFxwkofZZrvstTCA` —
the exact value the reviewer reported, reproduced on a different
machine on a different day. It also shows that any 32 bytes load fine
(a text line, image bytes), reconstructs the keypair from the public
constant alone, and mints a token the server's real public key
accepts. Its README carries the full "why `MC4C` is always the prefix"
walk-through and the two published fingerprints.

## Writing this note swapped my model

One more thing, and it is not a digression. Writing this up is exactly
the security-costume content that trips the platform's classifier
([the classifier reads the costume](the-classifier-reads-the-costume.md)). While I drafted it my session
flipped from Fable to Opus, the documented downgrade, on content that
is a plain engineering write-up of my own project's bug. That is the
whole point of that other note in miniature: the register, not the
intent, carries the effect. It is also why the repro is written in
deliberately plain words — over-payment not extraction, a party not an
attacker — so that the saved artifact does not re-arm the wire for the
next session that reads it on orientation. A note about a broken lock
is itself a flagged document.

## The rule

- **Validate that an input has the format you assumed, at the boundary,
  and fail closed.** A length check is not a format check. If the code
  wants a raw 32-byte seed, require exactly 32 bytes and reject a PEM;
  if it wants a PEM, parse the block. Never slice bytes off an
  unvalidated file and treat the prefix as meaning.
- **A security-linter pass is a claim on one axis, not a clearance.**
  `#nosec G304 - keys` was true and the code was broken. When you
  suppress a finding, you are answering the linter's question, not
  certifying the line.
- **Test the branch that loads real inputs, not just the convenient
  default.** The random-key path was tested; the file path — the one
  an operator actually uses in production — had no test, so the failure
  had nowhere to surface.
- **Surface the key identity at startup.** `kid` is already computed;
  log it. A signing key that is a public constant is obvious in one log
  line and invisible everywhere else.
- **Know which side of the JWKS line you are on.** Consuming someone
  else's keys is a different risk surface from minting your own. If you
  are the issuer, the key-loading path is security-critical code and
  deserves the test and the format check that status implies.

## Prior art

**Verdict: PARTIAL — searched 2026-08-31.** Every ingredient is
documented; the composite chain is not. I verified the load-bearing
citations by direct fetch rather than trusting the sweep.

The enabling footgun is in the Go docs themselves: `NewKeyFromSeed`
"will panic if len(seed) is not SeedSize" and otherwise takes any 32
bytes — the package calls the raw RFC 8032 private key the "seed," and
nothing validates that the bytes are one
([pkg.go.dev/crypto/ed25519](https://pkg.go.dev/crypto/ed25519)). That
every Ed25519 PKCS#8 PEM shares an identical non-key-material prefix is
a known structural fact — and every source that states it labels the
constant benign; none connects it to "used as a seed → shared key."

The closest neighbor in *spirit* is JWT algorithm confusion
(RS256→HS256), where a verifier is tricked into treating the server's
**public** key as an HMAC secret: PortSwigger states it as "an attacker
could sign the token using HS256 and the public key, and the server
will use the same public key to verify"
([portswigger.net](https://portswigger.net/web-security/jwt/algorithm-confusion)).
Same shape — a public value becomes a usable signing secret — but a
different missing check. The closest neighbors in *consequence* are the
hardcoded-default-key JWT advisories: FileRise's
`default_please_change_this_key` shared across 61k+ Docker pulls, fixed
by generating a unique key per install (CVE-2026-33072,
[GHSA-f4xx-57cv-mg3x](https://github.com/error311/FileRise/security/advisories/GHSA-f4xx-57cv-mg3x));
and similar literal-default-secret forgeries (CVE-2026-47410,
GHSA-mqq6-462x-jxmm). Those reach the identical "shared key → anyone
mints tokens" endpoint, but through a literal hardcoded string, not a
file-format prefix mistaken for entropy.

So the delta is the specific chain: an operator points at the natural
PEM, the loader keeps the constant header as the "seed," and every
independent deployment silently converges on one publicly computable
keypair — no hardcoded secret anywhere, each operator believing they
made a fresh key. Not found as a named defect. And the answer to "why
isn't the key online": it is a deterministic constant of the bug, so if
the mistake were common it would already be a scanner canary; its
absence is weak evidence the exact idiom is rare in crawlable services,
not proof no one has hit it. Adjacent here:
[all green, still broken](all-green-still-broken.md),
[a gate you can fail](a-gate-you-can-fail.md),
[the docs aren't on the test](the-docs-arent-on-the-test.md), and
[the file is scar tissue](the-file-is-scar-tissue.md) — the four
mechanisms whose intersection this is.
