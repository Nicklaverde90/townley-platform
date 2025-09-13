StageTabs Wired Submit + Audit Trail (Patch)
===========================================
This patch does two things:
1) **Frontend:** Wires StageTabs submit handlers to explicit endpoints:
   - POST /api/molding
   - POST /api/pouring
   - POST /api/heattreat
   - POST /api/machining
   - POST /api/assembly
   - POST /api/inspection
   - POST /api/scrap
   - POST /api/chemistry

2) **Backend:** Adds FastAPI routes for those endpoints. Each route:
   - Requires at least 'editor' role (admin also ok).
   - Accepts JSON payload including `recordNo` and stage-specific fields.
   - Writes an audit record (`WorkOrderAudit`) with action `stage_update` and `stage` field set.
   - Returns a normalized response: { ok: true, recordNo, stage, fields }

How to apply
------------
1) Unzip this at the repo root (paths preserved).
2) Rebuild & start:  `docker compose up --build -d`
3) Migrate DB (if you haven't already applied the earlier audit migrations): `docker compose exec api alembic upgrade head`
4) Ensure your user role is 'editor' or 'admin' to submit stages.

Frontend usage
--------------
- The StageTabs now auto-submit to the dedicated endpoints with the correct payload.
- The submit includes `recordNo` and the validated form fields per stage.
- Success & error toasts are announced with ARIA live regions.

Backend details
---------------
- New router file: `backend/app/api/routes/stages_explicit.py`
- Dependency: `require_role(min_role='editor')` (from previous RBAC patch path `app/core/deps_role.py`).
- Audit write uses `WorkOrderAudit` (from earlier patch). If your table name differs, adjust the import.
- If you prefer a single /api/stages endpoint, you can alias the explicit routes to call a shared handler.

Files included
--------------
- backend/app/api/routes/stages_explicit.py
- frontend/src/lib/api-stages.ts        (overwrites to call explicit endpoints)
- frontend/src/features/workorders/tabs/StageTabs.tsx  (wire onSubmit to api-stages functions)
- frontend/src/components/Toast.tsx     (lightweight ARIA toast; used if not already present)

2025-08-21T02:53:27.983966Z