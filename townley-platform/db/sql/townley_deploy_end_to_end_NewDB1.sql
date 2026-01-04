/* =========================================================
   Townley Platform - SQL Server Deploy End-to-End (Single File)
   Target: Microsoft SQL Server 2022 (ODBC Driver 18)
   Matches .env:
     DB_NAME     = NewDB1
     DB_USER     = townley_app
     DB_PASSWORD = ChangeThis!_VeryStrong#2025
   Run as SA inside container (example):
     /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Your_Strong_Password123!" -C -i /tmp/townley_deploy.sql
   ========================================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @DbName sysname = N'NewDB1';

-- =========================================================
-- 1) Create database if missing (must be in master)
-- =========================================================
USE [master];
GO

IF DB_ID(N'NewDB1') IS NULL
BEGIN
    PRINT 'Creating database [NewDB1]...';
    CREATE DATABASE [NewDB1];
END
ELSE
BEGIN
    PRINT 'Database [NewDB1] already exists.';
END
GO

-- =========================================================
-- 2) Switch to target DB (PLAIN USE, NOT dynamic EXEC)
-- =========================================================
USE [NewDB1];
GO

-- =========================================================
-- 3) Create required schemas (MUST exist before core.* objects)
-- =========================================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'legacy') EXEC(N'CREATE SCHEMA legacy AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'stage')  EXEC(N'CREATE SCHEMA stage  AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'core')   EXEC(N'CREATE SCHEMA core   AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'api')    EXEC(N'CREATE SCHEMA api    AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'rpt')    EXEC(N'CREATE SCHEMA rpt    AUTHORIZATION dbo;');
GO

-- Quick proof that schemas exist
PRINT 'Schema check:';
SELECT name AS schema_name FROM sys.schemas WHERE name IN (N'legacy', N'stage', N'core', N'api', N'rpt');
GO

-- =========================================================
-- 4) Security: create login + user (login is server-level)
-- =========================================================
DECLARE @AppLogin sysname = N'townley_app';
DECLARE @AppPassword nvarchar(256) = N'ChangeThis!_VeryStrong#2025';

-- Create login in master context
USE [master];
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'townley_app')
BEGIN
    PRINT 'Creating login [townley_app]...';
    CREATE LOGIN [townley_app]
      WITH PASSWORD = N'ChangeThis!_VeryStrong#2025',
           CHECK_POLICY = OFF,
           CHECK_EXPIRATION = OFF;
END
ELSE
BEGIN
    PRINT 'Login [townley_app] already exists.';
END
GO

-- Back to target DB for user + roles
USE [NewDB1];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'townley_app')
BEGIN
    PRINT 'Creating database user [townley_app]...';
    CREATE USER [townley_app] FOR LOGIN [townley_app] WITH DEFAULT_SCHEMA = [api];
END
ELSE
BEGIN
    PRINT 'Database user [townley_app] already exists.';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type = 'R' AND name = N'role_api_reader')
    CREATE ROLE [role_api_reader] AUTHORIZATION dbo;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type = 'R' AND name = N'role_core_writer')
    CREATE ROLE [role_core_writer] AUTHORIZATION dbo;
GO

EXEC sp_addrolemember @rolename = N'role_api_reader', @membername = N'townley_app';
EXEC sp_addrolemember @rolename = N'role_core_writer', @membername = N'townley_app';
GO

-- =========================================================
-- 5) Core tables (minimal, API-first foundation)
-- =========================================================
IF OBJECT_ID(N'core.user_account', N'U') IS NULL
BEGIN
    PRINT 'Creating table core.user_account...';

    CREATE TABLE core.user_account
    (
        user_id            uniqueidentifier NOT NULL CONSTRAINT PK_core_user_account PRIMARY KEY DEFAULT NEWID(),
        email              nvarchar(320)    NOT NULL,
        display_name       nvarchar(200)    NULL,
        password_hash      varbinary(64)    NOT NULL, -- SHA2_512
        password_salt      varbinary(32)    NOT NULL,
        is_active          bit              NOT NULL CONSTRAINT DF_core_user_is_active DEFAULT (1),
        is_admin           bit              NOT NULL CONSTRAINT DF_core_user_is_admin DEFAULT (0),
        created_at_utc     datetime2(3)     NOT NULL CONSTRAINT DF_core_user_created DEFAULT (SYSUTCDATETIME()),
        updated_at_utc     datetime2(3)     NOT NULL CONSTRAINT DF_core_user_updated DEFAULT (SYSUTCDATETIME())
    );

    CREATE UNIQUE INDEX UX_core_user_email ON core.user_account(email);
END
ELSE
BEGIN
    PRINT 'Table core.user_account already exists.';
END
GO

IF OBJECT_ID(N'core.app_setting', N'U') IS NULL
BEGIN
    PRINT 'Creating table core.app_setting...';

    CREATE TABLE core.app_setting
    (
        setting_key        nvarchar(200) NOT NULL CONSTRAINT PK_core_app_setting PRIMARY KEY,
        setting_value      nvarchar(max) NULL,
        updated_at_utc     datetime2(3)  NOT NULL CONSTRAINT DF_core_setting_updated DEFAULT (SYSUTCDATETIME())
    );
END
ELSE
BEGIN
    PRINT 'Table core.app_setting already exists.';
END
GO

-- =========================================================
-- 6) Seed admin user (idempotent)
-- =========================================================
DECLARE @AdminEmail nvarchar(320) = N'admin@townley.local';
DECLARE @AdminPasswordPlain nvarchar(256) = N'ChangeThis!_VeryStrong#2025';

IF NOT EXISTS (SELECT 1 FROM core.user_account WHERE email = @AdminEmail)
BEGIN
    PRINT 'Seeding admin user...';

    DECLARE @salt varbinary(32) = CRYPT_GEN_RANDOM(32);
    DECLARE @hash varbinary(64) = HASHBYTES('SHA2_512', @salt + CONVERT(varbinary(max), @AdminPasswordPlain));

    INSERT INTO core.user_account (email, display_name, password_hash, password_salt, is_active, is_admin)
    VALUES (@AdminEmail, N'Administrator', @hash, @salt, 1, 1);
END
ELSE
BEGIN
    PRINT 'Admin user already exists.';
END
GO

-- =========================================================
-- 7) API views (read-only surface aligned to FastAPI models)
-- =========================================================
IF OBJECT_ID(N'api.user_account_vw', N'V') IS NULL
BEGIN
    PRINT 'Creating view api.user_account_vw...';

    EXEC(N'
    CREATE VIEW api.user_account_vw
    AS
    SELECT
        u.user_id,
        u.email,
        u.display_name,
        u.is_active,
        u.is_admin,
        u.created_at_utc,
        u.updated_at_utc
    FROM core.user_account u;
    ');
END
ELSE
BEGIN
    PRINT 'View api.user_account_vw already exists.';
END
GO

-- =========================================================
-- 8) Permissions
-- =========================================================
GRANT SELECT ON OBJECT::api.user_account_vw TO [role_api_reader];
DENY INSERT, UPDATE, DELETE ON SCHEMA::core TO [role_api_reader];

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::core TO [role_core_writer];
GO

-- =========================================================
-- 9) Block writes to API views (defense-in-depth)
-- =========================================================
IF OBJECT_ID(N'api.trg_block_write_user_account_vw', N'TR') IS NULL
BEGIN
    PRINT 'Creating trigger api.trg_block_write_user_account_vw...';

    EXEC(N'
    CREATE TRIGGER api.trg_block_write_user_account_vw
    ON api.user_account_vw
    INSTEAD OF INSERT, UPDATE, DELETE
    AS
    BEGIN
        SET NOCOUNT ON;
        THROW 51000, ''api views are read-only. Write to core tables or stored procedures.'', 1;
    END;
    ');
END
ELSE
BEGIN
    PRINT 'Trigger api.trg_block_write_user_account_vw already exists.';
END
GO

-- =========================================================
-- 10) Smoke check
-- =========================================================
PRINT 'Deploy complete: ' + DB_NAME();
SELECT TOP (5) * FROM api.user_account_vw ORDER BY created_at_utc DESC;
GO
