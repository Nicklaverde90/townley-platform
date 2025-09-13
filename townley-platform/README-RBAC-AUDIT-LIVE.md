Patch: RBAC Roles + Audit Export UI Presets + Live Tail (SSE)
    =============================================================
    Generated: 2025-08-21 02:30

    This patch adds:
      - RBAC roles (viewer/editor/admin) stored on Users.role (default 'viewer')
      - Backend dependency `require_role(min_role)` and token validation helper for SSE
      - Audit stream via Server-Sent Events: GET /api/audit/stream
      - Frontend: 
          * Audit Log UI upgraded with date presets and saved filters (localStorage)
          * New "Audit Live" page with real-time tail of audit events (SSE)
          * ProtectedRoute upgraded to accept `minRole`
      - API client additions for `me()` returning `role`

    Apply steps (repo root):
      1) Unzip (preserve paths).
      2) Wire routes (backend/app/main.py):
           from app.api.routes.audit_stream import router as audit_stream_router
           app.include_router(audit_stream_router)
      3) Rebuild & start: `docker compose up --build -d`
      4) Run migration: `docker compose exec api alembic upgrade head`
      5) Promote roles as needed, e.g.:
           UPDATE Users SET role='admin' WHERE email='admin@example.com';
           UPDATE Users SET role='editor' WHERE email='editor@example.com';
      6) SPA routes:
           - /audit  (updated: presets + saved filters)
           - /audit/live  (new live tail)

    Notes:
      - SSE auth: because browsers can't send custom headers with EventSource, the token is passed as `?token=`.
        The backend validates it like any other bearer token.
      - Live stream implementation polls the Audit table every 1 second to detect new rows (portable and reliable).
        If you prefer Redis Pub/Sub, we can switch later.