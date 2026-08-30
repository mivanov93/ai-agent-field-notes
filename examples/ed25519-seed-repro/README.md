# Ed25519 seed loading — reproduction

Evidence for a field note in progress: a signing key loaded by taking
the first 32 bytes of a file as an Ed25519 seed, with no check that the
file is a seed. The write-up will explain what the result means and
link back here; this file is just how to run it.

```bash
./run.sh
```

`run.sh` generates two independent Ed25519 PEMs with `openssl`, then
runs `main.go`, which loads each the way the reviewed code does and
prints what comes out. Needs `go` and `openssl` on PATH. Under a
second; no persistent state.

## What it shows

- Any 32+ bytes are accepted as a seed — the loader checks length and
  nothing else. A text file and an image both load into valid keys.
- Every Ed25519 PEM begins with the same 32 bytes (the `-----BEGIN
  PRIVATE KEY-----` header plus four more), so the loader throws away
  the actual key material and keeps only the constant header. Two
  independently generated PEMs produce the identical public key
  `gPuUGrOwqAlvxAzQ8eroZm-6qKILFxwkofZZrvstTCA`.
- A party holding only that public constant — no access to any key
  file — reconstructs the same keypair and mints a token the server's
  own public key accepts.

The code under study is stdlib Go, and so is the repro. There is no JWT
library in it: the token signer is fifteen lines, so nothing hides the
mechanism behind a dependency.

## Why every PEM gives the same 32 bytes

The loader keeps the first 32 bytes of the file. For a PEM those bytes
are the header line, a newline, and the first four characters of the
base64 body: `-----BEGIN PRIVATE KEY-----\nMC4C`. The header is a
constant string. The four base64 characters are constant too, and here
is why.

Base64 encodes three bytes at a time into four characters, so `MC4C`
encodes the first three bytes of the key's DER structure. For Ed25519
those three bytes are always `30 2e 02`:

- `30` — the tag for a DER SEQUENCE. Every PKCS#8 key opens with one.
- `2e` — its length, 46 bytes. Ed25519's structure is fixed-size, so
  this length never varies. An RSA key, whose size differs, would carry
  a different byte here — which is why the trick is specific to
  Ed25519.
- `02` — the tag for the INTEGER holding the version field, always next
  and always zero.

So the first three DER bytes are identical across all Ed25519 PEMs,
their base64 is always `MC4C`, and the header in front of them is a
constant. One more coincidence makes the cut land cleanly: the header
plus its newline is 28 characters, a multiple of 4, so the base64 body
starts on a clean boundary and 28 + `MC4C` is exactly 32.

The actual secret — 32 random bytes — sits further down, in the `04 20`
octet string the loader never reaches. The bytes it keeps carry none
of the key; they only announce "this is an Ed25519 key."

## Who it affects, and how to check

This only matters for a server that holds and loads its own signing
key. The shape of the deployment decides everything:

- **Empty key path** — the server generates a random key in memory each
  boot. Fine; this is the safe default.
- **You verify tokens against someone else's keys** — a hosted identity
  provider, an external JWKS endpoint you only read from. You never
  touch raw key bytes, so this cannot reach you. You are a consumer.
- **You set the key path to a PEM, because you publish your own keys and
  want them stable across restarts** — this is the case that breaks.
  You are the issuer; you are the JWKS.

And because the resulting public key is a single constant, the state is
visible with no access to the machine at all. A server publishes its
public key at `/.well-known/jwks.json`. If the key was loaded from a
PEM this way, that endpoint carries the fixed values

```
"x":   "gPuUGrOwqAlvxAzQ8eroZm-6qKILFxwkofZZrvstTCA"
"kid": "AWQCKGIfhbq7OJJajdV4aOy_bapShcBofZNOx2tAsaM"
```

`x` is the public key; `kid` is its RFC 7638 thumbprint — both are
deterministic, so both are constants when the key is the shared one.
That makes it a one-line self-check on your own `jwks.json` — and,
equally, something anyone can read off the same public endpoint without
touching your server. A signing key whose public half is a known
constant is a key everyone already has.

## Cost and cleanup

The generated files (`k1.pem`, `k2.pem`, `arb*.bin`) are gitignored,
land in this folder, and are overwritten each run — delete them any
time. Nothing installs, nothing persists elsewhere.
