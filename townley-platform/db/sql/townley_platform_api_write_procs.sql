-- =========================================================
-- Townley Platform - API Write Procs
--
-- Backend talks to api.* only.
--   - Reads: api.vw_* views
--   - Writes: api.sp_* stored procedures
--
-- These procs write to legacy dbo.* tables to preserve FULL legacy parity.
-- =========================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'api')
BEGIN
    EXEC('CREATE SCHEMA api');
END
GO

-- ---------------------------------------------------------
-- Create user (dbo.users)
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE api.sp_create_user
    @username NVARCHAR(255),
    @hashed_password NVARCHAR(255),
    @role NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF @username IS NULL OR LTRIM(RTRIM(@username)) = ''
        THROW 51000, 'username is required', 1;

    IF EXISTS (SELECT 1 FROM dbo.users WHERE username = @username)
        THROW 51000, 'username already exists', 1;

    INSERT INTO dbo.users (username, hashed_password, role, created_at)
    VALUES (@username, @hashed_password, @role, GETDATE());

    SELECT TOP 1 id, username, hashed_password, role, created_at
    FROM dbo.users
    WHERE username = @username;
END
GO

-- ---------------------------------------------------------
-- Create workorder (dbo.workorders)
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE api.sp_create_workorder
    @workorderno NVARCHAR(100),
    @partno NVARCHAR(100),
    @customername NVARCHAR(200) = NULL,
    @alloycode NVARCHAR(100) = NULL,
    @qtyrequired INT,
    @rushduedate DATE = NULL,
    @serialno NVARCHAR(100) = NULL,
    @statusnotes NVARCHAR(255) = NULL,
    @status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.workorders
    (
        WorkOrderNo, PartNo, CustomerName, AlloyCode, QtyRequired, RushDueDate,
        SerialNo, StatusNotes, Status
    )
    VALUES
    (
        @workorderno, @partno, @customername, @alloycode, @qtyrequired, @rushduedate,
        @serialno, @statusnotes, @status
    );

    SELECT TOP 1 *
    FROM dbo.workorders
    WHERE RecordNo = SCOPE_IDENTITY();
END
GO

-- ---------------------------------------------------------
-- Update workorder (dbo.workorders)
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE api.sp_update_workorder
    @recordno INT,
    @customername NVARCHAR(200) = NULL,
    @alloycode NVARCHAR(100) = NULL,
    @qtyrequired INT = NULL,
    @rushduedate DATE = NULL,
    @serialno NVARCHAR(100) = NULL,
    @statusnotes NVARCHAR(255) = NULL,
    @status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.workorders WHERE RecordNo = @recordno)
        THROW 51000, 'workorder not found', 1;

    UPDATE dbo.workorders
    SET
        CustomerName = COALESCE(@customername, CustomerName),
        AlloyCode = COALESCE(@alloycode, AlloyCode),
        QtyRequired = COALESCE(@qtyrequired, QtyRequired),
        RushDueDate = COALESCE(@rushduedate, RushDueDate),
        SerialNo = COALESCE(@serialno, SerialNo),
        StatusNotes = COALESCE(@statusnotes, StatusNotes),
        Status = COALESCE(@status, Status)
    WHERE RecordNo = @recordno;

    SELECT TOP 1 * FROM dbo.workorders WHERE RecordNo = @recordno;
END
GO

-- ---------------------------------------------------------
-- Hard delete workorder (dbo.workorders) - ADMIN ONLY
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE api.sp_delete_workorder_hard
    @recordno INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.workorders WHERE RecordNo = @recordno;
    SELECT @@ROWCOUNT AS rows_deleted;
END
GO

-- ---------------------------------------------------------
-- Write audit entry (dbo.WorkOrderAudit)
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE api.sp_audit_workorder
    @action NVARCHAR(32),
    @record_no INT,
    @before_json NVARCHAR(MAX) = NULL,
    @after_json NVARCHAR(MAX) = NULL,
    @user_name NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.WorkOrderAudit (Action, RecordNo, BeforeJson, AfterJson, UserName, AtUtc)
    VALUES (@action, @record_no, @before_json, @after_json, @user_name, GETUTCDATE());

    SELECT SCOPE_IDENTITY() AS Id;
END
GO
