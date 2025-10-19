Patch: Work Orders — Delete + Undo, CSV Import, Role‑Scoped UI
    =============================================================
    This patch adds:
      • Soft-delete with undo (admin-only): DELETE /api/workorders/{record_no}, RESTORE via POST /api/workorders/{record_no}/restore
      • CSV import (admin-only): POST /api/workorders/import (multipart/form-data, file field 'file')
      • Role-scoped UI: non-admins lose editing/deleting/import controls; admins see full controls
      • "Me" endpoint for role discovery: GET /api/users/me
    
    Apply
    -----
      1) Unzip at repo root.
      2) Rebuild & start:   docker compose up --build -d
      3) Migrate:           docker compose exec api alembic upgrade head
      4) Log in as admin; open Work Orders.
    
    CSV format
    ----------
      Columns (header row required): RecordNo, Status, Description, CreatedAt
      - RecordNo: integer, required
      - CreatedAt: ISO 8601 or YYYY-MM-DD HH:MM[:SS] (optional)
      Upsert behavior: existing RecordNo is updated; missing becomes new record.