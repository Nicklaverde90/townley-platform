-- =========================================================
-- Townley Platform - Support Objects for Option B (api.*)
--
-- Creates small helper tables used by the platform that are NOT part
-- of the legacy schema (and therefore excluded from the legacy parity
-- checks, which focus on legacy tables).
-- =========================================================

-- WorkOrderAudit: platform audit log used by routes that change work orders
IF OBJECT_ID('dbo.WorkOrderAudit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.WorkOrderAudit (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Action NVARCHAR(32) NOT NULL,
        RecordNo INT NOT NULL,
        BeforeJson NVARCHAR(MAX) NULL,
        AfterJson NVARCHAR(MAX) NULL,
        UserName NVARCHAR(255) NULL,
        AtUtc DATETIME2 NOT NULL CONSTRAINT DF_WorkOrderAudit_AtUtc DEFAULT (SYSUTCDATETIME())
    );
END
GO
