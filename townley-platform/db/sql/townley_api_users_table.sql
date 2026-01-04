IF DB_ID(N'NewDB1') IS NULL
BEGIN
    RAISERROR('Database NewDB1 does not exist. Run the baseline import first.', 16, 1);
    RETURN;
END;
GO

USE [NewDB1];
GO

IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Users] (
        [id] INT IDENTITY(1, 1) NOT NULL,
        [email] NVARCHAR(255) NOT NULL,
        [hashed_password] NVARCHAR(255) NOT NULL,
        [full_name] NVARCHAR(255) NULL,
        [is_active] BIT NOT NULL CONSTRAINT [DF_Users_is_active] DEFAULT (1),
        [is_admin] BIT NOT NULL CONSTRAINT [DF_Users_is_admin] DEFAULT (0),
        [role] NVARCHAR(16) NOT NULL CONSTRAINT [DF_Users_role] DEFAULT ('viewer'),
        [created_at] DATETIME2(0) NOT NULL CONSTRAINT [DF_Users_created_at] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([id] ASC)
    );

    CREATE UNIQUE INDEX [IX_Users_email] ON [dbo].[Users] ([email]);
END;
GO

IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.Users', 'is_admin') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [is_admin] BIT NOT NULL CONSTRAINT [DF_Users_patch_is_admin] DEFAULT (0);
    END;

    IF COL_LENGTH('dbo.Users', 'role') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [role] NVARCHAR(16) NOT NULL CONSTRAINT [DF_Users_patch_role] DEFAULT ('viewer');
    END;

    IF COL_LENGTH('dbo.Users', 'is_active') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [is_active] BIT NOT NULL CONSTRAINT [DF_Users_patch_is_active] DEFAULT (1);
    END;

    IF COL_LENGTH('dbo.Users', 'created_at') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [created_at] DATETIME2(0) NOT NULL CONSTRAINT [DF_Users_patch_created_at] DEFAULT (SYSUTCDATETIME());
    END;

    IF COL_LENGTH('dbo.Users', 'full_name') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [full_name] NVARCHAR(255) NULL;
    END;

    IF COL_LENGTH('dbo.Users', 'hashed_password') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [hashed_password] NVARCHAR(255) NOT NULL CONSTRAINT [DF_Users_patch_hashed_password] DEFAULT ('');
    END;

    IF COL_LENGTH('dbo.Users', 'email') IS NULL
    BEGIN
        ALTER TABLE [dbo].[Users]
            ADD [email] NVARCHAR(255) NOT NULL;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE name = N'IX_Users_email' AND object_id = OBJECT_ID(N'dbo.Users')
    )
    BEGIN
        CREATE UNIQUE INDEX [IX_Users_email] ON [dbo].[Users] ([email]);
    END;
END;
GO
