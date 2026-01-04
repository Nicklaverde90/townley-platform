IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'townley_app')
BEGIN
    CREATE LOGIN [townley_app] WITH PASSWORD = N'ChangeThis!StrongPass1';
END;
GO
