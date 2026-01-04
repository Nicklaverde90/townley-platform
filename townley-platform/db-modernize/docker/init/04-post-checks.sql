-- Verify the database exists before running downstream checks.
IF DB_ID(N'NewDB1') IS NULL
BEGIN
    RAISERROR(N'Database NewDB1 was not created by the import.', 16, 1);
    RETURN;
END;
GO

USE [NewDB1];
GO

-- Create a database user for the previously defined login.
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'townley_app')
BEGIN
    CREATE USER [townley_app] FOR LOGIN [townley_app];
END;
GO

-- Temporary broad permissions for early testing (tighten later).
EXEC sp_addrolemember N'db_datareader', N'townley_app';
EXEC sp_addrolemember N'db_datawriter', N'townley_app';
GO

-- Report compatibility level.
SELECT name, compatibility_level
FROM sys.databases
WHERE name = N'NewDB1';
GO

-- Surface tables lacking a primary key for manual review.
SELECT
    s.name AS schema_name,
    t.name AS table_name
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
LEFT JOIN sys.key_constraints kc
    ON kc.parent_object_id = t.object_id
    AND kc.type = 'PK'
WHERE kc.name IS NULL
ORDER BY s.name, t.name;
GO

-- Refresh module metadata to catch any invalid views/procs immediately.
EXEC sp_refreshsqlmodule NULL;
GO
