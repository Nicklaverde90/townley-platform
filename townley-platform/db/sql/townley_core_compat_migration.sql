/*
Townley Platform - Compatibility + Incremental Migration Layer
-------------------------------------------------------------
Purpose:
- Map existing legacy dbo.* tables/columns into the new strict core.* model
- Support incremental migration without breaking the app

Assumptions:
- You have already deployed: townley_core_schema_strict.sql (creates core.* and rpt.*)
- Legacy tables exist under dbo.* (from Townleyfulldatabaseschema_portable.sql or similar)

This script is NON-DESTRUCTIVE:
- It does not DROP legacy objects
- It only creates schemas/views/stage mapping tables and migration stored procedures
*/

SET NOCOUNT ON;


IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'legacy') EXEC('CREATE SCHEMA legacy AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stage')  EXEC('CREATE SCHEMA stage  AUTHORIZATION dbo;');


-- Stage mapping tables: legacy natural keys -> new core surrogate keys
IF OBJECT_ID('stage.PartMap','U') IS NULL
BEGIN
  CREATE TABLE stage.PartMap(
    LegacyPartNo nvarchar(50) NOT NULL,
    PartId int NOT NULL,
    MigratedAt datetime2(3) NOT NULL CONSTRAINT DF_stage_PartMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_PartMap PRIMARY KEY CLUSTERED (LegacyPartNo),
    CONSTRAINT UQ_stage_PartMap_PartId UNIQUE (PartId)
  );
END;

IF OBJECT_ID('stage.CustomerMap','U') IS NULL
BEGIN
  CREATE TABLE stage.CustomerMap(
    LegacyCustomerNumber nvarchar(50) NOT NULL,
    CustomerId int NOT NULL,
    MigratedAt datetime2(3) NOT NULL CONSTRAINT DF_stage_CustomerMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_CustomerMap PRIMARY KEY CLUSTERED (LegacyCustomerNumber),
    CONSTRAINT UQ_stage_CustomerMap_CustomerId UNIQUE (CustomerId)
  );
END;

IF OBJECT_ID('stage.UserMap','U') IS NULL
BEGIN
  CREATE TABLE stage.UserMap(
    LegacyUserId int NOT NULL,
    UserId int NOT NULL,
    MigratedAt datetime2(3) NOT NULL CONSTRAINT DF_stage_UserMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_UserMap PRIMARY KEY CLUSTERED (LegacyUserId),
    CONSTRAINT UQ_stage_UserMap_UserId UNIQUE (UserId)
  );
END;

IF OBJECT_ID('stage.WorkOrderMap','U') IS NULL
BEGIN
  CREATE TABLE stage.WorkOrderMap(
    LegacyRecordNo int NOT NULL,
    WorkOrderId int NOT NULL,
    MigratedAt datetime2(3) NOT NULL CONSTRAINT DF_stage_WorkOrderMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_WorkOrderMap PRIMARY KEY CLUSTERED (LegacyRecordNo),
    CONSTRAINT UQ_stage_WorkOrderMap_WorkOrderId UNIQUE (WorkOrderId)
  );
END;


/* ---------------------------
   LEGACY -> CORE SOURCE VIEWS
   --------------------------- */

-- Parts
CREATE OR ALTER VIEW legacy.vw_parts_source AS
SELECT
  p.PartNo        AS legacy_part_no,
  LTRIM(RTRIM(p.PartNo)) AS part_number,
  NULLIF(LTRIM(RTRIM(p.PartDescription)), '') AS description,
  NULLIF(LTRIM(RTRIM(p.Alloy)), '') AS alloy
FROM dbo.Parts p
WHERE NULLIF(LTRIM(RTRIM(p.PartNo)), '') IS NOT NULL;

-- Customers
CREATE OR ALTER VIEW legacy.vw_customers_source AS
SELECT
  c.CustomerNumber AS legacy_customer_number,
  NULLIF(LTRIM(RTRIM(c.CustomerName)), '') AS name
FROM dbo.Customers c
WHERE NULLIF(LTRIM(RTRIM(c.CustomerNumber)), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(c.CustomerName)), '') IS NOT NULL;

