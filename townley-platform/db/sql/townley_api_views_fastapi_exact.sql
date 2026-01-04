-- =========================================================
-- Townley API Views (Backend-Exact Alignment via api.*)
--
-- Backend strategy (Option B):
--   - Backend reads/writes through api.* only
--   - api.* is a stable contract over the legacy dbo.* schema
--   - Keeps FULL legacy dbo.* intact and verifiable (parity_legacy_full.sql)
--
-- NOTE:
--   These views intentionally reference dbo.* (legacy surface) so the
--   platform remains "as close as possible" to legacy while the app can
--   standardize on api.* names.
-- =========================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'api')
BEGIN
    EXEC('CREATE SCHEMA api');
END
GO

-- =========================================================
-- Users (used by auth + deps)
-- Legacy: dbo.users
-- =========================================================
CREATE OR ALTER VIEW api.vw_users AS
SELECT
    u.id              AS id,
    u.username        AS username,
    u.hashed_password AS hashed_password,
    u.role            AS role,
    u.created_at      AS created_at
FROM dbo.users u;
GO

-- =========================================================
-- WorkOrders (used by workorders endpoints)
-- Legacy: dbo.workorders
-- =========================================================
CREATE OR ALTER VIEW api.vw_workorders AS
SELECT
    wo.RecordNo        AS record_no,
    wo.WorkOrderNo     AS work_order_no,
    wo.PartNo          AS part_no,
    wo.CustomerName    AS customer_name,
    wo.AlloyCode       AS alloy_code,
    wo.QtyRequired     AS qty_required,
    wo.RushDueDate     AS rush_due_date,
    wo.SerialNo        AS serial_no,
    wo.StatusNotes     AS status_notes,
    wo.MoldingFinished AS molding_finished,
    wo.PouringFinished AS pouring_finished,
    wo.HeatTreatFinished AS heat_treat_finished,
    wo.MachiningFinished AS machining_finished,
    wo.AssemblyFinished AS assembly_finished,
    wo.FinalInspComp   AS final_insp_complete,
    wo.Status          AS status
FROM dbo.workorders wo;
GO

-- =========================================================
-- WorkOrder Audit stream (optional)
-- Platform support table: dbo.WorkOrderAudit (created by support script)
-- =========================================================
CREATE OR ALTER VIEW api.vw_workorder_audit AS
SELECT
    a.Id        AS id,
    a.Action    AS action,
    a.RecordNo  AS record_no,
    a.BeforeJson AS before_json,
    a.AfterJson  AS after_json,
    a.UserName   AS user_name,
    a.AtUtc     AS occurred_at
FROM dbo.WorkOrderAudit a;
GO
