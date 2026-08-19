#!/usr/bin/env bash
# Shown every time a terminal attaches to the codespace.
cat <<'EOF'

  ── CrewAI Workshop — Enrichment Crew ─────────────────────────────────
  Ready to go: uv + the CrewAI CLI are installed. Quick check:

       crewai --version

  Your key: open the workshop email, copy its two lines, and paste them
  into a new  .env  file in this folder. Paste into the FILE (not the
  terminal) — that works in every browser:

       OPENAI_API_KEY=sk-proj-...
       MODEL=gpt-4o-mini

  Then follow the Lab 1 guide your instructor shares.
  ──────────────────────────────────────────────────────────────────────

EOF