-- Users (legacy table is dbo.users)
CREATE OR ALTER VIEW legacy.vw_users_source AS
SELECT
  u.id AS legacy_user_id,
  NULLIF(LTRIM(RTRIM(u.username)), '') AS username,
  NULLIF(LTRIM(RTRIM(u.hashed_password)), '') AS hashed_password,
  NULLIF(LTRIM(RTRIM(u.role)), '') AS role,
  COALESCE(TRY_CONVERT(datetime2(3), u.created_at), SYSUTCDATETIME()) AS created_at
FROM dbo.[users] u
WHERE NULLIF(LTRIM(RTRIM(u.username)), '') IS NOT NULL;

-- WorkOrders
CREATE OR ALTER VIEW legacy.vw_workorders_source AS
SELECT
  wo.RecordNo      AS legacy_record_no,
  NULLIF(LTRIM(RTRIM(wo.WorkOrderNo)), '') AS work_order_no,
  NULLIF(LTRIM(RTRIM(wo.PartNo)), '')      AS legacy_part_no,
  NULLIF(LTRIM(RTRIM(wo.CustomerName)), '') AS customer_name,
  NULLIF(LTRIM(RTRIM(wo.AlloyCode)), '') AS alloy_code,
  TRY_CONVERT(int, wo.QtyRequired) AS qty_required,
  TRY_CONVERT(date, wo.RushDueDate) AS rush_due_date,
  NULLIF(LTRIM(RTRIM(wo.SerialNo)), '') AS serial_no,
  ISNULL(wo.AssemblyFinished, 0) AS assembly_finished,
  ISNULL(wo.FinalInspComp, 0) AS final_inspection_complete,
  -- Legacy had HeatTreatFinished; strict core expects "HeatTreatRequired"
  ISNULL(wo.HeatTreatFinished, 0) AS heat_treat_required,
  CASE
    WHEN ISNULL(wo.FinalInspComp,0) = 1 THEN 1
    WHEN UPPER(LTRIM(RTRIM(ISNULL(wo.Status,'')))) IN ('COMPLETE','COMPLETED','DONE','CLOSED') THEN 1
    ELSE 0
  END AS job_complete,
  NULLIF(LTRIM(RTRIM(wo.Status)), '') AS status
FROM dbo.WorkOrders wo
WHERE NULLIF(LTRIM(RTRIM(wo.WorkOrderNo)), '') IS NOT NULL;

