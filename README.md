# Urbana Boutique

Plataforma imobiliária boutique com CMS headless (Directus) e frontend estático (Astro).

## Stack

| Camada   | Tecnologia                                    |
| -------- | --------------------------------------------- |
| Frontend | Astro 5, Svelte 5, Tailwind CSS 4, TypeScript |
| Backend  | Directus 11, PostgreSQL 15 + PostGIS          |
| Runtime  | Bun (frontend), Docker Compose (backend)      |

## Estrutura

```
backend/
  docker-compose.yml   # Directus + PostgreSQL/PostGIS
  .env                 # credenciais do CMS (não versionado)

frontend/
  src/
    components/        # componentes Svelte (ilhas interativas) e Astro
    components/imoveis/# componentes de listagem/detalhe de imóveis
    layouts/           # Layout.astro (wrapper de todas as páginas)
    lib/               # SDK Directus, tipos TypeScript
    pages/             # rotas Astro (index, /imoveis, /imoveis/[slug])
    styles/            # global.css (tema Tailwind 4)
```

## Pré-requisitos

- [Bun](https://bun.sh/) >= 1.0
- [Docker](https://docs.docker.com/get-docker/) e Docker Compose

## Início rápido

### Tudo de uma vez

```bash
./dev.sh
```

Sobe o backend (Docker) e o frontend (Astro dev server) juntos. Acesse:

- **Frontend:** http://localhost:4321
- **Directus (CMS):** http://localhost:8055

### Separadamente

**Backend** (na pasta `backend/`):

```bash
docker compose up -d          # iniciar Directus + Postgres
docker compose down           # parar serviços
docker compose logs directus  # ver logs do CMS
```

**Frontend** (na pasta `frontend/`):

```bash
bun install          # instalar dependências
bun run dev          # servidor de desenvolvimento (localhost:4321)
bun run build        # build de produção → dist/
bun run preview      # preview do build de produção
```

## Design System

- **Paleta de cores** definida via `@theme` no Tailwind 4 (`frontend/src/styles/global.css`)
- Cor primária: escala `verde-50` a `verde-950` (OKLCH)
- Background: `offwhite`
- Fonte: Inter (sans-serif)
- Abordagem **mobile-first** — estilos base para mobile, `md:` para desktop
