# Townley DB (FULL legacy + Option B api.*)

This platform is set up so that:

- **Legacy schema lives in `dbo.*`** (FULL legacy contract)
- Backend talks to **`api.*` only**:
  - Reads: `api.vw_*`
  - Writes: `api.sp_*`

## Quick start

From the **`townley-platform/`** directory:

```bash
docker compose up --build
```

This does:

1. Starts SQL Server as `townley_mssql` on port `1433`
2. Runs `db_init` one-shot container to execute:
   - `db/sql/townley_deploy_end_to_end.sql` (creates `Townley_MySQL`)
   - `db/sql/townley_platform_support_objects.sql`
   - `db/sql/townley_api_views_fastapi_exact.sql`
   - `db/sql/townley_platform_api_write_procs.sql`
   - `db/sql/parity_legacy_full.sql` (reports drift vs full legacy)
3. Starts API + Web + Nginx

## Re-running DB scripts (Windows)

```bat
cd townley-platform\db
update-townley-db.bat
```

## Notes

- Change the **SA password** in both `docker-compose.yml` and `backend/.env`.
- If you need the parity check to **hard-fail** (THROW on mismatch), say the word and I will regenerate it.