-- MoldingRecords (links by WorkOrderNo)
CREATE OR ALTER VIEW legacy.vw_moldingrecords_source AS
SELECT
  mr.RecordNo AS legacy_record_no,
  NULLIF(LTRIM(RTRIM(mr.WorkOrderNo)), '') AS work_order_no,
  TRY_CONVERT(date, mr.MoldDate) AS mold_date,
  NULLIF(LTRIM(RTRIM(mr.MoldShift)), '') AS mold_shift,
  NULLIF(LTRIM(RTRIM(mr.MoldOperator)), '') AS mold_operator,
  NULLIF(LTRIM(RTRIM(mr.PatternNo)), '') AS pattern_no,
  NULLIF(LTRIM(RTRIM(mr.Alloy)), '') AS alloy,
  NULLIF(LTRIM(RTRIM(mr.MoldNotes)), '') AS mold_notes,
  ISNULL(mr.MoldingFinished, 0) AS molding_finished,
  COALESCE(TRY_CONVERT(datetime2(3), mr.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(datetime2(3), mr.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.MoldingRecords mr
WHERE NULLIF(LTRIM(RTRIM(mr.WorkOrderNo)), '') IS NOT NULL;

-- PouringRecords (already has WorkOrderId in legacy)
CREATE OR ALTER VIEW legacy.vw_pouringrecords_source AS
SELECT
  pr.Id AS legacy_pouring_id,
  pr.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, pr.PourDate) AS pour_date,
  NULLIF(LTRIM(RTRIM(pr.Alloy)), '') AS alloy,
  NULLIF(LTRIM(RTRIM(pr.Notes)), '') AS notes,
  COALESCE(TRY_CONVERT(datetime2(3), pr.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(datetime2(3), pr.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.PouringRecords pr
WHERE pr.WorkOrderId IS NOT NULL;

-- HeatTreatRecords (legacy already keyed by WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_heattreatrecords_source AS
SELECT
  -- legacy doesn't have its own identity id; we'll migrate as one row per (WorkOrderId, TreatDate, Temperature, DurationHours)
  htr.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, htr.TreatDate) AS treat_date,
  TRY_CONVERT(int, htr.Temperature) AS temperature,
  TRY_CONVERT(decimal(10,2), htr.DurationHours) AS duration_hours,
  NULLIF(LTRIM(RTRIM(htr.Notes)), '') AS notes,
  SYSUTCDATETIME() AS created_at,
  SYSUTCDATETIME() AS updated_at
FROM dbo.HeatTreatRecords htr
WHERE htr.WorkOrderId IS NOT NULL;

-- MachiningRecords (legacy MachineTime uses a float "Record" that usually corresponds to WorkOrders.RecordNo)
CREATE OR ALTER VIEW legacy.vw_machiningrecords_source AS
SELECT
  TRY_CONVERT(int, mt.Record) AS legacy_record_no,
  TRY_CONVERT(date, mt.MachineDate) AS machine_date,
  NULLIF(LTRIM(RTRIM(CAST(mt.ID AS nvarchar(50)))), '') AS operator,
  NULLIF(LTRIM(RTRIM(mt.MachineNotes)), '') AS notes,
  COALESCE(TRY_CONVERT(datetime2(3), mt.MachineDate), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(datetime2(3), mt.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.MachineTime mt
WHERE TRY_CONVERT(int, mt.Record) IS NOT NULL;

-- AssemblyRecords (legacy already has WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_assemblyrecords_source AS
SELECT
  ar.Id AS legacy_assembly_id,
  ar.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, ar.AssemblyDate) AS assembly_date,
  NULLIF(LTRIM(RTRIM(ar.Assembler)), '') AS operator,
  NULLIF(LTRIM(RTRIM(ar.AssemblyNotes)), '') AS notes,
  COALESCE(TRY_CONVERT(datetime2(3), ar.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(datetime2(3), ar.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.AssemblyRecords ar
WHERE ar.WorkOrderId IS NOT NULL;

-- ScrapRecords (legacy already has WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_scraprecords_source AS
SELECT
  sr.Id AS legacy_scrap_id,
  sr.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, sr.ScrapDate) AS scrap_date,
  NULLIF(LTRIM(RTRIM(sr.ScrapReason)), '') AS reason,
  TRY_CONVERT(int, sr.ScrapQty) AS qty_scrapped,
  COALESCE(TRY_CONVERT(datetime2(3), sr.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(datetime2(3), sr.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.ScrapRecords sr
WHERE sr.WorkOrderId IS NOT NULL;

-- InspectionRecords (legacy already has WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_inspectionrecords_source AS
SELECT
  ir.Id AS legacy_inspection_id,
  ir.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, ir.InspectionDate) AS inspect_date,
  NULLIF(LTRIM(RTRIM(ir.Inspector)), '') AS inspector,
  CASE WHEN ISNULL(ir.Pass,0)=1 THEN 'PASS' ELSE 'FAIL' END AS result,
  COALESCE(TRY_CONVERT(datetime2(3), ir.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(datetime2(3), ir.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.InspectionRecords ir
WHERE ir.WorkOrderId IS NOT NULL;

-- ChemistryResults (legacy uses snake_case columns; mostly compatible)
CREATE OR ALTER VIEW legacy.vw_chemistryresults_source AS
SELECT
  cr.id AS legacy_chem_id,
  cr.work_order_id AS legacy_workorder_id,
  TRY_CONVERT(int, cr.heat_number) AS heat_number,
  TRY_CONVERT(int, cr.sample_number) AS sample_number,
  TRY_CONVERT(date, cr.date_poured) AS date_poured,
  NULLIF(LTRIM(RTRIM(cr.furnace)), '') AS furnace,
  NULLIF(LTRIM(RTRIM(cr.alloy_code)), '') AS alloy_code,
  TRY_CONVERT(decimal(12,3), cr.gross_weight) AS gross_weight,
  TRY_CONVERT(decimal(12,3), cr.tap_temp) AS tap_temp,
  TRY_CONVERT(decimal(12,6), cr.C) AS C,
  COALESCE(TRY_CONVERT(datetime2(3), cr.created_at), SYSUTCDATETIME()) AS created_at,
  SYSUTCDATETIME() AS updated_at
FROM dbo.ChemistryResults cr
WHERE cr.work_order_id IS NOT NULL;

-- Attachedfiles (legacy ties to MainScrapTbl; we'll map to WorkOrders via WorkorderNo)
CREATE OR ALTER VIEW legacy.vw_attachedfiles_source AS
SELECT
  af.ID AS legacy_attached_id,
  ms.WorkorderNo AS legacy_workorder_no,
  NULLIF(LTRIM(RTRIM(af.FileType)), '') AS file_type,
  NULLIF(LTRIM(RTRIM(af.FileName)), '') AS file_name,
  NULLIF(LTRIM(RTRIM(af.FilePath)), '') AS file_path,
  TRY_CONVERT(datetime2(3), af.AddDateTime) AS add_datetime,
  NULLIF(LTRIM(RTRIM(af.Username)), '') AS uploaded_by,
  ISNULL(af.Deleted, 0) AS deleted,
  NULLIF(LTRIM(RTRIM(af.GridNumber)), '') AS grid_number
FROM dbo.Attachedfiles af
LEFT JOIN dbo.MainScrapTbl ms ON ms.ID = af.MainScrapTblID
WHERE NULLIF(LTRIM(RTRIM(af.FileName)), '') IS NOT NULL;

-- AuditLogs
CREATE OR ALTER VIEW legacy.vw_auditlogs_source AS
SELECT
  al.Id AS legacy_audit_id,
  al.UserId AS legacy_user_id,
  NULLIF(LTRIM(RTRIM(al.Action)), '') AS action,
  NULLIF(LTRIM(RTRIM(al.Resource)), '') AS table_name,
  TRY_CONVERT(int, NULL) AS record_id,
  COALESCE(TRY_CONVERT(datetime2(3), al.Timestamp), SYSUTCDATETIME()) AS [timestamp],
  NULLIF(LTRIM(RTRIM(al.Details)), '') AS notes
FROM dbo.AuditLogs al;


/* ---------------------------
   MIGRATION STORED PROCEDURES
   --------------------------- */

-- Parts
CREATE OR ALTER PROCEDURE core.sp_migrate_parts
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize)
      legacy_part_no,
      part_number,
      description,
      alloy
    FROM legacy.vw_parts_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.PartMap m WHERE m.LegacyPartNo = s.legacy_part_no)
    ORDER BY legacy_part_no
  )
  MERGE core.Parts AS tgt
  USING src
    ON tgt.PartNumber = src.part_number
  WHEN MATCHED THEN
    UPDATE SET
      tgt.Description = COALESCE(src.description, tgt.Description),
      tgt.Alloy       = COALESCE(src.alloy, tgt.Alloy),
      tgt.UpdatedAt   = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (PartNumber, Description, Alloy, CreatedAt, UpdatedAt)
    VALUES (src.part_number, COALESCE(src.description,''), src.alloy, SYSUTCDATETIME(), SYSUTCDATETIME())
  OUTPUT
    src.legacy_part_no,
    inserted.PartId
  INTO stage.PartMap(LegacyPartNo, PartId);
END;
GO

-- Customers
CREATE OR ALTER PROCEDURE core.sp_migrate_customers
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize)
      legacy_customer_number,
      name
    FROM legacy.vw_customers_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.CustomerMap m WHERE m.LegacyCustomerNumber = s.legacy_customer_number)
    ORDER BY legacy_customer_number
  )
  MERGE core.Customers AS tgt
  USING src
    ON tgt.Name = src.name
  WHEN MATCHED THEN
    UPDATE SET tgt.UpdatedAt = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (Name, Location, CreatedAt, UpdatedAt)
    VALUES (src.name, NULL, SYSUTCDATETIME(), SYSUTCDATETIME())
  OUTPUT
    src.legacy_customer_number,
    inserted.CustomerId
  INTO stage.CustomerMap(LegacyCustomerNumber, CustomerId);
END;
GO

-- Users
CREATE OR ALTER PROCEDURE core.sp_migrate_users
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize)
      legacy_user_id,
      username,
      hashed_password,
      role,
      created_at
    FROM legacy.vw_users_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.UserMap m WHERE m.LegacyUserId = s.legacy_user_id)
    ORDER BY legacy_user_id
  )
  MERGE core.Users AS tgt
  USING src
    ON tgt.Username = src.username
  WHEN MATCHED THEN
    UPDATE SET
      tgt.HashedPassword = COALESCE(src.hashed_password, tgt.HashedPassword),
      tgt.Role           = COALESCE(src.role, tgt.Role),
      tgt.UpdatedAt      = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (Username, HashedPassword, Role, CreatedAt, UpdatedAt)
    VALUES (src.username, src.hashed_password, COALESCE(src.role,'user'), src.created_at, SYSUTCDATETIME())
  OUTPUT
    src.legacy_user_id,
    inserted.UserId
  INTO stage.UserMap(LegacyUserId, UserId);
END;
GO

-- WorkOrders (requires Parts + Customers migrated first)
CREATE OR ALTER PROCEDURE core.sp_migrate_workorders
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src_raw AS (
    SELECT TOP (@BatchSize)
      s.legacy_record_no,
      s.work_order_no,
      s.legacy_part_no,
      s.customer_name,
      s.alloy_code,
      s.qty_required,
      s.rush_due_date,
      s.serial_no,
      s.assembly_finished,
      s.final_inspection_complete,
      s.heat_treat_required,
      s.job_complete,
      s.status
    FROM legacy.vw_workorders_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.WorkOrderMap m WHERE m.LegacyRecordNo = s.legacy_record_no)
    ORDER BY s.legacy_record_no
  ),
  src AS (
    SELECT
      r.*,
      pm.PartId,
      cm.CustomerId
    FROM src_raw r
    LEFT JOIN stage.PartMap pm ON pm.LegacyPartNo = r.legacy_part_no
    LEFT JOIN dbo.Customers lc ON lc.CustomerName = r.customer_name
    LEFT JOIN stage.CustomerMap cm ON cm.LegacyCustomerNumber = lc.CustomerNumber
    WHERE pm.PartId IS NOT NULL AND cm.CustomerId IS NOT NULL
  )
  MERGE core.WorkOrders AS tgt
  USING src
    ON tgt.WorkOrderNo = src.work_order_no
  WHEN MATCHED THEN
    UPDATE SET
      tgt.PartId = src.PartId,
      tgt.CustomerId = src.CustomerId,
      tgt.AlloyCode = COALESCE(src.alloy_code, tgt.AlloyCode),
      tgt.QtyRequired = COALESCE(src.qty_required, tgt.QtyRequired),
      tgt.RushDueDate = COALESCE(src.rush_due_date, tgt.RushDueDate),
      tgt.SerialNo = COALESCE(src.serial_no, tgt.SerialNo),
      tgt.AssemblyFinished = src.assembly_finished,
      tgt.FinalInspectionComplete = src.final_inspection_complete,
      tgt.HeatTreatRequired = src.heat_treat_required,
      tgt.JobComplete = src.job_complete,
      tgt.Status = COALESCE(src.status, tgt.Status),
      tgt.UpdatedAt = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (WorkOrderNo, PartId, CustomerId, AlloyCode, QtyRequired, RushDueDate, SerialNo,
            AssemblyFinished, FinalInspectionComplete, HeatTreatRequired, JobComplete, Status,
            CreatedAt, UpdatedAt)
    VALUES (src.work_order_no, src.PartId, src.CustomerId, src.alloy_code,
            COALESCE(src.qty_required, 0), src.rush_due_date, src.serial_no,
            src.assembly_finished, src.final_inspection_complete, src.heat_treat_required, src.job_complete,
            COALESCE(src.status,'active'),
            SYSUTCDATETIME(), SYSUTCDATETIME())
  OUTPUT
    src.legacy_record_no,
    inserted.WorkOrderId
  INTO stage.WorkOrderMap(LegacyRecordNo, WorkOrderId);
END;
GO

-- MoldingRecords (requires WorkOrders migrated)
CREATE OR ALTER PROCEDURE core.sp_migrate_moldingrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src_raw AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_moldingrecords_source
    ORDER BY legacy_record_no
  ),
  src AS (
    SELECT
      r.*,
      wom.WorkOrderId
    FROM src_raw r
    INNER JOIN core.WorkOrders wo ON wo.WorkOrderNo = r.work_order_no
    INNER JOIN stage.WorkOrderMap wom ON wom.WorkOrderId = wo.WorkOrderId
  )
  INSERT INTO core.MoldingRecords
    (WorkOrderId, MoldDate, MoldShift, MoldOperator, PatternNo, Alloy, MoldNotes, MoldingFinished, CreatedAt, UpdatedAt)
  SELECT
    s.WorkOrderId, s.mold_date, s.mold_shift, s.mold_operator, s.pattern_no, s.alloy, s.mold_notes, s.molding_finished, s.created_at, s.updated_at
  FROM src s
  WHERE NOT EXISTS (
    SELECT 1 FROM core.MoldingRecords x
    WHERE x.WorkOrderId = s.WorkOrderId AND x.MoldDate = s.mold_date AND ISNULL(x.PatternNo,'') = ISNULL(s.pattern_no,'')
  );
END;
GO

-- PouringRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_pouringrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_pouringrecords_source
    ORDER BY legacy_pouring_id
  )
  INSERT INTO core.PouringRecords (WorkOrderId, PourDate, Alloy, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.pour_date,
    s.alloy,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.PouringRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.PourDate = s.pour_date AND ISNULL(x.Alloy,'')=ISNULL(s.alloy,'')
  );
END;
GO

-- HeatTreatRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_heattreatrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_heattreatrecords_source
    ORDER BY legacy_workorder_id
  )
  INSERT INTO core.HeatTreatRecords (WorkOrderId, TreatDate, Temperature, DurationHours, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.treat_date,
    s.temperature,
    s.duration_hours,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.HeatTreatRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.TreatDate = s.treat_date AND ISNULL(x.Temperature,0)=ISNULL(s.temperature,0)
  );
END;
GO

-- MachiningRecords (best-effort; requires MachineTime.Record -> legacy WorkOrders.RecordNo mapping)
CREATE OR ALTER PROCEDURE core.sp_migrate_machiningrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_machiningrecords_source
    ORDER BY legacy_record_no
  )
  INSERT INTO core.MachiningRecords (WorkOrderId, MachineDate, Operator, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.machine_date,
    s.operator,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_record_no
  WHERE NOT EXISTS (
    SELECT 1 FROM core.MachiningRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.MachineDate = s.machine_date AND ISNULL(x.Operator,'')=ISNULL(s.operator,'')
  );
END;
GO

-- AssemblyRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_assemblyrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_assemblyrecords_source
    ORDER BY legacy_assembly_id
  )
  INSERT INTO core.AssemblyRecords (WorkOrderId, AssemblyDate, Operator, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.assembly_date,
    s.operator,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.AssemblyRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.AssemblyDate = s.assembly_date AND ISNULL(x.Operator,'')=ISNULL(s.operator,'')
  );
END;
GO

-- ScrapRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_scraprecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_scraprecords_source
    ORDER BY legacy_scrap_id
  )
  INSERT INTO core.ScrapRecords (WorkOrderId, ScrapDate, Reason, QtyScrapped, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.scrap_date,
    s.reason,
    COALESCE(s.qty_scrapped, 0),
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.ScrapRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.ScrapDate = s.scrap_date AND ISNULL(x.Reason,'')=ISNULL(s.reason,'')
  );
END;
GO

-- InspectionRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_inspectionrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_inspectionrecords_source
    ORDER BY legacy_inspection_id
  )
  INSERT INTO core.InspectionRecords (WorkOrderId, InspectDate, Inspector, Result, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.inspect_date,
    s.inspector,
    s.result,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.InspectionRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.InspectDate = s.inspect_date AND ISNULL(x.Inspector,'')=ISNULL(s.inspector,'')
  );
END;
GO

-- ChemistryResults
CREATE OR ALTER PROCEDURE core.sp_migrate_chemistryresults
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_chemistryresults_source
    ORDER BY legacy_chem_id
  )
  INSERT INTO core.ChemistryResults (WorkOrderId, HeatNumber, SampleNumber, DatePoured, Furnace, AlloyCode, GrossWeight, TapTemp, C, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.heat_number,
    s.sample_number,
    s.date_poured,
    s.furnace,
    s.alloy_code,
    s.gross_weight,
    s.tap_temp,
    s.C,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.ChemistryResults x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.HeatNumber = s.heat_number AND x.SampleNumber = s.sample_number
  );
