-- Townley schema (FastAPI-friendly, no GO, no DB file paths)
-- Generated on 2025-12-29
-- Notes:
--  - Connect to the target database before running this script.
--  - This script avoids GO and removes CREATE DATABASE / ALTER DATABASE / user/role statements.

SET NOCOUNT ON;
SET XACT_ABORT ON;

/****** Object:  Table [dbo].[AlloySpecifications]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[AlloySpecifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AlloyCode] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[TargetCarbon] [float] NULL,
	[TargetSilicon] [float] NULL,
	[TargetManganese] [float] NULL,
	[Created_At] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[Aproveusers]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Aproveusers](
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Select] [bit] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[AssemblyRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[AssemblyRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[AssemblyDate] [date] NULL,
	[Assembler] [nvarchar](100) NULL,
	[AssemblyNotes] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[Attachedfiles]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Attachedfiles](
	[MainScrapTblID] [int] NULL,
	[FileType] [nchar](10) NULL,
	[FileName] [nvarchar](50) NULL,
	[FilePath] [nvarchar](max) NULL,
	[AddDateTime] [datetime] NULL,
	[Username] [nvarchar](50) NULL,
	[Deleted] [int] NULL,
	[GridNumber] [int] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[AuditLogs]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[AuditLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Action] [nvarchar](100) NOT NULL,
	[Resource] [nvarchar](200) NULL,
	[Details] [nvarchar](max) NULL,
	[Timestamp] [datetime] NULL,
	[RecordedBy] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[CastingType]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[CastingType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CastingType] [nvarchar](50) NOT NULL,
	[SubCat] [int] NULL,
 CONSTRAINT [PK_CastingType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[ChemAddRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[ChemAddRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[AddDate] [date] NULL,
	[Element] [nvarchar](100) NULL,
	[QuantityAdded] [float] NULL,
	[Operator] [nvarchar](100) NULL,
	[Reason] [nvarchar](200) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[ChemistryRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[ChemistryRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[ChemTestDate] [date] NULL,
	[SampleId] [nvarchar](100) NULL,
	[ChemOperator] [nvarchar](100) NULL,
	[ResultJSON] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[ChemistryResults]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[ChemistryResults](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[work_order_id] [bigint] NOT NULL,
	[heat_number] [nvarchar](50) NULL,
	[sample_number] [nvarchar](50) NULL,
	[date_poured] [datetime] NULL,
	[furnace] [nvarchar](50) NULL,
	[alloy_code] [nvarchar](50) NULL,
	[gross_weight] [float] NULL,
	[tap_temp] [float] NULL,
	[C] [float] NULL,
	[Si] [float] NULL,
	[Mn] [float] NULL,
	[P] [float] NULL,
	[S] [float] NULL,
	[Ni] [float] NULL,
	[Cr] [float] NULL,
	[Mo] [float] NULL,
	[V] [float] NULL,
	[Cu] [float] NULL,
	[Fe] [float] NULL,
	[W] [float] NULL,
	[Ti] [float] NULL,
	[Sn] [float] NULL,
	[Co] [float] NULL,
	[Al] [float] NULL,
	[Cb] [float] NULL,
	[Pb] [float] NULL,
	[B] [float] NULL,
	[Nb] [float] NULL,
	[Zr] [float] NULL,
	[Mg] [float] NULL,
	[Ce] [float] NULL,
	[Ta] [float] NULL,
	[N] [float] NULL,
	[Ceq] [float] NULL,
	[notes] [nvarchar](255) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[ChemistryResults_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[ChemistryResults_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_id] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[Customers]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Customers](
	[CustomerNumber] [varchar](50) NOT NULL,
	[CustomerName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[Defect_sub_Category]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Defect_sub_Category](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[DefectCategory] [nvarchar](10) NOT NULL,
	[Select] [bit] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[DefectCategory]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[DefectCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Select] [bit] NOT NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[DefectCommonName]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[DefectCommonName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Defect_sub2_Category] [nvarchar](10) NOT NULL,
	[CommonName] [nvarchar](255) NOT NULL,
	[select] [bit] NOT NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[Departments]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Departments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[Documents]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Documents](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[FileName] [nvarchar](255) NULL,
	[FileType] [nvarchar](50) NULL,
	[UploadedBy] [nvarchar](255) NULL,
	[UploadedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[Employees]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Employees](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[DeptID] [int] NOT NULL,
	[EmailAddress] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[FinishingRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[FinishingRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NULL,
	[FinishDate] [datetime] NULL,
	[Process] [nvarchar](50) NULL,
	[Notes] [nvarchar](max) NULL,
	[UpdatedAt] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[FinishingRecords_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[FinishingRecords_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_Id] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[FinishTime]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[FinishTime](
	[RecordID] [float] NULL,
	[Finish Date] [nvarchar](255) NULL,
	[Finish Hours] [float] NULL,
	[Finished By] [nvarchar](255) NULL,
	[Hardness] [float] NULL,
	[Qty To Work On] [float] NULL,
	[Qty to credit] [nvarchar](255) NULL,
	[No# Finished] [float] NULL,
	[Finish Notes] [nvarchar](255) NULL,
	[ID] [float] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[FoundryWorkData]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[FoundryWorkData](
	[RecordNo] [float] NULL,
	[WorkOrderNo] [nvarchar](255) NULL,
	[ShiftAssign] [nvarchar](255) NULL,
	[MoldAssignDate] [nvarchar](255) NULL,
	[PurchaseOrderNo] [nvarchar](255) NULL,
	[WorkOrderAssign] [bit] NOT NULL,
	[Rider] [bit] NOT NULL,
	[MachineAssignDate] [nvarchar](255) NULL,
	[MachineRider] [bit] NOT NULL,
	[Customer] [nvarchar](255) NULL,
	[PartNo] [nvarchar](255) NULL,
	[SerialNo] [nvarchar](255) NULL,
	[PartDescription] [nvarchar](255) NULL,
	[StockpiledPart] [bit] NOT NULL,
	[Alloy] [nvarchar](255) NULL,
	[AlloyAutoNumber] [nvarchar](255) NULL,
	[ItemWeight] [nvarchar](255) NULL,
	[QtyRequired] [float] NULL,
	[QtyToManufacture] [float] NULL,
	[WHSLocation] [nvarchar](255) NULL,
	[GrindingToShip] [bit] NOT NULL,
	[HeatTreatRequired] [bit] NOT NULL,
	[JobComplete] [bit] NOT NULL,
	[FinalInspecPerformedBy] [nvarchar](255) NULL,
	[SpecialMfgInstructions] [nvarchar](255) NULL,
	[Notes] [nvarchar](255) NULL,
	[MoldingFinished] [bit] NOT NULL,
	[PouringFinished] [bit] NOT NULL,
	[ShakeoutFinished] [bit] NOT NULL,
	[FinishingFinished] [bit] NOT NULL,
	[HeatTreatFinished] [bit] NOT NULL,
	[MachiningFinished] [bit] NOT NULL,
	[AssemblyFinished] [bit] NOT NULL,
	[Scrapped] [bit] NOT NULL,
	[DateScrapped] [nvarchar](255) NULL,
	[NoScrapped] [nvarchar](255) NULL,
	[ReasonScrapped] [nvarchar](255) NULL,
	[ResponsibleScrapLocation] [nvarchar](255) NULL,
	[RootCauseForScrap] [nvarchar](255) NULL,
	[CNCProgram] [bit] NOT NULL,
	[ReasonLate] [nvarchar](255) NULL,
	[SpecialInstructions] [nvarchar](255) NULL,
	[ComputerName] [nvarchar](255) NULL,
	[Rush] [bit] NOT NULL,
	[RushDueDate] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[PourWt] [nvarchar](255) NULL,
	[Remake] [bit] NOT NULL,
	[HeatSchedulesid] [nvarchar](255) NULL,
	[Machinenumber] [nvarchar](255) NULL,
	[ScheduleFlag] [bit] NOT NULL,
	[RecStatus] [nvarchar](255) NULL,
	[INVLocation] [nvarchar](255) NULL,
	[RecordType] [float] NULL,
	[PartAdded] [bit] NOT NULL,
	[DueDate] [nvarchar](255) NULL,
	[MachShopDate] [nvarchar](255) NULL,
	[ReleasedToShippingDate] [nvarchar](255) NULL,
	[FinalInspecDate] [nvarchar](255) NULL,
	[DateEntered] [nvarchar](255) NULL,
	[MoldingDueDate] [nvarchar](255) NULL,
	[PouringSch] [nvarchar](255) NULL,
	[ShakeOutSch] [nvarchar](255) NULL,
	[ShakeOutComp] [nvarchar](255) NULL,
	[GrindingSch] [nvarchar](255) NULL,
	[HeatTreatSch] [nvarchar](255) NULL,
	[SurfaceGrdSch] [nvarchar](255) NULL,
	[SurfaceGrdComp] [nvarchar](255) NULL,
	[BoringSch] [nvarchar](255) NULL,
	[BoringComp] [nvarchar](255) NULL,
	[DrillingSch] [nvarchar](255) NULL,
	[DrillingComp] [nvarchar](255) NULL,
	[STBalancingSch] [nvarchar](255) NULL,
	[STBalancingComp] [nvarchar](255) NULL,
	[DynBalancingSch] [nvarchar](255) NULL,
	[DynBalancingComp] [nvarchar](255) NULL,
	[FinalInspComp] [nvarchar](255) NULL,
	[PaintToShip] [nvarchar](255) NULL,
	[MillingComp] [nvarchar](255) NULL,
	[HeatTreatComp] [nvarchar](255) NULL,
	[DeliveryComp] [nvarchar](255) NULL,
	[MoldSetupComp] [nvarchar](255) NULL,
	[MoldingComp] [nvarchar](255) NULL,
	[PatternComp] [nvarchar](255) NULL,
	[ThreadingComp] [nvarchar](255) NULL,
	[PouringComp] [nvarchar](255) NULL,
	[GrindingComp] [nvarchar](255) NULL,
	[RiderPrinted] [nvarchar](255) NULL,
	[PartTranscode] [nvarchar](255) NULL,
	[ProdctionFinshed] [bit] NOT NULL,
	[MachineNotes] [nvarchar](255) NULL,
	[Statusnotes] [nvarchar](255) NULL,
	[CustomerNumber] [nvarchar](255) NULL,
	[MachineComp] [nvarchar](255) NULL,
	[MfgCncComp] [nvarchar](255) NULL,
	[Cryocomp] [nvarchar](255) NULL,
	[InvDateTime] [nvarchar](255) NULL,
	[PouringScheduleFlag] [bit] NOT NULL,
	[PourAssignDate] [nvarchar](255) NULL,
	[PRRecStatus] [nvarchar](255) NULL,
	[ShippingDate] [nvarchar](255) NULL,
	[ReleasedToShippingFlag] [nvarchar](255) NULL,
	[Specialflag] [bit] NOT NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[HeatTreatRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[HeatTreatRecords](
	[WorkOrderId] [int] NOT NULL,
	[TreatDate] [date] NULL,
	[Temperature] [float] NULL,
	[DurationHours] [float] NULL,
	[Notes] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[WorkOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[HeatTreatTime]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[HeatTreatTime](
	[RecordTie] [float] NULL,
	[HeatTreatDate] [nvarchar](255) NULL,
	[QtyHeated] [float] NULL,
	[NoHeatTreat] [float] NULL,
	[HeatNos] [float] NULL,
	[HeatTreatFurnaceNo] [float] NULL,
	[HeatTreatHardness] [float] NULL,
	[HeatTreatNotes] [nvarchar](255) NULL,
	[HeatTreatProcessNo] [nvarchar](255) NULL,
	[ID] [float] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[InspectionRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[InspectionRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[InspectionDate] [date] NULL,
	[Inspector] [nvarchar](100) NULL,
	[InspectionNotes] [nvarchar](max) NULL,
	[Pass] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[LSTCub_2_Categories]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[LSTCub_2_Categories](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[Defect_sub_Category] [nvarchar](10) NOT NULL,
	[Select] [bit] NOT NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[MachineTime]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[MachineTime](
	[Record] [float] NULL,
	[NoMachined] [float] NULL,
	[MachineHrs] [nvarchar](255) NULL,
	[MachineNotes] [nvarchar](255) NULL,
	[QtyReleasedToShipping] [float] NULL,
	[CNCMachined] [bit] NOT NULL,
	[StartWht] [float] NULL,
	[EndWht] [float] NULL,
	[ID] [float] NULL,
	[MachineDate] [datetime] NULL,
	[UpdatedAt] [datetime] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[MachineTime_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[MachineTime_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_ID] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[MainScrapTbl]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[MainScrapTbl](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RecordNumber] [int] NOT NULL,
	[SearialNum] [nvarchar](50) NOT NULL,
	[WorkorderNo] [nvarchar](50) NOT NULL,
	[PartNo] [nvarchar](50) NOT NULL,
	[Alloy] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[MfgInst] [nvarchar](max) NOT NULL,
	[DefectCategory] [nvarchar](50) NULL,
	[Defect_sub_Category] [nvarchar](max) NULL,
	[LSTCub_2_Categories] [nvarchar](max) NULL,
	[DefectCommonName] [nvarchar](max) NULL,
	[Employee] [nvarchar](50) NULL,
	[Department] [nvarchar](50) NULL,
	[EntryDate] [date] NULL,
	[Defect] [nvarchar](max) NULL,
	[AnalysisBy] [nvarchar](50) NULL,
	[AnalysisDate] [nvarchar](50) NULL,
	[Scrapping] [bit] NOT NULL,
	[ProblemStatment] [nvarchar](max) NULL,
	[DataColected] [nvarchar](max) NULL,
	[DataEvaluation] [nvarchar](max) NULL,
	[CorrectivePlan] [nvarchar](max) NULL,
	[Actiontrial] [bit] NOT NULL,
	[DecribeActionTrial] [nvarchar](max) NULL,
	[EvaluationActionTrial] [nvarchar](max) NULL,
	[EvaluationProductionTest] [nvarchar](max) NULL,
	[ResultApprovedby] [nvarchar](50) NULL,
	[ResultApprovedbyDate] [date] NULL,
	[ProductionTestApp] [nvarchar](50) NULL,
	[ProductionTestdate] [date] NULL,
	[sourcedefectcorrected] [bit] NOT NULL,
	[ItemWeight] [int] NULL,
	[PatternLabel] [nvarchar](50) NULL,
	[PlanAppby] [nvarchar](50) NULL,
	[PlanAppDate] [date] NULL,
	[solutiondoc] [nvarchar](max) NULL,
	[QAMgr] [nvarchar](50) NULL,
	[QAMgrDate] [date] NULL,
	[DefectCommonNameTXT] [nvarchar](max) NULL,
	[lstPlanAppby] [nvarchar](max) NULL,
	[lstAnalysisBy] [nvarchar](max) NULL,
	[ProposedCorr] [nvarchar](max) NULL,
	[NewPartSerial] [nvarchar](50) NULL,
	[FollowupProd] [nvarchar](max) NULL,
	[ActionImpProd] [bit] NULL,
	[UpdatedAt] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[MainScrapTbl_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[MainScrapTbl_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_ID] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[MoldingRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[MoldingRecords](
	[RecordNo] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderNo] [nvarchar](50) NOT NULL,
	[MoldDate] [date] NOT NULL,
	[MoldShift] [nvarchar](20) NULL,
	[MoldOperator] [nvarchar](100) NULL,
	[PatternNo] [nvarchar](50) NULL,
	[Alloy] [nvarchar](50) NULL,
	[PartNo] [nvarchar](50) NULL,
	[MoldNotes] [nvarchar](max) NULL,
	[MoldingFinished] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RecordNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[MoldTime]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[MoldTime](
	[Record No] [float] NULL,
	[Date Molded] [nvarchar](255) NULL,
	[Shift Molded] [nvarchar](255) NULL,
	[No Molded] [float] NULL,
	[MoldManHrs] [float] NULL,
	[Mold Notes] [nvarchar](255) NULL,
	[1000Resin #/min] [float] NULL,
	[1000Catalyst #/min] [float] NULL,
	[1000Sand #/min] [float] NULL,
	[1000LOI %] [float] NULL,
	[600Resin #/min] [float] NULL,
	[600Catalyst #/min] [float] NULL,
	[600Sand #/min] [float] NULL,
	[600LOI %] [float] NULL,
	[ID] [float] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[Parts]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Parts](
	[PartNo] [varchar](50) NOT NULL,
	[PartDescription] [varchar](255) NULL,
	[Alloy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PartNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[PouringRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[PouringRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NULL,
	[PourDate] [datetime] NULL,
	[Alloy] [nvarchar](50) NULL,
	[Notes] [nvarchar](max) NULL,
	[UpdatedAt] [datetime] NULL,
	[HeatNo] [varchar](50) NULL,
	[TapTemp] [decimal](5, 2) NULL,
	[PourTemp] [decimal](5, 2) NULL,
	[Furnace] [varchar](50) NULL,
	[Ladle] [varchar](50) NULL,
	[Pourer] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[PouringRecords_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[PouringRecords_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_Id] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[PouringTime]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[PouringTime](
	[RecordLink] [float] NULL,
	[DatePoured] [nvarchar](255) NULL,
	[NoPoured] [float] NULL,
	[HeatNo] [float] NULL,
	[Material] [nvarchar](255) NULL,
	[MaterialAutoNumber] [nvarchar](255) NULL,
	[NoLost] [nvarchar](255) NULL,
	[PouringNotes] [nvarchar](255) NULL,
	[PouringTime] [float] NULL,
	[TapTemperature] [float] NULL,
	[PourTemperature] [float] NULL,
	[ShakeoutDueDate] [nvarchar](255) NULL,
	[ActualShakeoutDate] [nvarchar](255) NULL,
	[ShakeoutComplete] [bit] NOT NULL,
	[PourOrder] [float] NULL,
	[PouredBy] [nvarchar](255) NULL,
	[Furnace] [float] NULL,
	[Ladle] [float] NULL,
	[ID] [float] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[ProcessData]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[ProcessData](
	[Code] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[Select] [bit] NULL
) ON [PRIMARY]

/****** Object:  Table [dbo].[QualityIssues]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[QualityIssues](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[InspectionRecordId] [int] NULL,
	[Stage] [nvarchar](100) NOT NULL,
	[IssueType] [nvarchar](255) NULL,
	[Severity] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[DetectedBy] [nvarchar](100) NULL,
	[Resolved] [bit] NULL,
	[ResolutionNotes] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[ScrapRecords]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[ScrapRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[ScrapDate] [date] NULL,
	[ScrapReason] [nvarchar](200) NULL,
	[ScrapQty] [int] NULL,
	[ScrapWarehouse] [nvarchar](100) NULL,
	[ScrapOperator] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[SerialNumbers]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[SerialNumbers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[Serial] [nvarchar](100) NOT NULL,
	[Status] [nvarchar](100) NULL,
	[Created_At] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[users]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[hashed_password] [nvarchar](255) NOT NULL,
	[role] [nvarchar](50) NOT NULL,
	[created_at] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrderDocuments]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrderDocuments](
	[DocumentID] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderRecordNo] [bigint] NULL,
	[DocumentName] [varchar](255) NULL,
	[DocumentType] [varchar](50) NULL,
	[FilePath] [varchar](255) NULL,
	[UploadedAt] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrderDocuments_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrderDocuments_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_DocumentID] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrders]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrders](
	[RecordNo] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderNo] [nvarchar](100) NOT NULL,
	[PartNo] [nvarchar](100) NOT NULL,
	[CustomerName] [nvarchar](200) NULL,
	[AlloyCode] [nvarchar](100) NULL,
	[QtyRequired] [int] NOT NULL,
	[RushDueDate] [date] NULL,
	[SerialNo] [nvarchar](100) NULL,
	[StatusNotes] [nvarchar](255) NULL,
	[MoldingFinished] [bit] NULL,
	[PouringFinished] [bit] NULL,
	[HeatTreatFinished] [bit] NULL,
	[MachiningFinished] [bit] NULL,
	[AssemblyFinished] [bit] NULL,
	[FinalInspComp] [bit] NULL,
	[Status] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RecordNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrders_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrders_Audit](
	[audit_id] [int] IDENTITY(1,1) NOT NULL,
	[RecordNo] [bigint] NULL,
	[action_type] [nvarchar](20) NULL,
	[action_time] [datetime] NULL,
	[action_user] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[audit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrderSerialNumbers]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrderSerialNumbers](
	[SerialID] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderRecordNo] [bigint] NULL,
	[SerialNumber] [varchar](50) NULL,
	[DateAssigned] [datetime] NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SerialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrderSerialNumbers_Audit]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrderSerialNumbers_Audit](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[ActionType] [nvarchar](10) NULL,
	[ChangedAt] [datetime] NULL,
	[ChangedBy] [nvarchar](100) NULL,
	[Original_SerialID] [int] NULL,
	[DataBefore] [nvarchar](max) NULL,
	[DataAfter] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

/****** Object:  Table [dbo].[WorkOrderStageLog]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[WorkOrderStageLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderId] [int] NOT NULL,
	[StageName] [nvarchar](100) NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[PerformedBy] [nvarchar](100) NULL,
	[Notes] [nvarchar](1000) NULL,
	[Timestamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  View [dbo].[vw_ActiveWorkOrders]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_ActiveWorkOrders]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ActiveWorkOrders];
EXEC(N'CREATE VIEW [dbo].[vw_ActiveWorkOrders] AS
SELECT *
FROM WorkOrders
WHERE is_deleted = 0;');

/****** Object:  View [dbo].[vw_ChemistryElementsUnpivoted]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_ChemistryElementsUnpivoted]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ChemistryElementsUnpivoted];
EXEC(N'CREATE VIEW [dbo].[vw_ChemistryElementsUnpivoted] AS
SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''C'' AS Element,
    [C] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Si'' AS Element,
    [Si] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Mn'' AS Element,
    [Mn] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''P'' AS Element,
    [P] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''S'' AS Element,
    [S] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Ni'' AS Element,
    [Ni] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Cr'' AS Element,
    [Cr] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Mo'' AS Element,
    [Mo] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''V'' AS Element,
    [V] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Cu'' AS Element,
    [Cu] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Fe'' AS Element,
    [Fe] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''W'' AS Element,
    [W] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Ti'' AS Element,
    [Ti] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Sn'' AS Element,
    [Sn] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Co'' AS Element,
    [Co] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Al'' AS Element,
    [Al] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Cb'' AS Element,
    [Cb] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Pb'' AS Element,
    [Pb] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''B'' AS Element,
    [B] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Nb'' AS Element,
    [Nb] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Zr'' AS Element,
    [Zr] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Mg'' AS Element,
    [Mg] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Ce'' AS Element,
    [Ce] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''Ta'' AS Element,
    [Ta] AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    ''N'' AS Element,
    [N] AS Percentage
FROM ChemistryResults
;');

/****** Object:  View [dbo].[vw_ChemistryResults_AuditLog]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_ChemistryResults_AuditLog]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ChemistryResults_AuditLog];
EXEC(N'CREATE VIEW [dbo].[vw_ChemistryResults_AuditLog] AS
SELECT 
    AuditID,
    ActionType,
    ChangedAt,
    ISNULL(ChangedBy, CONVERT(NVARCHAR(100), CONTEXT_INFO())) AS ChangedBy,
    Original_id,
    CASE 
        WHEN ActionType = ''INSERT'' THEN DataAfter
        WHEN ActionType = ''DELETE'' THEN DataBefore
        WHEN ActionType = ''UPDATE'' THEN CONCAT(''BEFORE: '', DataBefore, '' | AFTER: '', DataAfter)
    END AS ChangeDetails
FROM ChemistryResults_Audit;');

/****** Object:  View [dbo].[vw_ChemistrySummary]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_ChemistrySummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ChemistrySummary];
EXEC(N'CREATE VIEW [dbo].[vw_ChemistrySummary] AS
SELECT 
    cr.work_order_id,
    wo.WorkOrderNo,
    cr.heat_number,
    cr.sample_number,
    cr.furnace,
    cr.date_poured,
    cr.alloy_code,
    cr.Ceq,
    cr.notes,
    cr.created_at,
    cr.updated_at
FROM ChemistryResults cr
LEFT JOIN WorkOrders wo ON cr.work_order_id = wo.RecordNo;');

/****** Object:  View [dbo].[vw_OpenWorkOrdersSummary]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_OpenWorkOrdersSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_OpenWorkOrdersSummary];
EXEC(N'CREATE VIEW [dbo].[vw_OpenWorkOrdersSummary] AS
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
  AND (wo.MachiningFinished = 0 OR wo.MachiningFinished IS NULL);');

/****** Object:  View [dbo].[vw_ScrapDetailSummary]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_ScrapDetailSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ScrapDetailSummary];
EXEC(N'CREATE VIEW [dbo].[vw_ScrapDetailSummary] AS
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
  RootCauseForScrap;');

/****** Object:  View [dbo].[vw_ScrapSummary]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_ScrapSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_ScrapSummary];
EXEC(N'CREATE VIEW [dbo].[vw_ScrapSummary] AS
SELECT 
    ms.PartNo,
    p.PartDescription,
    ms.DefectCategory,
    COUNT(*) AS ScrapCount
FROM MainScrapTbl ms
LEFT JOIN Parts p ON ms.PartNo = p.PartNo
WHERE ms.Scrapping = 1
GROUP BY ms.PartNo, p.PartDescription, ms.DefectCategory;');

/****** Object:  View [dbo].[vw_WorkOrderActiveSummary]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_WorkOrderActiveSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_WorkOrderActiveSummary];
EXEC(N'CREATE VIEW [dbo].[vw_WorkOrderActiveSummary] AS
SELECT 
    RecordNo,
    Customer,
    PartNo,
    status,
    created_at,
    updated_at
FROM WorkOrders
WHERE is_deleted = 0;');

/****** Object:  View [dbo].[vw_WorkOrderBacklog]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_WorkOrderBacklog]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_WorkOrderBacklog];
EXEC(N'CREATE VIEW [dbo].[vw_WorkOrderBacklog] AS
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
  wo.AssemblyFinished;');

/****** Object:  View [dbo].[vw_WorkOrderSerials_AuditStats]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_WorkOrderSerials_AuditStats]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_WorkOrderSerials_AuditStats];
EXEC(N'CREATE VIEW [dbo].[vw_WorkOrderSerials_AuditStats] AS
SELECT 
    Original_SerialID,
    COUNT(*) AS ChangeCount,
    MAX(ChangedAt) AS LastChanged
FROM WorkOrderSerialNumbers_Audit
GROUP BY Original_SerialID;');

/****** Object:  View [dbo].[vw_WorkOrderStatusSummary]    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_WorkOrderStatusSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_WorkOrderStatusSummary];
EXEC(N'CREATE VIEW [dbo].[vw_WorkOrderStatusSummary] AS
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
LEFT JOIN Customers c ON wo.CustomerNumber = c.CustomerNumber;');

/****** Object:  View [dbo].[vw_WorkOrderSummary]    Script Date: 8/15/2025 10:52:57 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[vw_WorkOrderSummary]', N'V') IS NOT NULL DROP VIEW [dbo].[vw_WorkOrderSummary];
EXEC(N'CREATE VIEW [dbo].[vw_WorkOrderSummary] AS
SELECT 
    RecordNo,
    status,
    created_at,
    updated_at,
    FinalInspComp,
    Customer,
    PartNo
FROM WorkOrders;');

/****** Object:  Index [IX_Attachedfiles_MainScrapTblID]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_Attachedfiles_MainScrapTblID] ON [dbo].[Attachedfiles]
(
	[MainScrapTblID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_ChemistryResults_work_order_id]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_ChemistryResults_work_order_id] ON [dbo].[ChemistryResults]
(
	[work_order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_FinishingRecords_WorkOrderId]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_FinishingRecords_WorkOrderId] ON [dbo].[FinishingRecords]
(
	[WorkOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_HeatTreatRecords_WorkOrderId]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_HeatTreatRecords_WorkOrderId] ON [dbo].[HeatTreatRecords]
(
	[WorkOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_MachineTime_MachineDate]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_MachineTime_MachineDate] ON [dbo].[MachineTime]
(
	[MachineDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON

/****** Object:  Index [IX_MainScrapTbl_DefectCategory]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_MainScrapTbl_DefectCategory] ON [dbo].[MainScrapTbl]
(
	[DefectCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON

/****** Object:  Index [IX_MainScrapTbl_PartNo]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_MainScrapTbl_PartNo] ON [dbo].[MainScrapTbl]
(
	[PartNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

SET ANSI_PADDING ON

/****** Object:  Index [IX_MainScrapTbl_WorkorderNo]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_MainScrapTbl_WorkorderNo] ON [dbo].[MainScrapTbl]
(
	[WorkorderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_PouringRecords_WorkOrderId]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_PouringRecords_WorkOrderId] ON [dbo].[PouringRecords]
(
	[WorkOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_WorkOrderDocuments_WorkOrderRecordNo]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_WorkOrderDocuments_WorkOrderRecordNo] ON [dbo].[WorkOrderDocuments]
(
	[WorkOrderRecordNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

/****** Object:  Index [IX_WorkOrderSerialNumbers_WorkOrderRecordNo]    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX [IX_WorkOrderSerialNumbers_WorkOrderRecordNo] ON [dbo].[WorkOrderSerialNumbers]
(
	[WorkOrderRecordNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[AlloySpecifications] ADD  DEFAULT (getdate()) FOR [Created_At]

ALTER TABLE [dbo].[Aproveusers] ADD  CONSTRAINT [DF_Aproveusers_Select]  DEFAULT ((0)) FOR [Select]

ALTER TABLE [dbo].[AssemblyRecords] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[AssemblyRecords] ADD  DEFAULT (getdate()) FOR [UpdatedAt]

ALTER TABLE [dbo].[Attachedfiles] ADD  CONSTRAINT [DF_Attachedfiles_GridNumber]  DEFAULT ((0)) FOR [GridNumber]

ALTER TABLE [dbo].[AuditLogs] ADD  DEFAULT (getdate()) FOR [Timestamp]

ALTER TABLE [dbo].[ChemAddRecords] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[ChemAddRecords] ADD  DEFAULT (getdate()) FOR [UpdatedAt]

ALTER TABLE [dbo].[ChemistryRecords] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[ChemistryRecords] ADD  DEFAULT (getdate()) FOR [UpdatedAt]

ALTER TABLE [dbo].[ChemistryResults] ADD  DEFAULT (getdate()) FOR [created_at]

ALTER TABLE [dbo].[ChemistryResults_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[Defect_sub_Category] ADD  CONSTRAINT [DF_Defect_sub_Category_Select]  DEFAULT ((0)) FOR [Select]

ALTER TABLE [dbo].[DefectCategory] ADD  CONSTRAINT [DF_DefectCategory_Select]  DEFAULT ((0)) FOR [Select]

ALTER TABLE [dbo].[DefectCommonName] ADD  CONSTRAINT [DF_DefectCommonName_select]  DEFAULT ((0)) FOR [select]

ALTER TABLE [dbo].[Documents] ADD  DEFAULT (getdate()) FOR [UploadedAt]

ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_DeptID]  DEFAULT ((0)) FOR [DeptID]

ALTER TABLE [dbo].[FinishingRecords_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[InspectionRecords] ADD  DEFAULT ((0)) FOR [Pass]

ALTER TABLE [dbo].[InspectionRecords] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[InspectionRecords] ADD  DEFAULT (getdate()) FOR [UpdatedAt]

ALTER TABLE [dbo].[LSTCub_2_Categories] ADD  CONSTRAINT [DF_LSTCub_2_Categories_Select]  DEFAULT ((0)) FOR [Select]

ALTER TABLE [dbo].[MachineTime_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[MainScrapTbl] ADD  CONSTRAINT [DF_MainScrapTbl_RecordNumber]  DEFAULT ((0)) FOR [RecordNumber]

ALTER TABLE [dbo].[MainScrapTbl] ADD  CONSTRAINT [DF_MainScrapTbl_Scrapping]  DEFAULT ((0)) FOR [Scrapping]

ALTER TABLE [dbo].[MainScrapTbl] ADD  CONSTRAINT [DF_MainScrapTbl_Actiontrial]  DEFAULT ((0)) FOR [Actiontrial]

ALTER TABLE [dbo].[MainScrapTbl] ADD  CONSTRAINT [DF_MainScrapTbl_sourcedefectcorrected]  DEFAULT ((0)) FOR [sourcedefectcorrected]

ALTER TABLE [dbo].[MainScrapTbl_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[MoldingRecords] ADD  DEFAULT ((0)) FOR [MoldingFinished]

ALTER TABLE [dbo].[MoldingRecords] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[MoldingRecords] ADD  DEFAULT (getdate()) FOR [UpdatedAt]

ALTER TABLE [dbo].[PouringRecords_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[ProcessData] ADD  CONSTRAINT [DF_ProcessData_Select]  DEFAULT ((0)) FOR [Select]

ALTER TABLE [dbo].[QualityIssues] ADD  DEFAULT ((0)) FOR [Resolved]

ALTER TABLE [dbo].[QualityIssues] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[ScrapRecords] ADD  DEFAULT (getdate()) FOR [CreatedAt]

ALTER TABLE [dbo].[ScrapRecords] ADD  DEFAULT (getdate()) FOR [UpdatedAt]

ALTER TABLE [dbo].[SerialNumbers] ADD  DEFAULT (getdate()) FOR [Created_At]

ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]

ALTER TABLE [dbo].[WorkOrderDocuments] ADD  DEFAULT (getdate()) FOR [UploadedAt]

ALTER TABLE [dbo].[WorkOrderDocuments] ADD  DEFAULT (getdate()) FOR [created_at]

ALTER TABLE [dbo].[WorkOrderDocuments_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[WorkOrders_Audit] ADD  DEFAULT (getdate()) FOR [action_time]

ALTER TABLE [dbo].[WorkOrders_Audit] ADD  DEFAULT (suser_sname()) FOR [action_user]

ALTER TABLE [dbo].[WorkOrderSerialNumbers] ADD  DEFAULT (getdate()) FOR [DateAssigned]

ALTER TABLE [dbo].[WorkOrderSerialNumbers] ADD  DEFAULT (getdate()) FOR [created_at]

ALTER TABLE [dbo].[WorkOrderSerialNumbers_Audit] ADD  DEFAULT (getdate()) FOR [ChangedAt]

ALTER TABLE [dbo].[WorkOrderStageLog] ADD  DEFAULT (getdate()) FOR [Timestamp]

ALTER TABLE [dbo].[AssemblyRecords]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[MoldingRecords] ([RecordNo])
ON DELETE CASCADE

ALTER TABLE [dbo].[AuditLogs]  WITH CHECK ADD  CONSTRAINT [FK_AuditLogs_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE

ALTER TABLE [dbo].[AuditLogs] CHECK CONSTRAINT [FK_AuditLogs_UserId]

ALTER TABLE [dbo].[ChemAddRecords]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])
ON DELETE CASCADE

ALTER TABLE [dbo].[ChemistryRecords]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])
ON DELETE CASCADE

ALTER TABLE [dbo].[Documents]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])

ALTER TABLE [dbo].[InspectionRecords]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])
ON DELETE CASCADE

ALTER TABLE [dbo].[QualityIssues]  WITH CHECK ADD FOREIGN KEY([InspectionRecordId])
REFERENCES [dbo].[InspectionRecords] ([Id])

ALTER TABLE [dbo].[QualityIssues]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])

ALTER TABLE [dbo].[ScrapRecords]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])
ON DELETE CASCADE

ALTER TABLE [dbo].[SerialNumbers]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])

ALTER TABLE [dbo].[WorkOrderStageLog]  WITH CHECK ADD FOREIGN KEY([WorkOrderId])
REFERENCES [dbo].[WorkOrders] ([RecordNo])

/****** Object:  StoredProcedure [dbo].[sp_CleanupOldAuditLogs]    Script Date: 8/15/2025 10:52:57 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

IF OBJECT_ID(N'[dbo].[sp_CleanupOldAuditLogs]', N'P') IS NOT NULL DROP PROCEDURE [dbo].[sp_CleanupOldAuditLogs];
EXEC(N'CREATE PROCEDURE [dbo].[sp_CleanupOldAuditLogs]
    @DaysOld INT = 90
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cutoff DATETIME = DATEADD(DAY, -@DaysOld, GETDATE());

    DELETE FROM ChemistryResults_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM WorkOrderDocuments_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM WorkOrderSerialNumbers_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM MainScrapTbl_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM PouringRecords_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM MachineTime_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM FinishingRecords_Audit WHERE ChangedAt < @cutoff;
END;');
