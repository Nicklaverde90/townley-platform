Patch: Audit Log UI + CSV Export + Bulk Hard Delete
===================================================
This patch adds:
  - Backend:
    * GET /api/audit/workorders (list with filters + pagination) [admin only]
    * GET /api/audit/workorders/export (CSV export) [admin only]
    * POST /api/workorders/hard-delete-bulk (bulk hard delete by RecordNo[]) [admin only]
  - Frontend:
    * /audit page with filterable, paginated audit table and CSV export button
    * Bulk selection + hard delete with confirmation on Work Orders page
    * Accessible confirmation dialog

Apply
-----
1) Unzip at the repo root (paths preserved).
2) Rebuild & start: `docker compose up --build -d`
3) Ensure you've run all migrations from previous patches.
4) Open http://localhost → Audit in the nav (admins only).

Notes
-----
- Admin-gated endpoints use require_admin() dependency.
- CSV export streams text/csv with RFC4180 quoting.