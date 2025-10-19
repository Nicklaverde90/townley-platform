# Townley Platform

Production-ready starter for Townley Engineering & Manufacturing:
- Backend: FastAPI + SQL Server (ODBC) + SQLAlchemy
- Frontend: React + Vite + Tailwind
- Reverse proxy: Nginx
- Dev hygiene: Commitizen (conventional commits) + pre-commit (Python/JS linters, secrets)
- CI: GitHub Actions (lint, test, build)

## Quick start
1. Install pre-commit and commitizen:
   ```bash
   pipx install pre-commit commitizen || pip install pre-commit commitizen
   pre-commit install
   ```
2. Backend env: copy `backend/.env.example` to `.env` and set DB creds.
3. Run stack:
   ```bash
   docker compose up --build
   ```
4. Open `http://localhost` (frontend) and `http://localhost/api/health` (API).

### Create an admin user
With the stack running:
```bash
docker compose exec api python -m app.scripts.create_admin admin@example.com --full-name "Admin User"
```
You will be prompted for a password (or pass `--password`). The script will create the user if missing or promote the existing account, setting `is_admin=1` and `role=admin`.

## Conventional commits
Use `cz commit` or `git commit` with the prompts:
- feat, fix, docs, style, refactor, perf, test, chore, build, ci

## Pre-commit
Runs ruff/black/isort for Python and eslint/prettier for JS/TS, plus basic hygiene and secret scanning.

## Added in patch
- Frontend: accessible React routes (Login, Dashboard, WorkOrders), axios client, and protected routes.
- Frontend Dockerfile: multi-stage build with volume export. Compose wiring copies build to `web_dist` for nginx.
- Backend: minimal auth (`/api/auth/register`, `/api/auth/login`), `User` model.
- Alembic: environment + initial migration creating `Users` and `WorkOrders`.
