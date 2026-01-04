/* -------------------------------------------------------------------------
   Townley Platform - Core Schema (Updated Model)
   Generated: 2025-12-25
   Targets: Microsoft SQL Server (Windows or Linux/Docker)

   Notes:
   - Idempotent: will create schemas/tables if missing (does not drop).
   - Uses schemas:
       core = application tables
       rpt  = reporting/normalized views
------------------------------------------------------------------------- */
SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Create schemas if missing
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'core') EXEC('CREATE SCHEMA core');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'rpt')  EXEC('CREATE SCHEMA rpt');
GO

IF OBJECT_ID(N'core.Parts', N'U') IS NULL
BEGIN
    CREATE TABLE core.Parts (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        PartNumber NVARCHAR(100),
        Description NVARCHAR(510),
        Alloy NVARCHAR(100)

    );
END
GO

IF OBJECT_ID(N'core.Customers', N'U') IS NULL
BEGIN
    CREATE TABLE core.Customers (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        Name NVARCHAR(200),
        Location NVARCHAR(200)

    );
END
GO

IF OBJECT_ID(N'core.Departments', N'U') IS NULL
BEGIN
    CREATE TABLE core.Departments (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        Description NVARCHAR(100)

    );
END
GO

IF OBJECT_ID(N'core.Users', N'U') IS NULL
BEGIN
    CREATE TABLE core.Users (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        Username NVARCHAR(255) UNIQUE,
        HashedPassword NVARCHAR(255),
        Role NVARCHAR(100),
        CreatedAt DATETIME2 DEFAULT GETDATE()

    );
END
GO

IF OBJECT_ID(N'core.WorkOrders', N'U') IS NULL
BEGIN
    CREATE TABLE core.WorkOrders (

        RecordNo INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderNo NVARCHAR(100),
        PartId INT,
        CustomerId INT,
        AlloyCode NVARCHAR(100),
        QtyRequired INT,
        RushDueDate DATETIME2,
        SerialNo NVARCHAR(100),
        AssemblyFinished BIT DEFAULT (0),
        FinalInspectionComplete BIT DEFAULT (0),
        HeatTreatRequired BIT DEFAULT (0),
        JobComplete BIT DEFAULT (0),
        Status NVARCHAR(100),
        FOREIGN KEY (PartId) REFERENCES Parts(Id),
        FOREIGN KEY (CustomerId) REFERENCES Customers(Id)

    );
END
GO

