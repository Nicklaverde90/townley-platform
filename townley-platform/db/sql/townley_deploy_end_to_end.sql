-- =========================================================
-- Townley Platform - SQL Server Deploy End-to-End (Single File)
-- Target: Microsoft SQL Server (matches .env / ODBC Driver 18)
--
-- .env alignment:
--   DB_NAME = NewDB1
--   DB_USER = townley_app
--   (password handled below if you run as sysadmin, e.g., sa)
--
-- Run (example):
--   sqlcmd -S tcp:localhost,1433 -U sa -P "<SA_PASSWORD>" -C -i townley_deploy_end_to_end_NewDB1.sql
-- =========================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @DbName sysname = N'NewDB1';
DECLARE @AppLogin sysname = N'townley_app';
DECLARE @AppPassword nvarchar(256) = N'ChangeThis!_VeryStrong#2025'; -- from .env
DECLARE @AdminEmail nvarchar(320) = N'admin@townley.local';          -- change if desired
DECLARE @AdminPasswordPlain nvarchar(256) = N'ChangeThis!_VeryStrong#2025'; -- initial admin password (plaintext)
-- NOTE: For production, set AdminPasswordHash instead and remove plaintext handling.

-- =========================================================
-- 1) Create database if missing
-- =========================================================
IF DB_ID(@DbName) IS NULL
BEGIN
    DECLARE @createDb nvarchar(max) = N'CREATE DATABASE ' + QUOTENAME(@DbName) + N';';
    EXEC (@createDb);
END;
GO

-- Switch context
DECLARE @DbName sysname = N'NewDB1';
DECLARE @useDb nvarchar(max) = N'USE ' + QUOTENAME(@DbName) + N';';
EXEC (@useDb);
GO

-- =========================================================
-- 2) Create required schemas
-- =========================================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'legacy') EXEC(N'CREATE SCHEMA legacy AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'stage')  EXEC(N'CREATE SCHEMA stage  AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'core')   EXEC(N'CREATE SCHEMA core   AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'api')    EXEC(N'CREATE SCHEMA api    AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'rpt')    EXEC(N'CREATE SCHEMA rpt    AUTHORIZATION dbo;');
GO

-- =========================================================
-- 3) Security: create login + user (idempotent)
--    This requires sufficient permissions (sysadmin to CREATE LOGIN).
-- =========================================================
DECLARE @AppLogin sysname = N'townley_app';
DECLARE @AppPassword nvarchar(256) = N'ChangeThis!_VeryStrong#2025';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @AppLogin)
BEGIN
    DECLARE @createLogin nvarchar(max) =
        N'CREATE LOGIN ' + QUOTENAME(@AppLogin) +
        N' WITH PASSWORD = ' + QUOTENAME(@AppPassword, '''') +
        N', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;';
    EXEC (@createLogin);
END;
GO

USE [NewDB1];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'townley_app')
BEGIN
    CREATE USER [townley_app] FOR LOGIN [townley_app] WITH DEFAULT_SCHEMA = [api];
END;
GO

-- Create lightweight roles for the app (API reads views; writes core tables via roles)
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type = 'R' AND name = N'role_api_reader')
    CREATE ROLE [role_api_reader] AUTHORIZATION dbo;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type = 'R' AND name = N'role_core_writer')
    CREATE ROLE [role_core_writer] AUTHORIZATION dbo;
GO

EXEC sp_addrolemember @rolename = N'role_api_reader', @membername = N'townley_app';
EXEC sp_addrolemember @rolename = N'role_core_writer', @membername = N'townley_app';
GO

-- =========================================================
-- 4) Core tables (minimal, API-first foundation)
-- =========================================================

-- Users (auth)
IF OBJECT_ID(N'core.user_account', N'U') IS NULL
BEGIN
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
END;
GO

-- Simple table for application settings / metadata
IF OBJECT_ID(N'core.app_setting', N'U') IS NULL
BEGIN
    CREATE TABLE core.app_setting
    (
        setting_key        nvarchar(200) NOT NULL CONSTRAINT PK_core_app_setting PRIMARY KEY,
        setting_value      nvarchar(max) NULL,
        updated_at_utc     datetime2(3)  NOT NULL CONSTRAINT DF_core_setting_updated DEFAULT (SYSUTCDATETIME())
    );
END;
GO

-- =========================================================
-- 5) Seed admin user (idempotent)
-- =========================================================
DECLARE @AdminEmail nvarchar(320) = N'admin@townley.local';
DECLARE @AdminPasswordPlain nvarchar(256) = N'ChangeThis!_VeryStrong#2025';

IF NOT EXISTS (SELECT 1 FROM core.user_account WHERE email = @AdminEmail)
BEGIN
    DECLARE @salt varbinary(32) = CRYPT_GEN_RANDOM(32);
    DECLARE @hash varbinary(64) = HASHBYTES('SHA2_512', @salt + CONVERT(varbinary(max), @AdminPasswordPlain));

    INSERT INTO core.user_account (email, display_name, password_hash, password_salt, is_active, is_admin)
    VALUES (@AdminEmail, N'Administrator', @hash, @salt, 1, 1);
END;
GO

-- =========================================================
-- 6) API views (read-only surface aligned to FastAPI models)
-- =========================================================
IF OBJECT_ID(N'api.user_account_vw', N'V') IS NULL
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
GO

-- =========================================================
-- 7) Lock down permissions
-- =========================================================
GRANT SELECT ON OBJECT::api.user_account_vw TO [role_api_reader];
DENY INSERT, UPDATE, DELETE ON SCHEMA::core TO [role_api_reader];

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::core TO [role_core_writer];
GO

-- =========================================================
-- 8) Defense-in-depth: block writes to api views
-- =========================================================
IF OBJECT_ID(N'api.trg_block_write_user_account_vw', N'TR') IS NULL
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
GO

-- =========================================================
-- 9) Smoke checks
-- =========================================================
PRINT 'Deploy complete: ' + DB_NAME();
SELECT TOP (5) * FROM api.user_account_vw ORDER BY created_at_utc DESC;
GO
