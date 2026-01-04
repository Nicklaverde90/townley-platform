/*
Townley Schema Patch (Non-breaking)
Generated: 2025-12-26T02:49:54
Purpose:
  - Add missing PRIMARY KEYs where safe (single IDENTITY column)
  - Add obvious non-breaking nonclustered indexes on *_Id style columns
  - Create report view layer (schema: rpt) to normalize legacy/ugly column names
Notes:
  - Does NOT rename or drop any legacy objects.
  - Review before running in production.
*/
SET NOCOUNT ON;
GO
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'rpt')
    EXEC(N'CREATE SCHEMA rpt AUTHORIZATION dbo');
GO
-- Add PK on dbo.Attachedfiles(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[Attachedfiles]')
)
BEGIN
    ALTER TABLE [dbo].[Attachedfiles] ADD CONSTRAINT [PK_Attachedfiles_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.Defect_sub_Category(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[Defect_sub_Category]')
)
BEGIN
    ALTER TABLE [dbo].[Defect_sub_Category] ADD CONSTRAINT [PK_Defect_sub_Category_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.DefectCategory(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[DefectCategory]')
)
BEGIN
    ALTER TABLE [dbo].[DefectCategory] ADD CONSTRAINT [PK_DefectCategory_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.DefectCommonName(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[DefectCommonName]')
)
BEGIN
    ALTER TABLE [dbo].[DefectCommonName] ADD CONSTRAINT [PK_DefectCommonName_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.Employees(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[Employees]')
)
BEGIN
    ALTER TABLE [dbo].[Employees] ADD CONSTRAINT [PK_Employees_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.FinishingRecords(Id) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[FinishingRecords]')
)
BEGIN
    ALTER TABLE [dbo].[FinishingRecords] ADD CONSTRAINT [PK_FinishingRecords_Id] PRIMARY KEY CLUSTERED ([Id] ASC);
END
GO
-- Add PK on dbo.LSTCub_2_Categories(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[LSTCub_2_Categories]')
)
BEGIN
    ALTER TABLE [dbo].[LSTCub_2_Categories] ADD CONSTRAINT [PK_LSTCub_2_Categories_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.MainScrapTbl(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[MainScrapTbl]')
)
BEGIN
    ALTER TABLE [dbo].[MainScrapTbl] ADD CONSTRAINT [PK_MainScrapTbl_ID] PRIMARY KEY CLUSTERED ([ID] ASC);
END
GO
-- Add PK on dbo.PouringRecords(Id) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.[type] = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'[dbo].[PouringRecords]')
)
BEGIN
    ALTER TABLE [dbo].[PouringRecords] ADD CONSTRAINT [PK_PouringRecords_Id] PRIMARY KEY CLUSTERED ([Id] ASC);
END
GO
-- Index for lookup/join: dbo.AssemblyRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AssemblyRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[AssemblyRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AssemblyRecords_WorkOrderId] ON [dbo].[AssemblyRecords] ([WorkOrderId] ASC);
END
GO
-- Index for time-based filtering: dbo.AssemblyRecords([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AssemblyRecords_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[AssemblyRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AssemblyRecords_CreatedAt] ON [dbo].[AssemblyRecords] ([CreatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.AssemblyRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AssemblyRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[AssemblyRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AssemblyRecords_UpdatedAt] ON [dbo].[AssemblyRecords] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.Attachedfiles([MainScrapTblID])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_Attachedfiles_MainScrapTblID' AND object_id = OBJECT_ID(N'[dbo].[Attachedfiles]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Attachedfiles_MainScrapTblID] ON [dbo].[Attachedfiles] ([MainScrapTblID] ASC);
END
GO
-- Index for lookup/join: dbo.AuditLogs([UserId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AuditLogs_UserId' AND object_id = OBJECT_ID(N'[dbo].[AuditLogs]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AuditLogs_UserId] ON [dbo].[AuditLogs] ([UserId] ASC);
END
GO
-- Index for lookup/join: dbo.ChemAddRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemAddRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[ChemAddRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemAddRecords_WorkOrderId] ON [dbo].[ChemAddRecords] ([WorkOrderId] ASC);
END
GO
-- Index for time-based filtering: dbo.ChemAddRecords([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemAddRecords_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[ChemAddRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemAddRecords_CreatedAt] ON [dbo].[ChemAddRecords] ([CreatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.ChemAddRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemAddRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[ChemAddRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemAddRecords_UpdatedAt] ON [dbo].[ChemAddRecords] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.ChemistryRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[ChemistryRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemistryRecords_WorkOrderId] ON [dbo].[ChemistryRecords] ([WorkOrderId] ASC);
END
GO
-- Index for lookup/join: dbo.ChemistryRecords([SampleId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_SampleId' AND object_id = OBJECT_ID(N'[dbo].[ChemistryRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemistryRecords_SampleId] ON [dbo].[ChemistryRecords] ([SampleId] ASC);
END
GO
-- Index for time-based filtering: dbo.ChemistryRecords([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[ChemistryRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemistryRecords_CreatedAt] ON [dbo].[ChemistryRecords] ([CreatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.ChemistryRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[ChemistryRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemistryRecords_UpdatedAt] ON [dbo].[ChemistryRecords] ([UpdatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.ChemistryResults([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryResults_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[ChemistryResults]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ChemistryResults_UpdatedAt] ON [dbo].[ChemistryResults] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.Documents([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_Documents_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[Documents]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Documents_WorkOrderId] ON [dbo].[Documents] ([WorkOrderId] ASC);
END
GO
-- Index for lookup/join: dbo.Employees([DeptID])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_Employees_DeptID' AND object_id = OBJECT_ID(N'[dbo].[Employees]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Employees_DeptID] ON [dbo].[Employees] ([DeptID] ASC);
END
GO
-- Index for lookup/join: dbo.FinishingRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FinishingRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[FinishingRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_FinishingRecords_WorkOrderId] ON [dbo].[FinishingRecords] ([WorkOrderId] ASC);
END
GO
-- Index for time-based filtering: dbo.FinishingRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FinishingRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[FinishingRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_FinishingRecords_UpdatedAt] ON [dbo].[FinishingRecords] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.FinishTime([RecordID])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FinishTime_RecordID' AND object_id = OBJECT_ID(N'[dbo].[FinishTime]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_FinishTime_RecordID] ON [dbo].[FinishTime] ([RecordID] ASC);
END
GO
-- Index for lookup/join: dbo.FoundryWorkData([HeatSchedulesid])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FoundryWorkData_HeatSchedulesid' AND object_id = OBJECT_ID(N'[dbo].[FoundryWorkData]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_FoundryWorkData_HeatSchedulesid] ON [dbo].[FoundryWorkData] ([HeatSchedulesid] ASC);
END
GO
-- Index for lookup/join: dbo.InspectionRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_InspectionRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[InspectionRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_InspectionRecords_WorkOrderId] ON [dbo].[InspectionRecords] ([WorkOrderId] ASC);
END
GO
-- Index for time-based filtering: dbo.InspectionRecords([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_InspectionRecords_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[InspectionRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_InspectionRecords_CreatedAt] ON [dbo].[InspectionRecords] ([CreatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.InspectionRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_InspectionRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[InspectionRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_InspectionRecords_UpdatedAt] ON [dbo].[InspectionRecords] ([UpdatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.MachineTime([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MachineTime_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[MachineTime]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_MachineTime_UpdatedAt] ON [dbo].[MachineTime] ([UpdatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.MainScrapTbl([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MainScrapTbl_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[MainScrapTbl]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_MainScrapTbl_UpdatedAt] ON [dbo].[MainScrapTbl] ([UpdatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.MoldingRecords([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MoldingRecords_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[MoldingRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_MoldingRecords_CreatedAt] ON [dbo].[MoldingRecords] ([CreatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.MoldingRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MoldingRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[MoldingRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_MoldingRecords_UpdatedAt] ON [dbo].[MoldingRecords] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.PouringRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_PouringRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[PouringRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_PouringRecords_WorkOrderId] ON [dbo].[PouringRecords] ([WorkOrderId] ASC);
END
GO
-- Index for time-based filtering: dbo.PouringRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_PouringRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[PouringRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_PouringRecords_UpdatedAt] ON [dbo].[PouringRecords] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.QualityIssues([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_QualityIssues_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[QualityIssues]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_QualityIssues_WorkOrderId] ON [dbo].[QualityIssues] ([WorkOrderId] ASC);
END
GO
-- Index for lookup/join: dbo.QualityIssues([InspectionRecordId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_QualityIssues_InspectionRecordId' AND object_id = OBJECT_ID(N'[dbo].[QualityIssues]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_QualityIssues_InspectionRecordId] ON [dbo].[QualityIssues] ([InspectionRecordId] ASC);
END
GO
-- Index for time-based filtering: dbo.QualityIssues([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_QualityIssues_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[QualityIssues]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_QualityIssues_CreatedAt] ON [dbo].[QualityIssues] ([CreatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.ScrapRecords([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ScrapRecords_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[ScrapRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ScrapRecords_WorkOrderId] ON [dbo].[ScrapRecords] ([WorkOrderId] ASC);
END
GO
-- Index for time-based filtering: dbo.ScrapRecords([CreatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ScrapRecords_CreatedAt' AND object_id = OBJECT_ID(N'[dbo].[ScrapRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ScrapRecords_CreatedAt] ON [dbo].[ScrapRecords] ([CreatedAt] ASC);
END
GO
-- Index for time-based filtering: dbo.ScrapRecords([UpdatedAt])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ScrapRecords_UpdatedAt' AND object_id = OBJECT_ID(N'[dbo].[ScrapRecords]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_ScrapRecords_UpdatedAt] ON [dbo].[ScrapRecords] ([UpdatedAt] ASC);
END
GO
-- Index for lookup/join: dbo.SerialNumbers([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_SerialNumbers_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[SerialNumbers]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_SerialNumbers_WorkOrderId] ON [dbo].[SerialNumbers] ([WorkOrderId] ASC);
END
GO
-- Index for lookup/join: dbo.WorkOrderDocuments_Audit([Original_DocumentID])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderDocuments_Audit_Original_DocumentID' AND object_id = OBJECT_ID(N'[dbo].[WorkOrderDocuments_Audit]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_WorkOrderDocuments_Audit_Original_DocumentID] ON [dbo].[WorkOrderDocuments_Audit] ([Original_DocumentID] ASC);
END
GO
-- Index for lookup/join: dbo.WorkOrderSerialNumbers_Audit([Original_SerialID])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderSerialNumbers_Audit_Original_SerialID' AND object_id = OBJECT_ID(N'[dbo].[WorkOrderSerialNumbers_Audit]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_WorkOrderSerialNumbers_Audit_Original_SerialID] ON [dbo].[WorkOrderSerialNumbers_Audit] ([Original_SerialID] ASC);
END
GO
-- Index for lookup/join: dbo.WorkOrderStageLog([WorkOrderId])
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderStageLog_WorkOrderId' AND object_id = OBJECT_ID(N'[dbo].[WorkOrderStageLog]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_WorkOrderStageLog_WorkOrderId] ON [dbo].[WorkOrderStageLog] ([WorkOrderId] ASC);
END
GO
-- Clean reporting view for dbo.FinishTime (normalize column names)
CREATE OR ALTER VIEW [rpt].[vw_finishtime_clean] AS
SELECT
    [RecordID] AS [recordid],
    [Finish Date] AS [finish_date],
    [Finish Hours] AS [finish_hours],
    [Finished By] AS [finished_by],
    [Hardness] AS [hardness],
    [Qty To Work On] AS [qty_to_work_on],
    [Qty to credit] AS [qty_to_credit],
    [No# Finished] AS [nonum_finished],
    [Finish Notes] AS [finish_notes],
    [ID] AS [id]
FROM [dbo].[FinishTime];
GO
-- Clean reporting view for dbo.MoldTime (normalize column names)
CREATE OR ALTER VIEW [rpt].[vw_moldtime_clean] AS
SELECT
    [Record No] AS [record_no],
    [Date Molded] AS [date_molded],
    [Shift Molded] AS [shift_molded],
    [No Molded] AS [no_molded],
    [MoldManHrs] AS [moldmanhrs],
    [Mold Notes] AS [mold_notes],
    [1000Resin #/min] AS [1000resin_num_min],
    [1000Catalyst #/min] AS [1000catalyst_num_min],
    [1000Sand #/min] AS [1000sand_num_min],
    [1000LOI %] AS [1000loi],
    [600Resin #/min] AS [600resin_num_min],
    [600Catalyst #/min] AS [600catalyst_num_min],
    [600Sand #/min] AS [600sand_num_min],
    [600LOI %] AS [600loi],
    [ID] AS [id]
FROM [dbo].[MoldTime];
GO
