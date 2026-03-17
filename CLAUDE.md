# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Jekyll-based static site counting down to KU Basketball's "Late Night in the Phog" event. Features a live countdown timer and player roster pages organized by year. Deployed via GitHub Pages from the `main` branch.

## Key Commands

```bash
just start          # Start dev server (Docker, detached)
just server         # Start dev server in foreground
just stop           # Stop dev server
just tail           # View Docker logs
just build          # Build Jekyll site
just static         # Build Tailwind CSS (production + development)
just lint           # Run pre-commit hooks on all files
just fetch          # Fetch player data for current year
just fill-in-player-images  # Download player headshots
just setup          # First-time project setup (pip, uv, pre-commit)
just update         # Update dependencies
```

## Architecture

### Date Configuration (Annual Updates)

The Late Night date is hardcoded in **three places** that must stay in sync:
1. `index.html` — front matter: `when: October 17, 2025 @ 6:30pm` and `current_year: 2025`
2. `js/main.js` — line 1: `new Date('10/17/2025 6:30 PM')`
3. `_latenights/{year}.md` — front matter with `current_year`, `season`, and `when`

### Collections

- **`_players/`** — One markdown file per player per year. Filename format: `{year}-{last}-{first}.md`. Front matter fields match `models.py` `Player` class (name, number, position, height, weight, class, hometown, image, etc.). Players have a `status` field: `active` (default), `declaring`, `graduating`, `departing`, or `unknown`.
- **`_latenights/`** — One file per year (`2014.md`–`2025.md`). Each uses the `latenights` layout which renders the roster grouped by player status.

### Layouts

- `default.html` — Base layout with countdown timer, includes JS/CSS
- `latenights.html` — Extends default; renders player lists grouped by status (active, declaring, graduating, departing, unknown) via `_includes/player-list.html`

### Data Pipeline

Python scripts (`fetch-players.py`, `fill-in-player-images.py`) scrape player data from KU athletics, validated through Pydantic models in `models.py`, and output markdown files to `_players/`. Player slugs are auto-generated as `{year}-{last}-{first}`.

### CSS

Tailwind CSS compiled from `src/styles.css` using config at `src/tailwind.config.js`. Output goes to `css/tailwind.css` (production) and `css/development.css`.

## Tech Stack

- **Site**: Jekyll, Tailwind CSS, jQuery
- **Data scripts**: Python with Pydantic, managed with uv
- **Task runner**: Just (justfile)
- **Dev environment**: Docker Compose
