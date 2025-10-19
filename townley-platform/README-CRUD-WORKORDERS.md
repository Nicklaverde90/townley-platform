Patch: Work Orders CRUD + Sorting + Role Checks
===============================================
This patch adds:
  - Server-side sorting to GET /api/workorders via sort_by & sort_dir.
  - POST /api/workorders (create) and PUT /api/workorders/{record_no} (update) — protected.
  - Basic role check: only users with Users.is_admin = 1 may create/update work orders.
  - Alembic migration to add Users.is_admin (default 0).
  - Frontend: accessible modal form to create/edit a work order, with react-hook-form + zod validation.

Apply steps (repo root):
  1) Unzip this archive preserving paths.
  2) Ensure frontend deps: `docker compose exec web npm i react-hook-form zod`
  3) Rebuild & restart: `docker compose up --build -d`
  4) Migrate DB: `docker compose exec api alembic upgrade head`
  5) Mark an admin (SQL example): 
     UPDATE Users SET is_admin = 1 WHERE email = 'admin@example.com';
  6) Log in as admin in the UI. Use "New Work Order" to create; click a row to edit.

Endpoints:
  GET  /api/workorders?q=&page=&page_size=&sort_by=RecordNo|CreatedAt&sort_dir=asc|desc
  POST /api/workorders                  # admin only
  PUT  /api/workorders/{record_no}    # admin only

Notes:
  - If your Users table already has is_admin, this migration will no-op on add; verify column presence if needed.
  - Validation: Description required; Status optional; CreatedAt defaults to server time when creating.