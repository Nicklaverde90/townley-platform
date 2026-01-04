-- =========================================================
-- Townley Roles & Permissions (Assumption‑Free)
-- SQL Server (Docker or Windows)
-- =========================================================
-- This script defines *roles only* (not server logins).
-- Bind roles to database users separately per environment.
--
-- Roles:
--   - townley_api_reader  : SELECT on api.*
--   - townley_core_writer : SELECT/INSERT/UPDATE/DELETE on core.*
--
-- Recommended:
--   - Your FastAPI read user is in townley_api_reader
--   - Your FastAPI write user is in townley_core_writer
--   - Or a single app user in BOTH roles (if you prefer)
-- =========================================================

USE Townley;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'townley_api_reader' AND type = 'R')
    CREATE ROLE townley_api_reader AUTHORIZATION dbo;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'townley_core_writer' AND type = 'R')
    CREATE ROLE townley_core_writer AUTHORIZATION dbo;
GO

GRANT SELECT ON SCHEMA::api TO townley_api_reader;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::core TO townley_core_writer;
GO

-- Defense in depth: make api.* read-only for broad principals by default.
DENY INSERT, UPDATE, DELETE ON SCHEMA::api TO PUBLIC;
GO

-- Example bindings (uncomment + change user names):
-- EXEC sp_addrolemember 'townley_api_reader',  'your_db_user';
-- EXEC sp_addrolemember 'townley_core_writer','your_db_user';