IF OBJECT_ID(N'core.MoldingRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.MoldingRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        MoldDate DATE,
        MoldShift NVARCHAR(100),
        MoldOperator NVARCHAR(200),
        PatternNo NVARCHAR(100),
        Alloy NVARCHAR(100),
        MoldNotes NVARCHAR(MAX),
        MoldingFinished BIT DEFAULT (0),
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        UpdatedAt DATETIME2 NULL,
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.PouringRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.PouringRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        PourDate DATE,
        Alloy NVARCHAR(100),
        Notes NVARCHAR(MAX),
        UpdatedAt DATETIME2 NULL,
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.HeatTreatRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.HeatTreatRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        TreatDate DATE,
        Temperature FLOAT,
        DurationHours FLOAT,
        Notes NVARCHAR(MAX),
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.MachiningRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.MachiningRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        MachineDate DATETIME2,
        Operator NVARCHAR(100),
        Notes NVARCHAR(MAX),
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.AssemblyRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.AssemblyRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        AssemblyDate DATETIME2,
        Operator NVARCHAR(100),
        Notes NVARCHAR(MAX),
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.ScrapRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.ScrapRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        ScrapDate DATETIME2,
        Reason NVARCHAR(100),
        QtyScrapped INT,
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.InspectionRecords', N'U') IS NULL
BEGIN
    CREATE TABLE core.InspectionRecords (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        InspectDate DATETIME2,
        Inspector NVARCHAR(100),
        Result NVARCHAR(MAX),
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.ChemistryResults', N'U') IS NULL
BEGIN
    CREATE TABLE core.ChemistryResults (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        HeatNumber NVARCHAR(100),
        SampleNumber NVARCHAR(100),
        DatePoured DATETIME2,
        Furnace NVARCHAR(100),
        AlloyCode NVARCHAR(100),
        GrossWeight FLOAT,
        TapTemp FLOAT,
        C FLOAT,
        CreatedAt DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.AttachedFiles', N'U') IS NULL
BEGIN
    CREATE TABLE core.AttachedFiles (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        WorkOrderId INT,
        FileType NVARCHAR(100),
        FileName NVARCHAR(255),
        FilePath NVARCHAR(500),
        AddDateTime DATETIME2 DEFAULT (SYSUTCDATETIME()),
        UploadedBy NVARCHAR(100),
        Deleted BIT DEFAULT 0,
        GridNumber INT,
        FOREIGN KEY (WorkOrderId) REFERENCES WorkOrders(RecordNo)

    );
END
GO

IF OBJECT_ID(N'core.AuditLogs', N'U') IS NULL
BEGIN
    CREATE TABLE core.AuditLogs (

        Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
        UserId INT,
        Action NVARCHAR(400),
        TableName NVARCHAR(100),
        RecordId INT,
        Timestamp DATETIME2 DEFAULT GETDATE(),
        Notes NVARCHAR(MAX),
        FOREIGN KEY (UserId) REFERENCES Users(Id)

    );
END
GO

/* -------------------------
   Keys & Indexes (Core)
-------------------------- */

-- Uniqueness / lookup speed
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Parts_PartNumber' AND object_id=OBJECT_ID('core.Parts'))
    CREATE UNIQUE NONCLUSTERED INDEX UX_Parts_PartNumber ON core.Parts(PartNumber) WHERE PartNumber IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Customers_Name' AND object_id=OBJECT_ID('core.Customers'))
    CREATE UNIQUE NONCLUSTERED INDEX UX_Customers_Name ON core.Customers(Name) WHERE Name IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Users_Email' AND object_id=OBJECT_ID('core.Users'))
    CREATE UNIQUE NONCLUSTERED INDEX UX_Users_Email ON core.Users(Email) WHERE Email IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_WorkOrders_WorkOrderNo' AND object_id=OBJECT_ID('core.WorkOrders'))
    CREATE UNIQUE NONCLUSTERED INDEX UX_WorkOrders_WorkOrderNo ON core.WorkOrders(WorkOrderNo) WHERE WorkOrderNo IS NOT NULL;
GO

-- Foreign-key supporting indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_WorkOrders_PartId' AND object_id=OBJECT_ID('core.WorkOrders'))
    CREATE NONCLUSTERED INDEX IX_WorkOrders_PartId ON core.WorkOrders(PartId);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_WorkOrders_CustomerId' AND object_id=OBJECT_ID('core.WorkOrders'))
    CREATE NONCLUSTERED INDEX IX_WorkOrders_CustomerId ON core.WorkOrders(CustomerId);
GO

-- WorkOrderId indexes on child tables
DECLARE @child TABLE (t sysname);
INSERT INTO @child(t) VALUES
('MoldingRecords'),('PouringRecords'),('HeatTreatRecords'),('MachiningRecords'),
('AssemblyRecords'),('ScrapRecords'),('InspectionRecords'),('ChemistryResults'),('AttachedFiles');
DECLARE @t sysname, @sql nvarchar(max);
DECLARE c CURSOR LOCAL FAST_FORWARD FOR SELECT t FROM @child;
OPEN c;
FETCH NEXT FROM c INTO @t;
WHILE @@FETCH_STATUS=0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_' + @t + '_WorkOrderId' AND object_id = OBJECT_ID('core.' + @t))
    BEGIN
        SET @sql = N'CREATE NONCLUSTERED INDEX IX_' + @t + '_WorkOrderId ON core.' + QUOTENAME(@t) + N'(WorkOrderId);';
        EXEC sp_executesql @sql;
    END
    FETCH NEXT FROM c INTO @t;
END
CLOSE c; DEALLOCATE c;
GO

-- Audit log query patterns
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_AuditLogs_UserId' AND object_id=OBJECT_ID('core.AuditLogs'))
    CREATE NONCLUSTERED INDEX IX_AuditLogs_UserId ON core.AuditLogs(UserId, [Timestamp]);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_AuditLogs_Table_Record' AND object_id=OBJECT_ID('core.AuditLogs'))
    CREATE NONCLUSTERED INDEX IX_AuditLogs_Table_Record ON core.AuditLogs(TableName, RecordId, [Timestamp]);
GO

-- Attached files common filters
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_AttachedFiles_WorkOrderId_Deleted' AND object_id=OBJECT_ID('core.AttachedFiles'))
    CREATE NONCLUSTERED INDEX IX_AttachedFiles_WorkOrderId_Deleted ON core.AttachedFiles(WorkOrderId, Deleted);
GO

/* -------------------------
   Reporting / Normalized View Layer
   - Normalizes column names to snake_case
   - Keeps core tables untouched
-------------------------- */

-- WorkOrders (snake_case)
CREATE OR ALTER VIEW rpt.vw_workorders AS
SELECT
    RecordNo            AS workorder_id,
    WorkOrderNo         AS workorder_no,
    PartId              AS part_id,
    CustomerId          AS customer_id,
    AlloyCode           AS alloy_code,
    QtyRequired         AS qty_required,
    RushDueDate         AS rush_due_date,
    SerialNo            AS serial_no,
    AssemblyFinished    AS assembly_finished,
    FinalInspectionComplete AS final_inspection_complete,
    HeatTreatRequired   AS heat_treat_required,
    JobComplete         AS job_complete,
    Status              AS status
FROM core.WorkOrders;
GO

CREATE OR ALTER VIEW rpt.vw_parts AS
SELECT
    Id          AS part_id,
    PartNumber  AS part_number,
    Description AS description,
    Alloy       AS alloy
FROM core.Parts;
GO

CREATE OR ALTER VIEW rpt.vw_customers AS
SELECT
    Id       AS customer_id,
    Name     AS name,
    Location AS location
FROM core.Customers;
GO

CREATE OR ALTER VIEW rpt.vw_users AS
SELECT
    Id        AS user_id,
    Email     AS email,
    PasswordHash AS password_hash,
    Role      AS role,
    CreatedAt AS created_at
FROM core.Users;
GO

CREATE OR ALTER VIEW rpt.vw_molding_records AS
SELECT
    Id            AS molding_record_id,
    WorkOrderId   AS workorder_id,
    MoldDate      AS mold_date,
    MoldShift     AS mold_shift,
    MoldOperator  AS mold_operator,
    PatternNo     AS pattern_no,
    Alloy         AS alloy,
    MoldNotes     AS mold_notes,
    MoldingFinished AS molding_finished,
    CreatedAt     AS created_at,
    UpdatedAt     AS updated_at
FROM core.MoldingRecords;
GO

CREATE OR ALTER VIEW rpt.vw_pouring_records AS
SELECT
    Id          AS pouring_record_id,
    WorkOrderId AS workorder_id,
    PourDate    AS pour_date,
    Alloy       AS alloy,
    Notes       AS notes,
    UpdatedAt   AS updated_at
FROM core.PouringRecords;
GO

CREATE OR ALTER VIEW rpt.vw_heat_treat_records AS
SELECT
    Id            AS heat_treat_record_id,
    WorkOrderId   AS workorder_id,
    TreatDate     AS treat_date,
    Temperature   AS temperature,
    DurationHours AS duration_hours,
    Notes         AS notes
FROM core.HeatTreatRecords;
GO

CREATE OR ALTER VIEW rpt.vw_machining_records AS
SELECT
    Id          AS machining_record_id,
    WorkOrderId AS workorder_id,
    MachineDate AS machine_date,
    Operator    AS operator,
    Notes       AS notes
FROM core.MachiningRecords;
GO

CREATE OR ALTER VIEW rpt.vw_assembly_records AS
SELECT
    Id           AS assembly_record_id,
    WorkOrderId  AS workorder_id,
    AssemblyDate AS assembly_date,
    Operator     AS operator,
    Notes        AS notes
FROM core.AssemblyRecords;
GO

CREATE OR ALTER VIEW rpt.vw_scrap_records AS
SELECT
    Id          AS scrap_record_id,
    WorkOrderId AS workorder_id,
    ScrapDate   AS scrap_date,
    Reason      AS reason,
    QtyScrapped AS qty_scrapped
FROM core.ScrapRecords;
GO

CREATE OR ALTER VIEW rpt.vw_inspection_records AS
SELECT
    Id          AS inspection_record_id,
    WorkOrderId AS workorder_id,
    InspectDate AS inspect_date,
    Inspector   AS inspector,
    Result      AS result
FROM core.InspectionRecords;
GO

CREATE OR ALTER VIEW rpt.vw_chemistry_results AS
SELECT
    Id          AS chemistry_result_id,
    WorkOrderId AS workorder_id,
    HeatNumber  AS heat_number,
    SampleNumber AS sample_number,
    DatePoured  AS date_poured,
    Furnace     AS furnace,
    AlloyCode   AS alloy_code,
    GrossWeight AS gross_weight,
    TapTemp     AS tap_temp,
    C           AS c,
    CreatedAt   AS created_at
FROM core.ChemistryResults;
GO

CREATE OR ALTER VIEW rpt.vw_attached_files AS
SELECT
    Id          AS file_id,
    WorkOrderId AS workorder_id,
    FileType    AS file_type,
    FileName    AS file_name,
    FilePath    AS file_path,
    AddDateTime AS add_datetime,
    UploadedBy  AS uploaded_by,
    Deleted     AS deleted,
    GridNumber  AS grid_number
FROM core.AttachedFiles;
GO

CREATE OR ALTER VIEW rpt.vw_audit_logs AS
SELECT
    Id        AS audit_id,
    UserId    AS user_id,
    Action    AS action,
    TableName AS table_name,
    RecordId  AS record_id,
    [Timestamp] AS [timestamp],
    Notes     AS notes
FROM core.AuditLogs;
GO
