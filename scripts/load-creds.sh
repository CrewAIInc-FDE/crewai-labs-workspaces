#!/usr/bin/env bash
# Load workshop credentials into the codespace at lab time.
#
# Keys are NEVER baked into the image. At the workshop you get a creds file
# (OPENAI_API_KEY=... and any others) either as a URL on your handout or as
# text to paste. This script writes it to the repo root as crewai-creds.env,
# which you then `source` to load the variables into your shell AND any program
# you launch from it (crewai, python, ...).
#
# Run it with bash directly (no chmod needed) — from anywhere in the repo:
#
#   # Option A — fetch from a URL (on your handout / the screen):
#   CURL_URL='https://example.com/workshop/creds.env' bash scripts/load-creds.sh
#
#   # Option B — paste the file in: run with no URL, paste, then Ctrl-D:
#   bash scripts/load-creds.sh
#
#   # Option C — point at a file you already saved:
#   bash scripts/load-creds.sh path/to/creds.env
#
# Then, in THIS terminal (and any new one), load the vars:
#
#   source crewai-creds.env
#
# The file is written to the repo root and is git-ignored — do not commit it.
set -euo pipefail

# Always write to the repo root, regardless of the directory this is run from.
# load-creds.sh lives in scripts/, so the repo root is its parent's parent.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="$REPO_ROOT/crewai-creds.env"

RAW="$(mktemp)"
trap 'rm -f "$RAW"' EXIT

if [[ -n "${CURL_URL:-}" ]]; then
  echo "==> Fetching credentials from CURL_URL"
  curl -fsSL "$CURL_URL" -o "$RAW"
elif [[ "${1:-}" != "" ]]; then
  echo "==> Copying credentials from $1"
  cp "$1" "$RAW"
else
  echo "==> Paste your creds file (KEY=value per line), then press Ctrl-D:"
  cat > "$RAW"
fi

if [[ ! -s "$RAW" ]]; then
  echo "error: no credentials provided — nothing written." >&2
  exit 1
fi

# Normalize into an export-able env file. A plain `KEY=value` line, when sourced,
# sets a *shell* variable that is NOT exported — so child processes (crewai,
# python) never see it. Prefixing `export` fixes that. Comments and blank lines
# pass through untouched; lines that already say `export` are kept as-is.
: > "$OUT"
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ -z "${line//[[:space:]]/}" || "$line" =~ ^[[:space:]]*# ]]; then
    printf '%s\n' "$line" >> "$OUT"                       # blank / comment
  elif [[ "$line" =~ ^[[:space:]]*export[[:space:]] ]]; then
    printf '%s\n' "$line" >> "$OUT"                       # already exported
  elif [[ "$line" =~ ^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*= ]]; then
    printf 'export %s\n' "$line" >> "$OUT"                # KEY=value -> export KEY=value
  else
    printf '%s\n' "$line" >> "$OUT"                       # leave anything else alone
  fi
done < "$RAW"

# Make sure we never commit secrets (entry is the bare filename at the repo root).
if [[ -d "$REPO_ROOT/.git" ]] && ! grep -qxF "crewai-creds.env" "$REPO_ROOT/.gitignore" 2>/dev/null; then
  echo "crewai-creds.env" >> "$REPO_ROOT/.gitignore"
  echo "==> Added crewai-creds.env to .gitignore"
fi

KEYS=$(grep -cE '^[[:space:]]*(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*=' "$OUT" || true)
echo "==> Wrote $OUT ($KEYS variable(s)). Now run:"
echo
echo "    source crewai-creds.env"
echo
echo "    (run that once per terminal; it exports the keys to crewai/python too)"
