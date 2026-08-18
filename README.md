# CrewAI Workshop — Enrichment Crew (Lab 1)

Welcome! 👋 This is the workshop environment for **Lab 1**. In it you'll build —
and then deploy to production — a small team of AI agents (a "crew") that
researches a company across two parallel sources and returns a clean, scored,
**structured** profile a sales team could actually use.

```
  company, domain ─►  ┌─ web researcher   (DuckDuckGo search + scrape) ─┐
                      │                                                 ├─► enrichment analyst ─► scored profile
                      └─ api researcher   (Wikipedia REST — free)     ──┘    (ICP fit score + Markdown report)
```

The finished crew already lives in this repo, so you always have something that
runs — but the lab walks you through building it yourself, one section at a
time, running it after every step.

## Open it in GitHub Codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/CrewAIInc-FDE/crewai-labs-workspaces?quickstart=1)

A free personal GitHub account is all you need. Give it ~2 minutes to build —
`uv` and the CrewAI CLI come pre-installed.

## Get going

1. **Load your OpenAI key** (your instructor shares the `<url-from-handout>`):
   ```bash
   CURL_URL='<url-from-handout>' bash scripts/load-creds.sh
   source crewai-creds.env
   ```
   No URL? Run `bash scripts/load-creds.sh`, paste your `OPENAI_API_KEY=…` line,
   then press Ctrl-D. Re-run the `source` line in each new terminal you open.

2. **Follow the Lab 1 guide** your instructor shares, building the crew section
   by section.

3. **Run it** any time to see where you are:
   ```bash
   crewai install                          # first time only
   crewai run                              # default company: CrewAI
   uv run run_crew "Stripe" "stripe.com"   # or any company you like
   ```
   Results land in `output/company_report.md` and `output/enriched_profile.json`.

4. **Deploy it** (Lab 1, Section 6) — turn your crew into a live API on CrewAI AMP:
   ```bash
   crewai login            # sign in (browser / device code)
   crewai deploy create
   ```

## What's inside

- `src/enrichment_crew/` — the crew: agents, tasks, tools, and the structured
  output contract (`schemas.py`).
- `scripts/load-creds.sh` — loads your workshop key into the environment.
- `.devcontainer/` — the Codespaces setup (you won't need to touch this).

**The only key you need is an OpenAI key** — both research sources are free and
keyless (DuckDuckGo web search + the Wikipedia REST API).
