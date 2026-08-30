#!/usr/bin/env bash
# Generate two independent Ed25519 PEMs the way an operator would, then run the
# loader against them. Needs `go` and `openssl` on PATH. Under a second; the
# only state it leaves is gitignored files in this folder.
set -euo pipefail
cd "$(dirname "$0")"

openssl genpkey -algorithm ed25519 -out k1.pem 2>/dev/null
openssl genpkey -algorithm ed25519 -out k2.pem 2>/dev/null

go run .
