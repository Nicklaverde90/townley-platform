-- Patch additional columns expected by legacy views on WorkOrders.
USE [NewDB1];
GO

IF COL_LENGTH('dbo.WorkOrders', 'is_deleted') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD is_deleted bit NOT NULL CONSTRAINT DF_WorkOrders_is_deleted DEFAULT (0);
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'QtyToManufacture') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD QtyToManufacture int NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'MoldingDueDate') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD MoldingDueDate date NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'Remake') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD Remake bit NULL CONSTRAINT DF_WorkOrders_Remake DEFAULT (0);
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'Scrapped') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD Scrapped bit NULL CONSTRAINT DF_WorkOrders_Scrapped DEFAULT (0);
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'ReasonScrapped') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD ReasonScrapped nvarchar(255) NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'ResponsibleScrapLocation') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD ResponsibleScrapLocation nvarchar(255) NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'RootCauseForScrap') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD RootCauseForScrap nvarchar(255) NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'Customer') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD Customer nvarchar(200) NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'created_at') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD created_at datetime NULL CONSTRAINT DF_WorkOrders_created_at DEFAULT (GETUTCDATE());
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'updated_at') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD updated_at datetime NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'UpdatedAt') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD UpdatedAt datetime NULL;
END;
GO

IF COL_LENGTH('dbo.WorkOrders', 'CustomerNumber') IS NULL
BEGIN
    ALTER TABLE dbo.WorkOrders ADD CustomerNumber nvarchar(100) NULL;
END;
GO

-- Recreate views that previously failed so they compile against the new columns.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_ActiveWorkOrders] AS
SELECT *
FROM WorkOrders
WHERE is_deleted = 0;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_OpenWorkOrdersSummary] AS
SELECT 
  wo.RecordNo,
  wo.WorkOrderNo,
  wo.QtyRequired,
  wo.QtyToManufacture,
  wo.MoldingDueDate,
  wo.RushDueDate,
  wo.Remake AS IsRemake,
  wo.MoldingFinished,
  wo.PouringFinished,
  wo.HeatTreatFinished,
  wo.MachiningFinished,
  wo.AssemblyFinished
FROM WorkOrders wo
WHERE 
  (wo.AssemblyFinished = 0 OR wo.AssemblyFinished IS NULL)
  AND (wo.MachiningFinished = 0 OR wo.MachiningFinished IS NULL);
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_ScrapDetailSummary] AS
SELECT 
  ReasonScrapped,
  ResponsibleScrapLocation,
  RootCauseForScrap,
  COUNT(*) AS ScrapCount
FROM WorkOrders
WHERE Scrapped = 1
GROUP BY 
  ReasonScrapped, 
  ResponsibleScrapLocation, 
  RootCauseForScrap;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_WorkOrderActiveSummary] AS
SELECT 
    RecordNo,
    Customer,
    PartNo,
    status,
    created_at,
    updated_at
FROM WorkOrders
WHERE is_deleted = 0;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_WorkOrderBacklog] AS
SELECT 
  wo.RecordNo,
  wo.WorkOrderNo,
  wo.QtyRequired,
  ISNULL(COUNT(mr.RecordNo), 0) AS MoldedCount,
  wo.MoldingDueDate,
  wo.RushDueDate,
  wo.Remake AS IsRemake,
  wo.MoldingFinished AS IsMoldingFinished,
  wo.PouringFinished AS IsPouringFinished,
  wo.HeatTreatFinished AS IsHeatTreatFinished,
  wo.MachiningFinished AS IsMachiningFinished,
  wo.AssemblyFinished AS IsAssemblyFinished
FROM WorkOrders wo
LEFT JOIN MoldingRecords mr 
  ON wo.WorkOrderNo = mr.WorkOrderNo
GROUP BY 
  wo.RecordNo,
  wo.WorkOrderNo,
  wo.QtyRequired,
  wo.MoldingDueDate,
  wo.RushDueDate,
  wo.Remake,
  wo.MoldingFinished,
  wo.PouringFinished,
  wo.HeatTreatFinished,
  wo.MachiningFinished,
  wo.AssemblyFinished;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_WorkOrderStatusSummary] AS
SELECT 
    wo.RecordNo,
    wo.WorkOrderNo,
    wo.PartNo,
    wo.CustomerNumber,
    c.CustomerName,
    wo.MoldingFinished,
    wo.PouringFinished,
    wo.HeatTreatFinished,
    wo.MachiningFinished,
    wo.AssemblyFinished,
    wo.Scrapped,
    wo.RushDueDate,
    wo.StatusNotes,
    wo.UpdatedAt
FROM WorkOrders wo
LEFT JOIN Customers c ON wo.CustomerNumber = c.CustomerNumber;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [dbo].[vw_WorkOrderSummary] AS
SELECT 
    RecordNo,
    status,
    created_at,
    updated_at,
    FinalInspComp,
    Customer,
    PartNo
FROM WorkOrders;
GO