END;
GO

-- AttachedFiles (via MainScrapTbl -> WorkorderNo)
CREATE OR ALTER PROCEDURE core.sp_migrate_attachedfiles
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src_raw AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_attachedfiles_source
    ORDER BY legacy_attached_id
  ),
  src AS (
    SELECT
      r.*,
      wo.WorkOrderId
    FROM src_raw r
    INNER JOIN core.WorkOrders wo ON wo.WorkOrderNo = r.legacy_workorder_no
  )
  INSERT INTO core.AttachedFiles (WorkOrderId, FileType, FileName, FilePath, AddDateTime, UploadedBy, Deleted, GridNumber, CreatedAt, UpdatedAt)
  SELECT
    s.WorkOrderId,
    s.file_type,
    s.file_name,
    s.file_path,
    COALESCE(s.add_datetime, SYSUTCDATETIME()),
    s.uploaded_by,
    ISNULL(s.deleted,0),
    s.grid_number,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
  FROM src s
  WHERE NOT EXISTS (
    SELECT 1 FROM core.AttachedFiles x
    WHERE x.WorkOrderId = s.WorkOrderId AND x.FileName = s.file_name AND ISNULL(x.FilePath,'')=ISNULL(s.file_path,'')
  );
END;
GO

-- AuditLogs
CREATE OR ALTER PROCEDURE core.sp_migrate_auditlogs
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_auditlogs_source
    ORDER BY legacy_audit_id
  )
  INSERT INTO core.AuditLogs (UserId, Action, TableName, RecordId, [Timestamp], Notes)
  SELECT
    COALESCE(um.UserId, 1) AS UserId, -- fallback to admin user id 1 if not mapped
    COALESCE(s.action,'unknown'),
    COALESCE(s.table_name,'unknown'),
    s.record_id,
    s.[timestamp],
    s.notes
  FROM src s
  LEFT JOIN stage.UserMap um ON um.LegacyUserId = s.legacy_user_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.AuditLogs x
    WHERE x.[Timestamp]=s.[timestamp] AND x.Action=COALESCE(s.action,'unknown') AND x.TableName=COALESCE(s.table_name,'unknown')
  );
END;
GO

-- Convenience: run in safe dependency order
CREATE OR ALTER PROCEDURE core.sp_migrate_all
  @BatchSize int = 5000
AS
BEGIN
  EXEC core.sp_migrate_parts @BatchSize;
  EXEC core.sp_migrate_customers @BatchSize;
  EXEC core.sp_migrate_users @BatchSize;
  EXEC core.sp_migrate_workorders @BatchSize;

  EXEC core.sp_migrate_moldingrecords @BatchSize;
  EXEC core.sp_migrate_pouringrecords @BatchSize;
  EXEC core.sp_migrate_heattreatrecords @BatchSize;
  EXEC core.sp_migrate_machiningrecords @BatchSize;
  EXEC core.sp_migrate_assemblyrecords @BatchSize;
  EXEC core.sp_migrate_scraprecords @BatchSize;
  EXEC core.sp_migrate_inspectionrecords @BatchSize;
  EXEC core.sp_migrate_chemistryresults @BatchSize;
  EXEC core.sp_migrate_attachedfiles @BatchSize;
  EXEC core.sp_migrate_auditlogs @BatchSize;
END;
GO
