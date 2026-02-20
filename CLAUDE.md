# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Boutique real estate platform ("Urbana Boutique") with a Directus headless CMS backend and an Astro static frontend. All user-facing content is in **pt-BR**.

## Architecture

```
backend/   → Directus CMS + PostgreSQL/PostGIS via Docker Compose
frontend/  → Astro 5 + Svelte 5 + Tailwind CSS 4 (Bun)
```

The frontend is a static site (SSG) that will consume the Directus API. Svelte components are used for interactive islands (`client:load`). Pages are Astro files, reusable interactive parts are `.svelte` components.

## Commands

All frontend commands run from `frontend/`:

```bash
bun install          # install dependencies
bun run dev          # dev server (localhost:4321)
bun run build        # production build → dist/
bun run preview      # preview production build
```

Backend (from `backend/`):

```bash
docker compose up -d          # start Directus + Postgres
docker compose down           # stop services
docker compose logs directus  # check CMS logs
```

Directus admin panel runs at `localhost:8055`. Backend credentials are in `backend/.env`.

## Design System

- **Color palette** defined in `frontend/src/styles/global.css` via Tailwind 4 `@theme`
- Primary: `verde-50` through `verde-950` (OKLCH green, base `verde-500: oklch(50.8% 0.118 165.612)`)
- Background: `offwhite`
- Font: Inter (sans-serif)
- All styling is **mobile-first** — base styles target mobile, `md:` breakpoint for desktop

## Conventions

- Layout wrapper: `src/layouts/Layout.astro` — all pages should use it
- Svelte components use Svelte 5 runes (`$state`, `$derived`, etc.)
- Tailwind classes are written mobile-first: `text-sm md:text-base`
- No linting or test framework configured yet
