-- =========================================================
-- Townley Deploy End-to-End (Single File)
-- Run with: sqlcmd -i townley_deploy_end_to_end.sql
--
-- Includes (in order):
--  1) Deploy-only baseline (legacy portable + patch + strict core + compat/migration)
--  2) FastAPI-exact api.* views
--  3) Roles & permissions (api reader / core writer)
--  4) Hard guards: INSTEAD OF triggers to prevent writes to api views
-- =========================================================



-- =========================================================
-- BEGIN townley_deploy_only.sql
-- =========================================================
-- =========================================================
-- Townley Deploy-Only (Generated)
-- Creates database if missing, then deploys legacy + core + migration layers.
-- =========================================================

CREATE DATABASE IF NOT EXISTS `Townley_MySQL`;
USE `Townley_MySQL`;
-- =========================================================
-- BEGIN Townleyfulldatabaseschema_portable.sql
-- =========================================================
/* 
Townley Legacy Core Schema (Portable)
Source: SSMS generated script (legacy core)
Edits:
- Removed hard-coded MDF/LDF paths (works on Windows SQL Server and SQL Server in Docker/Linux)
- Made DB create idempotent
- Guarded optional full-text enable
- Guarded user creation (only if login exists)
Encoding: UTF-8

NOTE: Review compatibility_level for your target SQL Server version.
*/

DECLARE @DbName sysname = N'Townley';
IF DB_ID(@DbName) IS NULL
BEGIN
    DECLARE @sql LONGTEXT = N'CREATE DATABASE `' + REPLACE(@DbName, '`', ']]') + N']';
    EXEC(@sql);
END;

-- Optional: set compatibility level (uncomment if you want to pin it)
-- ALTER DATABASE `Townley` SET COMPATIBILITY_LEVEL = 160;
-- GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
    EXEC `Townley`.`dbo`.`sp_fulltext_database` @action = 'enable';
END;

USE `Townley_MySQL`;
-- Optional: create user for an existing server login (skip in Docker unless you create the login)
IF SUSER_ID(N'foundryAdmin') IS NOT NULL AND DATABASE_PRINCIPAL_ID(N'foundryAdmin') IS NULL
BEGIN
    CREATE USER `foundryAdmin` FOR LOGIN `foundryAdmin` WITH DEFAULT_SCHEMA=`dbo`;
    ALTER ROLE `db_datareader` ADD MEMBER `foundryAdmin`;
    ALTER ROLE `db_datawriter` ADD MEMBER `foundryAdmin`;
END;


/****** Object:  User `foundryAdmin`    Script Date: 8/15/2025 10:52:56 AM ******/
CREATE USER `foundryAdmin` FOR LOGIN `foundryAdmin` WITH DEFAULT_SCHEMA=`dbo`

ALTER ROLE `db_datareader` ADD MEMBER `foundryAdmin`

ALTER ROLE `db_datawriter` ADD MEMBER `foundryAdmin`

/****** Object:  Table `dbo`.`AlloySpecifications`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`AlloySpecifications`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`AlloyCode` `nvarchar`(100) NOT NULL,
	`Description` `nvarchar`(255) NULL,
	`TargetCarbon` `DOUBLE` NULL,
	`TargetSilicon` `DOUBLE` NULL,
	`TargetManganese` `DOUBLE` NULL,
	`Created_At` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`Aproveusers`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Aproveusers`(
	`Code` `nvarchar`(50) NULL,
	`Name` `nvarchar`(50) NULL,
	`Email` `nvarchar`(50) NULL,
	`Select` `TINYINT(1)` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`AssemblyRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`AssemblyRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`AssemblyDate` `date` NULL,
	`Assembler` `nvarchar`(100) NULL,
	`AssemblyNotes` `nvarchar`(max) NULL,
	`CreatedAt` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`Attachedfiles`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Attachedfiles`(
	`MainScrapTblID` `int` NULL,
	`FileType` `nchar`(10) NULL,
	`FileName` `nvarchar`(50) NULL,
	`FilePath` `nvarchar`(max) NULL,
	`AddDateTime` `datetime` NULL,
	`Username` `nvarchar`(50) NULL,
	`Deleted` `int` NULL,
	`GridNumber` `int` NULL,
	`ID` `int` AUTO_INCREMENT NOT NULL
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`AuditLogs`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`AuditLogs`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`UserId` `int` NOT NULL,
	`Action` `nvarchar`(100) NOT NULL,
	`Resource` `nvarchar`(200) NULL,
	`Details` `nvarchar`(max) NULL,
	`Timestamp` `datetime` NULL,
	`RecordedBy` `nvarchar`(100) NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`CastingType`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`CastingType`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`CastingType` `nvarchar`(50) NOT NULL,
	`SubCat` `int` NULL,
 CONSTRAINT `PK_CastingType` PRIMARY KEY CLUSTERED 
(
	`ID` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`ChemAddRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`ChemAddRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`AddDate` `date` NULL,
	`Element` `nvarchar`(100) NULL,
	`QuantityAdded` `DOUBLE` NULL,
	`Operator` `nvarchar`(100) NULL,
	`Reason` `nvarchar`(200) NULL,
	`CreatedAt` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`ChemistryRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`ChemistryRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`ChemTestDate` `date` NULL,
	`SampleId` `nvarchar`(100) NULL,
	`ChemOperator` `nvarchar`(100) NULL,
	`ResultJSON` `nvarchar`(max) NULL,
	`CreatedAt` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`ChemistryResults`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`ChemistryResults`(
	`id` `int` AUTO_INCREMENT NOT NULL,
	`work_order_id` `bigint` NOT NULL,
	`heat_number` `nvarchar`(50) NULL,
	`sample_number` `nvarchar`(50) NULL,
	`date_poured` `datetime` NULL,
	`furnace` `nvarchar`(50) NULL,
	`alloy_code` `nvarchar`(50) NULL,
	`gross_weight` `DOUBLE` NULL,
	`tap_temp` `DOUBLE` NULL,
	`C` `DOUBLE` NULL,
	`Si` `DOUBLE` NULL,
	`Mn` `DOUBLE` NULL,
	`P` `DOUBLE` NULL,
	`S` `DOUBLE` NULL,
	`Ni` `DOUBLE` NULL,
	`Cr` `DOUBLE` NULL,
	`Mo` `DOUBLE` NULL,
	`V` `DOUBLE` NULL,
	`Cu` `DOUBLE` NULL,
	`Fe` `DOUBLE` NULL,
	`W` `DOUBLE` NULL,
	`Ti` `DOUBLE` NULL,
	`Sn` `DOUBLE` NULL,
	`Co` `DOUBLE` NULL,
	`Al` `DOUBLE` NULL,
	`Cb` `DOUBLE` NULL,
	`Pb` `DOUBLE` NULL,
	`B` `DOUBLE` NULL,
	`Nb` `DOUBLE` NULL,
	`Zr` `DOUBLE` NULL,
	`Mg` `DOUBLE` NULL,
	`Ce` `DOUBLE` NULL,
	`Ta` `DOUBLE` NULL,
	`N` `DOUBLE` NULL,
	`Ceq` `DOUBLE` NULL,
	`notes` `nvarchar`(255) NULL,
	`created_at` `datetime` NOT NULL,
	`updated_at` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`ChemistryResults_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`ChemistryResults_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_id` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`Customers`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Customers`(
	`CustomerNumber` `varchar`(50) NOT NULL,
	`CustomerName` `varchar`(100) NULL,
PRIMARY KEY CLUSTERED 
(
	`CustomerNumber` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`Defect_sub_Category`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Defect_sub_Category`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`Code` `nvarchar`(50) NOT NULL,
	`Description` `nvarchar`(255) NOT NULL,
	`DefectCategory` `nvarchar`(10) NOT NULL,
	`Select` `TINYINT(1)` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`DefectCategory`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`DefectCategory`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`Code` `nvarchar`(50) NOT NULL,
	`Description` `nvarchar`(255) NOT NULL,
	`Select` `TINYINT(1)` NOT NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`DefectCommonName`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`DefectCommonName`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`Code` `nvarchar`(50) NOT NULL,
	`Description` `nvarchar`(255) NOT NULL,
	`Defect_sub2_Category` `nvarchar`(10) NOT NULL,
	`CommonName` `nvarchar`(255) NOT NULL,
	`select` `TINYINT(1)` NOT NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`Departments`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Departments`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`Description` `nvarchar`(50) NOT NULL,
 CONSTRAINT `PK_Departments` PRIMARY KEY CLUSTERED 
(
	`ID` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`Documents`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Documents`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`FileName` `nvarchar`(255) NULL,
	`FileType` `nvarchar`(50) NULL,
	`UploadedBy` `nvarchar`(255) NULL,
	`UploadedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`Employees`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Employees`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`Name` `nvarchar`(50) NOT NULL,
	`DeptID` `int` NOT NULL,
	`EmailAddress` `nvarchar`(max) NULL
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`FinishingRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`FinishingRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NULL,
	`FinishDate` `datetime` NULL,
	`Process` `nvarchar`(50) NULL,
	`Notes` `nvarchar`(max) NULL,
	`UpdatedAt` `datetime` NULL
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`FinishingRecords_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`FinishingRecords_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_Id` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`FinishTime`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`FinishTime`(
	`RecordID` `DOUBLE` NULL,
	`Finish Date` `nvarchar`(255) NULL,
	`Finish Hours` `DOUBLE` NULL,
	`Finished By` `nvarchar`(255) NULL,
	`Hardness` `DOUBLE` NULL,
	`Qty To Work On` `DOUBLE` NULL,
	`Qty to credit` `nvarchar`(255) NULL,
	`No# Finished` `DOUBLE` NULL,
	`Finish Notes` `nvarchar`(255) NULL,
	`ID` `DOUBLE` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`FoundryWorkData`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`FoundryWorkData`(
	`RecordNo` `DOUBLE` NULL,
	`WorkOrderNo` `nvarchar`(255) NULL,
	`ShiftAssign` `nvarchar`(255) NULL,
	`MoldAssignDate` `nvarchar`(255) NULL,
	`PurchaseOrderNo` `nvarchar`(255) NULL,
	`WorkOrderAssign` `TINYINT(1)` NOT NULL,
	`Rider` `TINYINT(1)` NOT NULL,
	`MachineAssignDate` `nvarchar`(255) NULL,
	`MachineRider` `TINYINT(1)` NOT NULL,
	`Customer` `nvarchar`(255) NULL,
	`PartNo` `nvarchar`(255) NULL,
	`SerialNo` `nvarchar`(255) NULL,
	`PartDescription` `nvarchar`(255) NULL,
	`StockpiledPart` `TINYINT(1)` NOT NULL,
	`Alloy` `nvarchar`(255) NULL,
	`AlloyAutoNumber` `nvarchar`(255) NULL,
	`ItemWeight` `nvarchar`(255) NULL,
	`QtyRequired` `DOUBLE` NULL,
	`QtyToManufacture` `DOUBLE` NULL,
	`WHSLocation` `nvarchar`(255) NULL,
	`GrindingToShip` `TINYINT(1)` NOT NULL,
	`HeatTreatRequired` `TINYINT(1)` NOT NULL,
	`JobComplete` `TINYINT(1)` NOT NULL,
	`FinalInspecPerformedBy` `nvarchar`(255) NULL,
	`SpecialMfgInstructions` `nvarchar`(255) NULL,
	`Notes` `nvarchar`(255) NULL,
	`MoldingFinished` `TINYINT(1)` NOT NULL,
	`PouringFinished` `TINYINT(1)` NOT NULL,
	`ShakeoutFinished` `TINYINT(1)` NOT NULL,
	`FinishingFinished` `TINYINT(1)` NOT NULL,
	`HeatTreatFinished` `TINYINT(1)` NOT NULL,
	`MachiningFinished` `TINYINT(1)` NOT NULL,
	`AssemblyFinished` `TINYINT(1)` NOT NULL,
	`Scrapped` `TINYINT(1)` NOT NULL,
	`DateScrapped` `nvarchar`(255) NULL,
	`NoScrapped` `nvarchar`(255) NULL,
	`ReasonScrapped` `nvarchar`(255) NULL,
	`ResponsibleScrapLocation` `nvarchar`(255) NULL,
	`RootCauseForScrap` `nvarchar`(255) NULL,
	`CNCProgram` `TINYINT(1)` NOT NULL,
	`ReasonLate` `nvarchar`(255) NULL,
	`SpecialInstructions` `nvarchar`(255) NULL,
	`ComputerName` `nvarchar`(255) NULL,
	`Rush` `TINYINT(1)` NOT NULL,
	`RushDueDate` `nvarchar`(255) NULL,
	`Type` `nvarchar`(255) NULL,
	`PourWt` `nvarchar`(255) NULL,
	`Remake` `TINYINT(1)` NOT NULL,
	`HeatSchedulesid` `nvarchar`(255) NULL,
	`Machinenumber` `nvarchar`(255) NULL,
	`ScheduleFlag` `TINYINT(1)` NOT NULL,
	`RecStatus` `nvarchar`(255) NULL,
	`INVLocation` `nvarchar`(255) NULL,
	`RecordType` `DOUBLE` NULL,
	`PartAdded` `TINYINT(1)` NOT NULL,
	`DueDate` `nvarchar`(255) NULL,
	`MachShopDate` `nvarchar`(255) NULL,
	`ReleasedToShippingDate` `nvarchar`(255) NULL,
	`FinalInspecDate` `nvarchar`(255) NULL,
	`DateEntered` `nvarchar`(255) NULL,
	`MoldingDueDate` `nvarchar`(255) NULL,
	`PouringSch` `nvarchar`(255) NULL,
	`ShakeOutSch` `nvarchar`(255) NULL,
	`ShakeOutComp` `nvarchar`(255) NULL,
	`GrindingSch` `nvarchar`(255) NULL,
	`HeatTreatSch` `nvarchar`(255) NULL,
	`SurfaceGrdSch` `nvarchar`(255) NULL,
	`SurfaceGrdComp` `nvarchar`(255) NULL,
	`BoringSch` `nvarchar`(255) NULL,
	`BoringComp` `nvarchar`(255) NULL,
	`DrillingSch` `nvarchar`(255) NULL,
	`DrillingComp` `nvarchar`(255) NULL,
	`STBalancingSch` `nvarchar`(255) NULL,
	`STBalancingComp` `nvarchar`(255) NULL,
	`DynBalancingSch` `nvarchar`(255) NULL,
	`DynBalancingComp` `nvarchar`(255) NULL,
	`FinalInspComp` `nvarchar`(255) NULL,
	`PaintToShip` `nvarchar`(255) NULL,
	`MillingComp` `nvarchar`(255) NULL,
	`HeatTreatComp` `nvarchar`(255) NULL,
	`DeliveryComp` `nvarchar`(255) NULL,
	`MoldSetupComp` `nvarchar`(255) NULL,
	`MoldingComp` `nvarchar`(255) NULL,
	`PatternComp` `nvarchar`(255) NULL,
	`ThreadingComp` `nvarchar`(255) NULL,
	`PouringComp` `nvarchar`(255) NULL,
	`GrindingComp` `nvarchar`(255) NULL,
	`RiderPrinted` `nvarchar`(255) NULL,
	`PartTranscode` `nvarchar`(255) NULL,
	`ProdctionFinshed` `TINYINT(1)` NOT NULL,
	`MachineNotes` `nvarchar`(255) NULL,
	`Statusnotes` `nvarchar`(255) NULL,
	`CustomerNumber` `nvarchar`(255) NULL,
	`MachineComp` `nvarchar`(255) NULL,
	`MfgCncComp` `nvarchar`(255) NULL,
	`Cryocomp` `nvarchar`(255) NULL,
	`InvDateTime` `nvarchar`(255) NULL,
	`PouringScheduleFlag` `TINYINT(1)` NOT NULL,
	`PourAssignDate` `nvarchar`(255) NULL,
	`PRRecStatus` `nvarchar`(255) NULL,
	`ShippingDate` `nvarchar`(255) NULL,
	`ReleasedToShippingFlag` `nvarchar`(255) NULL,
	`Specialflag` `TINYINT(1)` NOT NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`HeatTreatRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`HeatTreatRecords`(
	`WorkOrderId` `int` NOT NULL,
	`TreatDate` `date` NULL,
	`Temperature` `DOUBLE` NULL,
	`DurationHours` `DOUBLE` NULL,
	`Notes` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`WorkOrderId` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`HeatTreatTime`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`HeatTreatTime`(
	`RecordTie` `DOUBLE` NULL,
	`HeatTreatDate` `nvarchar`(255) NULL,
	`QtyHeated` `DOUBLE` NULL,
	`NoHeatTreat` `DOUBLE` NULL,
	`HeatNos` `DOUBLE` NULL,
	`HeatTreatFurnaceNo` `DOUBLE` NULL,
	`HeatTreatHardness` `DOUBLE` NULL,
	`HeatTreatNotes` `nvarchar`(255) NULL,
	`HeatTreatProcessNo` `nvarchar`(255) NULL,
	`ID` `DOUBLE` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`InspectionRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`InspectionRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`InspectionDate` `date` NULL,
	`Inspector` `nvarchar`(100) NULL,
	`InspectionNotes` `nvarchar`(max) NULL,
	`Pass` `TINYINT(1)` NULL,
	`CreatedAt` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`LSTCub_2_Categories`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`LSTCub_2_Categories`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`Code` `nvarchar`(50) NOT NULL,
	`Description` `nvarchar`(255) NOT NULL,
	`Defect_sub_Category` `nvarchar`(10) NOT NULL,
	`Select` `TINYINT(1)` NOT NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`MachineTime`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`MachineTime`(
	`Record` `DOUBLE` NULL,
	`NoMachined` `DOUBLE` NULL,
	`MachineHrs` `nvarchar`(255) NULL,
	`MachineNotes` `nvarchar`(255) NULL,
	`QtyReleasedToShipping` `DOUBLE` NULL,
	`CNCMachined` `TINYINT(1)` NOT NULL,
	`StartWht` `DOUBLE` NULL,
	`EndWht` `DOUBLE` NULL,
	`ID` `DOUBLE` NULL,
	`MachineDate` `datetime` NULL,
	`UpdatedAt` `datetime` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`MachineTime_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`MachineTime_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_ID` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`MainScrapTbl`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`MainScrapTbl`(
	`ID` `int` AUTO_INCREMENT NOT NULL,
	`RecordNumber` `int` NOT NULL,
	`SearialNum` `nvarchar`(50) NOT NULL,
	`WorkorderNo` `nvarchar`(50) NOT NULL,
	`PartNo` `nvarchar`(50) NOT NULL,
	`Alloy` `nvarchar`(50) NOT NULL,
	`Description` `nvarchar`(max) NOT NULL,
	`MfgInst` `nvarchar`(max) NOT NULL,
	`DefectCategory` `nvarchar`(50) NULL,
	`Defect_sub_Category` `nvarchar`(max) NULL,
	`LSTCub_2_Categories` `nvarchar`(max) NULL,
	`DefectCommonName` `nvarchar`(max) NULL,
	`Employee` `nvarchar`(50) NULL,
	`Department` `nvarchar`(50) NULL,
	`EntryDate` `date` NULL,
	`Defect` `nvarchar`(max) NULL,
	`AnalysisBy` `nvarchar`(50) NULL,
	`AnalysisDate` `nvarchar`(50) NULL,
	`Scrapping` `TINYINT(1)` NOT NULL,
	`ProblemStatment` `nvarchar`(max) NULL,
	`DataColected` `nvarchar`(max) NULL,
	`DataEvaluation` `nvarchar`(max) NULL,
	`CorrectivePlan` `nvarchar`(max) NULL,
	`Actiontrial` `TINYINT(1)` NOT NULL,
	`DecribeActionTrial` `nvarchar`(max) NULL,
	`EvaluationActionTrial` `nvarchar`(max) NULL,
	`EvaluationProductionTest` `nvarchar`(max) NULL,
	`ResultApprovedby` `nvarchar`(50) NULL,
	`ResultApprovedbyDate` `date` NULL,
	`ProductionTestApp` `nvarchar`(50) NULL,
	`ProductionTestdate` `date` NULL,
	`sourcedefectcorrected` `TINYINT(1)` NOT NULL,
	`ItemWeight` `int` NULL,
	`PatternLabel` `nvarchar`(50) NULL,
	`PlanAppby` `nvarchar`(50) NULL,
	`PlanAppDate` `date` NULL,
	`solutiondoc` `nvarchar`(max) NULL,
	`QAMgr` `nvarchar`(50) NULL,
	`QAMgrDate` `date` NULL,
	`DefectCommonNameTXT` `nvarchar`(max) NULL,
	`lstPlanAppby` `nvarchar`(max) NULL,
	`lstAnalysisBy` `nvarchar`(max) NULL,
	`ProposedCorr` `nvarchar`(max) NULL,
	`NewPartSerial` `nvarchar`(50) NULL,
	`FollowupProd` `nvarchar`(max) NULL,
	`ActionImpProd` `TINYINT(1)` NULL,
	`UpdatedAt` `datetime` NULL
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`MainScrapTbl_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`MainScrapTbl_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_ID` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`MoldingRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`MoldingRecords`(
	`RecordNo` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderNo` `nvarchar`(50) NOT NULL,
	`MoldDate` `date` NOT NULL,
	`MoldShift` `nvarchar`(20) NULL,
	`MoldOperator` `nvarchar`(100) NULL,
	`PatternNo` `nvarchar`(50) NULL,
	`Alloy` `nvarchar`(50) NULL,
	`PartNo` `nvarchar`(50) NULL,
	`MoldNotes` `nvarchar`(max) NULL,
	`MoldingFinished` `TINYINT(1)` NULL,
	`CreatedAt` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`RecordNo` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`MoldTime`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`MoldTime`(
	`Record No` `DOUBLE` NULL,
	`Date Molded` `nvarchar`(255) NULL,
	`Shift Molded` `nvarchar`(255) NULL,
	`No Molded` `DOUBLE` NULL,
	`MoldManHrs` `DOUBLE` NULL,
	`Mold Notes` `nvarchar`(255) NULL,
	`1000Resin #/min` `DOUBLE` NULL,
	`1000Catalyst #/min` `DOUBLE` NULL,
	`1000Sand #/min` `DOUBLE` NULL,
	`1000LOI %` `DOUBLE` NULL,
	`600Resin #/min` `DOUBLE` NULL,
	`600Catalyst #/min` `DOUBLE` NULL,
	`600Sand #/min` `DOUBLE` NULL,
	`600LOI %` `DOUBLE` NULL,
	`ID` `DOUBLE` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`Parts`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`Parts`(
	`PartNo` `varchar`(50) NOT NULL,
	`PartDescription` `varchar`(255) NULL,
	`Alloy` `varchar`(50) NULL,
PRIMARY KEY CLUSTERED 
(
	`PartNo` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`PouringRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`PouringRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NULL,
	`PourDate` `datetime` NULL,
	`Alloy` `nvarchar`(50) NULL,
	`Notes` `nvarchar`(max) NULL,
	`UpdatedAt` `datetime` NULL,
	`HeatNo` `varchar`(50) NULL,
	`TapTemp` `decimal`(5, 2) NULL,
	`PourTemp` `decimal`(5, 2) NULL,
	`Furnace` `varchar`(50) NULL,
	`Ladle` `varchar`(50) NULL,
	`Pourer` `varchar`(100) NULL
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`PouringRecords_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`PouringRecords_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_Id` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`PouringTime`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`PouringTime`(
	`RecordLink` `DOUBLE` NULL,
	`DatePoured` `nvarchar`(255) NULL,
	`NoPoured` `DOUBLE` NULL,
	`HeatNo` `DOUBLE` NULL,
	`Material` `nvarchar`(255) NULL,
	`MaterialAutoNumber` `nvarchar`(255) NULL,
	`NoLost` `nvarchar`(255) NULL,
	`PouringNotes` `nvarchar`(255) NULL,
	`PouringTime` `DOUBLE` NULL,
	`TapTemperature` `DOUBLE` NULL,
	`PourTemperature` `DOUBLE` NULL,
	`ShakeoutDueDate` `nvarchar`(255) NULL,
	`ActualShakeoutDate` `nvarchar`(255) NULL,
	`ShakeoutComplete` `TINYINT(1)` NOT NULL,
	`PourOrder` `DOUBLE` NULL,
	`PouredBy` `nvarchar`(255) NULL,
	`Furnace` `DOUBLE` NULL,
	`Ladle` `DOUBLE` NULL,
	`ID` `DOUBLE` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`ProcessData`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`ProcessData`(
	`Code` `int` NULL,
	`Name` `nvarchar`(50) NULL,
	`Select` `TINYINT(1)` NULL
) ON `PRIMARY`

/****** Object:  Table `dbo`.`QualityIssues`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`QualityIssues`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`InspectionRecordId` `int` NULL,
	`Stage` `nvarchar`(100) NOT NULL,
	`IssueType` `nvarchar`(255) NULL,
	`Severity` `nvarchar`(50) NULL,
	`Description` `nvarchar`(max) NULL,
	`DetectedBy` `nvarchar`(100) NULL,
	`Resolved` `TINYINT(1)` NULL,
	`ResolutionNotes` `nvarchar`(max) NULL,
	`CreatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`ScrapRecords`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`ScrapRecords`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`ScrapDate` `date` NULL,
	`ScrapReason` `nvarchar`(200) NULL,
	`ScrapQty` `int` NULL,
	`ScrapWarehouse` `nvarchar`(100) NULL,
	`ScrapOperator` `nvarchar`(100) NULL,
	`CreatedAt` `datetime` NULL,
	`UpdatedAt` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`SerialNumbers`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`SerialNumbers`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`Serial` `nvarchar`(100) NOT NULL,
	`Status` `nvarchar`(100) NULL,
	`Created_At` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`users`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`users`(
	`id` `int` AUTO_INCREMENT NOT NULL,
	`username` `nvarchar`(255) NOT NULL,
	`hashed_password` `nvarchar`(255) NOT NULL,
	`role` `nvarchar`(50) NOT NULL,
	`created_at` `datetime` NOT NULL,
PRIMARY KEY CLUSTERED 
(
	`id` ASC
)ON `PRIMARY`,
UNIQUE NONCLUSTERED 
(
	`username` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrderDocuments`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrderDocuments`(
	`DocumentID` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderRecordNo` `bigint` NULL,
	`DocumentName` `varchar`(255) NULL,
	`DocumentType` `varchar`(50) NULL,
	`FilePath` `varchar`(255) NULL,
	`UploadedAt` `datetime` NULL,
	`created_at` `datetime` NOT NULL,
	`updated_at` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`DocumentID` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrderDocuments_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrderDocuments_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_DocumentID` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrders`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrders`(
	`RecordNo` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderNo` `nvarchar`(100) NOT NULL,
	`PartNo` `nvarchar`(100) NOT NULL,
	`CustomerName` `nvarchar`(200) NULL,
	`AlloyCode` `nvarchar`(100) NULL,
	`QtyRequired` `int` NOT NULL,
	`RushDueDate` `date` NULL,
	`SerialNo` `nvarchar`(100) NULL,
	`StatusNotes` `nvarchar`(255) NULL,
	`MoldingFinished` `TINYINT(1)` NULL,
	`PouringFinished` `TINYINT(1)` NULL,
	`HeatTreatFinished` `TINYINT(1)` NULL,
	`MachiningFinished` `TINYINT(1)` NULL,
	`AssemblyFinished` `TINYINT(1)` NULL,
	`FinalInspComp` `TINYINT(1)` NULL,
	`Status` `nvarchar`(50) NULL,
PRIMARY KEY CLUSTERED 
(
	`RecordNo` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrders_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrders_Audit`(
	`audit_id` `int` AUTO_INCREMENT NOT NULL,
	`RecordNo` `bigint` NULL,
	`action_type` `nvarchar`(20) NULL,
	`action_time` `datetime` NULL,
	`action_user` `nvarchar`(100) NULL,
PRIMARY KEY CLUSTERED 
(
	`audit_id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrderSerialNumbers`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrderSerialNumbers`(
	`SerialID` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderRecordNo` `bigint` NULL,
	`SerialNumber` `varchar`(50) NULL,
	`DateAssigned` `datetime` NULL,
	`created_at` `datetime` NOT NULL,
	`updated_at` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`SerialID` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrderSerialNumbers_Audit`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrderSerialNumbers_Audit`(
	`AuditID` `int` AUTO_INCREMENT NOT NULL,
	`ActionType` `nvarchar`(10) NULL,
	`ChangedAt` `datetime` NULL,
	`ChangedBy` `nvarchar`(100) NULL,
	`Original_SerialID` `int` NULL,
	`DataBefore` `nvarchar`(max) NULL,
	`DataAfter` `nvarchar`(max) NULL,
PRIMARY KEY CLUSTERED 
(
	`AuditID` ASC
)ON `PRIMARY`
) ON `PRIMARY` TEXTIMAGE_ON `PRIMARY`

/****** Object:  Table `dbo`.`WorkOrderStageLog`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE `dbo`.`WorkOrderStageLog`(
	`Id` `int` AUTO_INCREMENT NOT NULL,
	`WorkOrderId` `int` NOT NULL,
	`StageName` `nvarchar`(100) NOT NULL,
	`Action` `nvarchar`(50) NOT NULL,
	`PerformedBy` `nvarchar`(100) NULL,
	`Notes` `nvarchar`(1000) NULL,
	`Timestamp` `datetime` NULL,
PRIMARY KEY CLUSTERED 
(
	`Id` ASC
)ON `PRIMARY`
) ON `PRIMARY`

/****** Object:  View `dbo`.`vw_ActiveWorkOrders`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_ActiveWorkOrders` AS
SELECT *
FROM WorkOrders
WHERE is_deleted = 0;

/****** Object:  View `dbo`.`vw_ChemistryElementsUnpivoted`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_ChemistryElementsUnpivoted` AS
SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'C' AS Element,
    `C` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Si' AS Element,
    `Si` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Mn' AS Element,
    `Mn` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'P' AS Element,
    `P` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'S' AS Element,
    `S` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Ni' AS Element,
    `Ni` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Cr' AS Element,
    `Cr` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Mo' AS Element,
    `Mo` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'V' AS Element,
    `V` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Cu' AS Element,
    `Cu` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Fe' AS Element,
    `Fe` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'W' AS Element,
    `W` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Ti' AS Element,
    `Ti` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Sn' AS Element,
    `Sn` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Co' AS Element,
    `Co` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Al' AS Element,
    `Al` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Cb' AS Element,
    `Cb` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Pb' AS Element,
    `Pb` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'B' AS Element,
    `B` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Nb' AS Element,
    `Nb` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Zr' AS Element,
    `Zr` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Mg' AS Element,
    `Mg` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Ce' AS Element,
    `Ce` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'Ta' AS Element,
    `Ta` AS Percentage
FROM ChemistryResults
UNION ALL

SELECT 
    work_order_id,
    heat_number,
    sample_number,
    furnace,
    date_poured,
    alloy_code,
    'N' AS Element,
    `N` AS Percentage
FROM ChemistryResults
;

/****** Object:  View `dbo`.`vw_ChemistryResults_AuditLog`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_ChemistryResults_AuditLog` AS
SELECT 
    AuditID,
    ActionType,
    ChangedAt,
    ISNULL(ChangedBy, CONVERT(VARCHAR(100), CONTEXT_INFO())) AS ChangedBy,
    Original_id,
    CASE 
        WHEN ActionType = 'INSERT' THEN DataAfter
        WHEN ActionType = 'DELETE' THEN DataBefore
        WHEN ActionType = 'UPDATE' THEN CONCAT('BEFORE: ', DataBefore, ' | AFTER: ', DataAfter)
    END AS ChangeDetails
FROM ChemistryResults_Audit;

/****** Object:  View `dbo`.`vw_ChemistrySummary`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_ChemistrySummary` AS
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
LEFT JOIN WorkOrders wo ON cr.work_order_id = wo.RecordNo;

/****** Object:  View `dbo`.`vw_OpenWorkOrdersSummary`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_OpenWorkOrdersSummary` AS
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

/****** Object:  View `dbo`.`vw_ScrapDetailSummary`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_ScrapDetailSummary` AS
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

/****** Object:  View `dbo`.`vw_ScrapSummary`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_ScrapSummary` AS
SELECT 
    ms.PartNo,
    p.PartDescription,
    ms.DefectCategory,
    COUNT(*) AS ScrapCount
FROM MainScrapTbl ms
LEFT JOIN Parts p ON ms.PartNo = p.PartNo
WHERE ms.Scrapping = 1
GROUP BY ms.PartNo, p.PartDescription, ms.DefectCategory;

/****** Object:  View `dbo`.`vw_WorkOrderActiveSummary`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_WorkOrderActiveSummary` AS
SELECT 
    RecordNo,
    Customer,
    PartNo,
    status,
    created_at,
    updated_at
FROM WorkOrders
WHERE is_deleted = 0;

/****** Object:  View `dbo`.`vw_WorkOrderBacklog`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_WorkOrderBacklog` AS
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

/****** Object:  View `dbo`.`vw_WorkOrderSerials_AuditStats`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_WorkOrderSerials_AuditStats` AS
SELECT 
    Original_SerialID,
    COUNT(*) AS ChangeCount,
    MAX(ChangedAt) AS LastChanged
FROM WorkOrderSerialNumbers_Audit
GROUP BY Original_SerialID;

/****** Object:  View `dbo`.`vw_WorkOrderStatusSummary`    Script Date: 8/15/2025 10:52:56 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_WorkOrderStatusSummary` AS
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

/****** Object:  View `dbo`.`vw_WorkOrderSummary`    Script Date: 8/15/2025 10:52:57 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE VIEW `dbo`.`vw_WorkOrderSummary` AS
SELECT 
    RecordNo,
    status,
    created_at,
    updated_at,
    FinalInspComp,
    Customer,
    PartNo
FROM WorkOrders;

/****** Object:  Index `IX_Attachedfiles_MainScrapTblID`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_Attachedfiles_MainScrapTblID` ON `dbo`.`Attachedfiles`
(
	`MainScrapTblID` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_ChemistryResults_work_order_id`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_ChemistryResults_work_order_id` ON `dbo`.`ChemistryResults`
(
	`work_order_id` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_FinishingRecords_WorkOrderId`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_FinishingRecords_WorkOrderId` ON `dbo`.`FinishingRecords`
(
	`WorkOrderId` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_HeatTreatRecords_WorkOrderId`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_HeatTreatRecords_WorkOrderId` ON `dbo`.`HeatTreatRecords`
(
	`WorkOrderId` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_MachineTime_MachineDate`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_MachineTime_MachineDate` ON `dbo`.`MachineTime`
(
	`MachineDate` ASC
)ON `PRIMARY`

SET ANSI_PADDING ON

/****** Object:  Index `IX_MainScrapTbl_DefectCategory`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_MainScrapTbl_DefectCategory` ON `dbo`.`MainScrapTbl`
(
	`DefectCategory` ASC
)ON `PRIMARY`

SET ANSI_PADDING ON

/****** Object:  Index `IX_MainScrapTbl_PartNo`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_MainScrapTbl_PartNo` ON `dbo`.`MainScrapTbl`
(
	`PartNo` ASC
)ON `PRIMARY`

SET ANSI_PADDING ON

/****** Object:  Index `IX_MainScrapTbl_WorkorderNo`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_MainScrapTbl_WorkorderNo` ON `dbo`.`MainScrapTbl`
(
	`WorkorderNo` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_PouringRecords_WorkOrderId`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_PouringRecords_WorkOrderId` ON `dbo`.`PouringRecords`
(
	`WorkOrderId` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_WorkOrderDocuments_WorkOrderRecordNo`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_WorkOrderDocuments_WorkOrderRecordNo` ON `dbo`.`WorkOrderDocuments`
(
	`WorkOrderRecordNo` ASC
)ON `PRIMARY`

/****** Object:  Index `IX_WorkOrderSerialNumbers_WorkOrderRecordNo`    Script Date: 8/15/2025 10:52:57 AM ******/
CREATE NONCLUSTERED INDEX `IX_WorkOrderSerialNumbers_WorkOrderRecordNo` ON `dbo`.`WorkOrderSerialNumbers`
(
	`WorkOrderRecordNo` ASC
)ON `PRIMARY`

ALTER TABLE `dbo`.`AlloySpecifications` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `Created_At`

ALTER TABLE `dbo`.`Aproveusers` ADD  CONSTRAINT `DF_Aproveusers_Select`  DEFAULT ((0)) FOR `Select`

ALTER TABLE `dbo`.`AssemblyRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`AssemblyRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UpdatedAt`

ALTER TABLE `dbo`.`Attachedfiles` ADD  CONSTRAINT `DF_Attachedfiles_GridNumber`  DEFAULT ((0)) FOR `GridNumber`

ALTER TABLE `dbo`.`AuditLogs` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `Timestamp`

ALTER TABLE `dbo`.`ChemAddRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`ChemAddRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UpdatedAt`

ALTER TABLE `dbo`.`ChemistryRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`ChemistryRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UpdatedAt`

ALTER TABLE `dbo`.`ChemistryResults` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `created_at`

ALTER TABLE `dbo`.`ChemistryResults_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`Defect_sub_Category` ADD  CONSTRAINT `DF_Defect_sub_Category_Select`  DEFAULT ((0)) FOR `Select`

ALTER TABLE `dbo`.`DefectCategory` ADD  CONSTRAINT `DF_DefectCategory_Select`  DEFAULT ((0)) FOR `Select`

ALTER TABLE `dbo`.`DefectCommonName` ADD  CONSTRAINT `DF_DefectCommonName_select`  DEFAULT ((0)) FOR `select`

ALTER TABLE `dbo`.`Documents` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UploadedAt`

ALTER TABLE `dbo`.`Employees` ADD  CONSTRAINT `DF_Employees_DeptID`  DEFAULT ((0)) FOR `DeptID`

ALTER TABLE `dbo`.`FinishingRecords_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`InspectionRecords` ADD  DEFAULT ((0)) FOR `Pass`

ALTER TABLE `dbo`.`InspectionRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`InspectionRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UpdatedAt`

ALTER TABLE `dbo`.`LSTCub_2_Categories` ADD  CONSTRAINT `DF_LSTCub_2_Categories_Select`  DEFAULT ((0)) FOR `Select`

ALTER TABLE `dbo`.`MachineTime_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`MainScrapTbl` ADD  CONSTRAINT `DF_MainScrapTbl_RecordNumber`  DEFAULT ((0)) FOR `RecordNumber`

ALTER TABLE `dbo`.`MainScrapTbl` ADD  CONSTRAINT `DF_MainScrapTbl_Scrapping`  DEFAULT ((0)) FOR `Scrapping`

ALTER TABLE `dbo`.`MainScrapTbl` ADD  CONSTRAINT `DF_MainScrapTbl_Actiontrial`  DEFAULT ((0)) FOR `Actiontrial`

ALTER TABLE `dbo`.`MainScrapTbl` ADD  CONSTRAINT `DF_MainScrapTbl_sourcedefectcorrected`  DEFAULT ((0)) FOR `sourcedefectcorrected`

ALTER TABLE `dbo`.`MainScrapTbl_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`MoldingRecords` ADD  DEFAULT ((0)) FOR `MoldingFinished`

ALTER TABLE `dbo`.`MoldingRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`MoldingRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UpdatedAt`

ALTER TABLE `dbo`.`PouringRecords_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`ProcessData` ADD  CONSTRAINT `DF_ProcessData_Select`  DEFAULT ((0)) FOR `Select`

ALTER TABLE `dbo`.`QualityIssues` ADD  DEFAULT ((0)) FOR `Resolved`

ALTER TABLE `dbo`.`QualityIssues` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`ScrapRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `CreatedAt`

ALTER TABLE `dbo`.`ScrapRecords` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UpdatedAt`

ALTER TABLE `dbo`.`SerialNumbers` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `Created_At`

ALTER TABLE `dbo`.`users` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `created_at`

ALTER TABLE `dbo`.`WorkOrderDocuments` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `UploadedAt`

ALTER TABLE `dbo`.`WorkOrderDocuments` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `created_at`

ALTER TABLE `dbo`.`WorkOrderDocuments_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`WorkOrders_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `action_time`

ALTER TABLE `dbo`.`WorkOrders_Audit` ADD  DEFAULT (suser_sname()) FOR `action_user`

ALTER TABLE `dbo`.`WorkOrderSerialNumbers` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `DateAssigned`

ALTER TABLE `dbo`.`WorkOrderSerialNumbers` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `created_at`

ALTER TABLE `dbo`.`WorkOrderSerialNumbers_Audit` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `ChangedAt`

ALTER TABLE `dbo`.`WorkOrderStageLog` ADD  DEFAULT (CURRENT_TIMESTAMP) FOR `Timestamp`

ALTER TABLE `dbo`.`AssemblyRecords`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`MoldingRecords` (`RecordNo`)
ON DELETE CASCADE

ALTER TABLE `dbo`.`AuditLogs`  WITH CHECK ADD  CONSTRAINT `FK_AuditLogs_UserId` FOREIGN KEY(`UserId`)
REFERENCES `dbo`.`users` (`id`)
ON DELETE CASCADE

ALTER TABLE `dbo`.`AuditLogs` CHECK CONSTRAINT `FK_AuditLogs_UserId`

ALTER TABLE `dbo`.`ChemAddRecords`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)
ON DELETE CASCADE

ALTER TABLE `dbo`.`ChemistryRecords`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)
ON DELETE CASCADE

ALTER TABLE `dbo`.`Documents`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)

ALTER TABLE `dbo`.`InspectionRecords`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)
ON DELETE CASCADE

ALTER TABLE `dbo`.`QualityIssues`  WITH CHECK ADD FOREIGN KEY(`InspectionRecordId`)
REFERENCES `dbo`.`InspectionRecords` (`Id`)

ALTER TABLE `dbo`.`QualityIssues`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)

ALTER TABLE `dbo`.`ScrapRecords`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)
ON DELETE CASCADE

ALTER TABLE `dbo`.`SerialNumbers`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)

ALTER TABLE `dbo`.`WorkOrderStageLog`  WITH CHECK ADD FOREIGN KEY(`WorkOrderId`)
REFERENCES `dbo`.`WorkOrders` (`RecordNo`)

/****** Object:  StoredProcedure `dbo`.`sp_CleanupOldAuditLogs`    Script Date: 8/15/2025 10:52:57 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE `dbo`.`sp_CleanupOldAuditLogs`
    @DaysOld INT = 90
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @cutoff DATETIME = DATEADD(DAY, -@DaysOld, CURRENT_TIMESTAMP);

    DELETE FROM ChemistryResults_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM WorkOrderDocuments_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM WorkOrderSerialNumbers_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM MainScrapTbl_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM PouringRecords_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM MachineTime_Audit WHERE ChangedAt < @cutoff;
    DELETE FROM FinishingRecords_Audit WHERE ChangedAt < @cutoff;
END;

USE `master`

ALTER DATABASE `Townley` SET  READ_WRITE 

-- =========================================================
-- END Townleyfulldatabaseschema_portable.sql
-- =========================================================


-- =========================================================
-- BEGIN townley_schema_patch_nonbreaking.sql
-- =========================================================
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

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'rpt')
    EXEC(N'CREATE SCHEMA rpt AUTHORIZATION dbo');

-- Add PK on dbo.Attachedfiles(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`Attachedfiles`')
)
BEGIN
    ALTER TABLE `dbo`.`Attachedfiles` ADD CONSTRAINT `PK_Attachedfiles_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.Defect_sub_Category(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`Defect_sub_Category`')
)
BEGIN
    ALTER TABLE `dbo`.`Defect_sub_Category` ADD CONSTRAINT `PK_Defect_sub_Category_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.DefectCategory(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`DefectCategory`')
)
BEGIN
    ALTER TABLE `dbo`.`DefectCategory` ADD CONSTRAINT `PK_DefectCategory_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.DefectCommonName(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`DefectCommonName`')
)
BEGIN
    ALTER TABLE `dbo`.`DefectCommonName` ADD CONSTRAINT `PK_DefectCommonName_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.Employees(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`Employees`')
)
BEGIN
    ALTER TABLE `dbo`.`Employees` ADD CONSTRAINT `PK_Employees_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.FinishingRecords(Id) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`FinishingRecords`')
)
BEGIN
    ALTER TABLE `dbo`.`FinishingRecords` ADD CONSTRAINT `PK_FinishingRecords_Id` PRIMARY KEY CLUSTERED (`Id` ASC);
END

-- Add PK on dbo.LSTCub_2_Categories(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`LSTCub_2_Categories`')
)
BEGIN
    ALTER TABLE `dbo`.`LSTCub_2_Categories` ADD CONSTRAINT `PK_LSTCub_2_Categories_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.MainScrapTbl(ID) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`MainScrapTbl`')
)
BEGIN
    ALTER TABLE `dbo`.`MainScrapTbl` ADD CONSTRAINT `PK_MainScrapTbl_ID` PRIMARY KEY CLUSTERED (`ID` ASC);
END

-- Add PK on dbo.PouringRecords(Id) (safe: single IDENTITY column)
IF NOT EXISTS (
    SELECT 1
    FROM sys.key_constraints kc
    WHERE kc.`type` = 'PK'
      AND kc.parent_object_id = OBJECT_ID(N'`dbo`.`PouringRecords`')
)
BEGIN
    ALTER TABLE `dbo`.`PouringRecords` ADD CONSTRAINT `PK_PouringRecords_Id` PRIMARY KEY CLUSTERED (`Id` ASC);
END

-- Index for lookup/join: dbo.AssemblyRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AssemblyRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`AssemblyRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_AssemblyRecords_WorkOrderId` ON `dbo`.`AssemblyRecords` (`WorkOrderId` ASC);
END

-- Index for time-based filtering: dbo.AssemblyRecords(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AssemblyRecords_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`AssemblyRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_AssemblyRecords_CreatedAt` ON `dbo`.`AssemblyRecords` (`CreatedAt` ASC);
END

-- Index for time-based filtering: dbo.AssemblyRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AssemblyRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`AssemblyRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_AssemblyRecords_UpdatedAt` ON `dbo`.`AssemblyRecords` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.Attachedfiles(`MainScrapTblID`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_Attachedfiles_MainScrapTblID' AND object_id = OBJECT_ID(N'`dbo`.`Attachedfiles`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_Attachedfiles_MainScrapTblID` ON `dbo`.`Attachedfiles` (`MainScrapTblID` ASC);
END

-- Index for lookup/join: dbo.AuditLogs(`UserId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_AuditLogs_UserId' AND object_id = OBJECT_ID(N'`dbo`.`AuditLogs`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_AuditLogs_UserId` ON `dbo`.`AuditLogs` (`UserId` ASC);
END

-- Index for lookup/join: dbo.ChemAddRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemAddRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`ChemAddRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemAddRecords_WorkOrderId` ON `dbo`.`ChemAddRecords` (`WorkOrderId` ASC);
END

-- Index for time-based filtering: dbo.ChemAddRecords(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemAddRecords_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ChemAddRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemAddRecords_CreatedAt` ON `dbo`.`ChemAddRecords` (`CreatedAt` ASC);
END

-- Index for time-based filtering: dbo.ChemAddRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemAddRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ChemAddRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemAddRecords_UpdatedAt` ON `dbo`.`ChemAddRecords` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.ChemistryRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`ChemistryRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemistryRecords_WorkOrderId` ON `dbo`.`ChemistryRecords` (`WorkOrderId` ASC);
END

-- Index for lookup/join: dbo.ChemistryRecords(`SampleId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_SampleId' AND object_id = OBJECT_ID(N'`dbo`.`ChemistryRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemistryRecords_SampleId` ON `dbo`.`ChemistryRecords` (`SampleId` ASC);
END

-- Index for time-based filtering: dbo.ChemistryRecords(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ChemistryRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemistryRecords_CreatedAt` ON `dbo`.`ChemistryRecords` (`CreatedAt` ASC);
END

-- Index for time-based filtering: dbo.ChemistryRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ChemistryRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemistryRecords_UpdatedAt` ON `dbo`.`ChemistryRecords` (`UpdatedAt` ASC);
END

-- Index for time-based filtering: dbo.ChemistryResults(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ChemistryResults_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ChemistryResults`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ChemistryResults_UpdatedAt` ON `dbo`.`ChemistryResults` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.Documents(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_Documents_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`Documents`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_Documents_WorkOrderId` ON `dbo`.`Documents` (`WorkOrderId` ASC);
END

-- Index for lookup/join: dbo.Employees(`DeptID`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_Employees_DeptID' AND object_id = OBJECT_ID(N'`dbo`.`Employees`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_Employees_DeptID` ON `dbo`.`Employees` (`DeptID` ASC);
END

-- Index for lookup/join: dbo.FinishingRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FinishingRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`FinishingRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_FinishingRecords_WorkOrderId` ON `dbo`.`FinishingRecords` (`WorkOrderId` ASC);
END

-- Index for time-based filtering: dbo.FinishingRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FinishingRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`FinishingRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_FinishingRecords_UpdatedAt` ON `dbo`.`FinishingRecords` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.FinishTime(`RecordID`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FinishTime_RecordID' AND object_id = OBJECT_ID(N'`dbo`.`FinishTime`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_FinishTime_RecordID` ON `dbo`.`FinishTime` (`RecordID` ASC);
END

-- Index for lookup/join: dbo.FoundryWorkData(`HeatSchedulesid`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_FoundryWorkData_HeatSchedulesid' AND object_id = OBJECT_ID(N'`dbo`.`FoundryWorkData`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_FoundryWorkData_HeatSchedulesid` ON `dbo`.`FoundryWorkData` (`HeatSchedulesid` ASC);
END

-- Index for lookup/join: dbo.InspectionRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_InspectionRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`InspectionRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_InspectionRecords_WorkOrderId` ON `dbo`.`InspectionRecords` (`WorkOrderId` ASC);
END

-- Index for time-based filtering: dbo.InspectionRecords(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_InspectionRecords_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`InspectionRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_InspectionRecords_CreatedAt` ON `dbo`.`InspectionRecords` (`CreatedAt` ASC);
END

-- Index for time-based filtering: dbo.InspectionRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_InspectionRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`InspectionRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_InspectionRecords_UpdatedAt` ON `dbo`.`InspectionRecords` (`UpdatedAt` ASC);
END

-- Index for time-based filtering: dbo.MachineTime(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MachineTime_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`MachineTime`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_MachineTime_UpdatedAt` ON `dbo`.`MachineTime` (`UpdatedAt` ASC);
END

-- Index for time-based filtering: dbo.MainScrapTbl(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MainScrapTbl_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`MainScrapTbl`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_MainScrapTbl_UpdatedAt` ON `dbo`.`MainScrapTbl` (`UpdatedAt` ASC);
END

-- Index for time-based filtering: dbo.MoldingRecords(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MoldingRecords_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`MoldingRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_MoldingRecords_CreatedAt` ON `dbo`.`MoldingRecords` (`CreatedAt` ASC);
END

-- Index for time-based filtering: dbo.MoldingRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_MoldingRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`MoldingRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_MoldingRecords_UpdatedAt` ON `dbo`.`MoldingRecords` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.PouringRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_PouringRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`PouringRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_PouringRecords_WorkOrderId` ON `dbo`.`PouringRecords` (`WorkOrderId` ASC);
END

-- Index for time-based filtering: dbo.PouringRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_PouringRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`PouringRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_PouringRecords_UpdatedAt` ON `dbo`.`PouringRecords` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.QualityIssues(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_QualityIssues_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`QualityIssues`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_QualityIssues_WorkOrderId` ON `dbo`.`QualityIssues` (`WorkOrderId` ASC);
END

-- Index for lookup/join: dbo.QualityIssues(`InspectionRecordId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_QualityIssues_InspectionRecordId' AND object_id = OBJECT_ID(N'`dbo`.`QualityIssues`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_QualityIssues_InspectionRecordId` ON `dbo`.`QualityIssues` (`InspectionRecordId` ASC);
END

-- Index for time-based filtering: dbo.QualityIssues(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_QualityIssues_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`QualityIssues`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_QualityIssues_CreatedAt` ON `dbo`.`QualityIssues` (`CreatedAt` ASC);
END

-- Index for lookup/join: dbo.ScrapRecords(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ScrapRecords_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`ScrapRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ScrapRecords_WorkOrderId` ON `dbo`.`ScrapRecords` (`WorkOrderId` ASC);
END

-- Index for time-based filtering: dbo.ScrapRecords(`CreatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ScrapRecords_CreatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ScrapRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ScrapRecords_CreatedAt` ON `dbo`.`ScrapRecords` (`CreatedAt` ASC);
END

-- Index for time-based filtering: dbo.ScrapRecords(`UpdatedAt`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_ScrapRecords_UpdatedAt' AND object_id = OBJECT_ID(N'`dbo`.`ScrapRecords`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_ScrapRecords_UpdatedAt` ON `dbo`.`ScrapRecords` (`UpdatedAt` ASC);
END

-- Index for lookup/join: dbo.SerialNumbers(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_SerialNumbers_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`SerialNumbers`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_SerialNumbers_WorkOrderId` ON `dbo`.`SerialNumbers` (`WorkOrderId` ASC);
END

-- Index for lookup/join: dbo.WorkOrderDocuments_Audit(`Original_DocumentID`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderDocuments_Audit_Original_DocumentID' AND object_id = OBJECT_ID(N'`dbo`.`WorkOrderDocuments_Audit`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_WorkOrderDocuments_Audit_Original_DocumentID` ON `dbo`.`WorkOrderDocuments_Audit` (`Original_DocumentID` ASC);
END

-- Index for lookup/join: dbo.WorkOrderSerialNumbers_Audit(`Original_SerialID`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderSerialNumbers_Audit_Original_SerialID' AND object_id = OBJECT_ID(N'`dbo`.`WorkOrderSerialNumbers_Audit`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_WorkOrderSerialNumbers_Audit_Original_SerialID` ON `dbo`.`WorkOrderSerialNumbers_Audit` (`Original_SerialID` ASC);
END

-- Index for lookup/join: dbo.WorkOrderStageLog(`WorkOrderId`)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'IX_WorkOrderStageLog_WorkOrderId' AND object_id = OBJECT_ID(N'`dbo`.`WorkOrderStageLog`')
)
BEGIN
    CREATE NONCLUSTERED INDEX `IX_WorkOrderStageLog_WorkOrderId` ON `dbo`.`WorkOrderStageLog` (`WorkOrderId` ASC);
END

-- Clean reporting view for dbo.FinishTime (normalize column names)
DROP VIEW IF EXISTS `rpt`.`vw_finishtime_clean`;
CREATE VIEW `rpt`.`vw_finishtime_clean` AS
SELECT
    `RecordID` AS `recordid`,
    `Finish Date` AS `finish_date`,
    `Finish Hours` AS `finish_hours`,
    `Finished By` AS `finished_by`,
    `Hardness` AS `hardness`,
    `Qty To Work On` AS `qty_to_work_on`,
    `Qty to credit` AS `qty_to_credit`,
    `No# Finished` AS `nonum_finished`,
    `Finish Notes` AS `finish_notes`,
    `ID` AS `id`
FROM `dbo`.`FinishTime`;

-- Clean reporting view for dbo.MoldTime (normalize column names)
DROP VIEW IF EXISTS `rpt`.`vw_moldtime_clean`;
CREATE VIEW `rpt`.`vw_moldtime_clean` AS
SELECT
    `Record No` AS `record_no`,
    `Date Molded` AS `date_molded`,
    `Shift Molded` AS `shift_molded`,
    `No Molded` AS `no_molded`,
    `MoldManHrs` AS `moldmanhrs`,
    `Mold Notes` AS `mold_notes`,
    `1000Resin #/min` AS `1000resin_num_min`,
    `1000Catalyst #/min` AS `1000catalyst_num_min`,
    `1000Sand #/min` AS `1000sand_num_min`,
    `1000LOI %` AS `1000loi`,
    `600Resin #/min` AS `600resin_num_min`,
    `600Catalyst #/min` AS `600catalyst_num_min`,
    `600Sand #/min` AS `600sand_num_min`,
    `600LOI %` AS `600loi`,
    `ID` AS `id`
FROM `dbo`.`MoldTime`;

-- =========================================================
-- END townley_schema_patch_nonbreaking.sql
-- =========================================================


-- =========================================================
-- BEGIN townley_core_schema_strict.sql
-- =========================================================
/*
Townley Platform - NEW Core Schema (Strict from Day 1)
Target: Microsoft SQL Server (Windows or Docker Linux container)

- Uses schemas: core (tables), rpt (read-only reporting views)
- Strict constraints: NOT NULLs, defaults, CHECK constraints, UNIQUEs
- Practical indexes for joins and common filters
- UpdatedAt maintained via triggers
*/

SET NOCOUNT ON;

-- Schemas
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'core') EXEC('CREATE SCHEMA core');

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'rpt') EXEC('CREATE SCHEMA rpt');

------------------------------------------------------------------------------
-- CORE TABLES
------------------------------------------------------------------------------

-- Parts
IF OBJECT_ID('core.Parts','U') IS NULL
BEGIN
    CREATE TABLE core.Parts (
        PartId       INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_Parts PRIMARY KEY CLUSTERED,
        PartNumber   VARCHAR(100) NOT NULL,
        `Description` VARCHAR(510) NOT NULL,
        Alloy        VARCHAR(100) NULL,
        CreatedAt    DATETIME(3) NOT NULL CONSTRAINT DF_core_Parts_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt    DATETIME(3) NOT NULL CONSTRAINT DF_core_Parts_UpdatedAt DEFAULT SYSUTCDATETIME()
    );

    ALTER TABLE core.Parts
      ADD CONSTRAINT UQ_core_Parts_PartNumber UNIQUE (PartNumber);
END

-- Customers
IF OBJECT_ID('core.Customers','U') IS NULL
BEGIN
    CREATE TABLE core.Customers (
        CustomerId   INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_Customers PRIMARY KEY CLUSTERED,
        `Name`       VARCHAR(200) NOT NULL,
        `Location`   VARCHAR(200) NULL,
        CreatedAt    DATETIME(3) NOT NULL CONSTRAINT DF_core_Customers_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt    DATETIME(3) NOT NULL CONSTRAINT DF_core_Customers_UpdatedAt DEFAULT SYSUTCDATETIME()
    );

    ALTER TABLE core.Customers
      ADD CONSTRAINT UQ_core_Customers_Name UNIQUE (`Name`);
END

-- Departments
IF OBJECT_ID('core.Departments','U') IS NULL
BEGIN
    CREATE TABLE core.Departments (
        DepartmentId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_Departments PRIMARY KEY CLUSTERED,
        `Description` VARCHAR(100) NOT NULL,
        CreatedAt    DATETIME(3) NOT NULL CONSTRAINT DF_core_Departments_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt    DATETIME(3) NOT NULL CONSTRAINT DF_core_Departments_UpdatedAt DEFAULT SYSUTCDATETIME()
    );

    ALTER TABLE core.Departments
      ADD CONSTRAINT UQ_core_Departments_Description UNIQUE (`Description`);
END

-- Users
IF OBJECT_ID('core.Users','U') IS NULL
BEGIN
    CREATE TABLE core.Users (
        UserId          INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_Users PRIMARY KEY CLUSTERED,
        Username        VARCHAR(255) NOT NULL,
        HashedPassword  VARCHAR(255) NOT NULL,
        `Role`          VARCHAR(100) NOT NULL,
        CreatedAt       DATETIME(3) NOT NULL CONSTRAINT DF_core_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt       DATETIME(3) NOT NULL CONSTRAINT DF_core_Users_UpdatedAt DEFAULT SYSUTCDATETIME()
    );

    ALTER TABLE core.Users
      ADD CONSTRAINT UQ_core_Users_Username UNIQUE (Username);

    ALTER TABLE core.Users
      ADD CONSTRAINT CK_core_Users_Username_NotBlank CHECK (LEN(LTRIM(RTRIM(Username))) > 0);
END

-- WorkOrders
IF OBJECT_ID('core.WorkOrders','U') IS NULL
BEGIN
    CREATE TABLE core.WorkOrders (
        WorkOrderId              INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_WorkOrders PRIMARY KEY CLUSTERED,
        WorkOrderNo              VARCHAR(100) NOT NULL,
        PartId                   INT NOT NULL,
        CustomerId               INT NOT NULL,
        AlloyCode                VARCHAR(100) NULL,
        QtyRequired              INT NOT NULL,
        RushDueDate              DATETIME(3) NULL,
        SerialNo                 VARCHAR(100) NULL,
        AssemblyFinished         TINYINT(1) NOT NULL CONSTRAINT DF_core_WorkOrders_AssemblyFinished DEFAULT (0),
        FinalInspectionComplete  TINYINT(1) NOT NULL CONSTRAINT DF_core_WorkOrders_FinalInspectionComplete DEFAULT (0),
        HeatTreatRequired        TINYINT(1) NOT NULL CONSTRAINT DF_core_WorkOrders_HeatTreatRequired DEFAULT (0),
        JobComplete              TINYINT(1) NOT NULL CONSTRAINT DF_core_WorkOrders_JobComplete DEFAULT (0),
        `Status`                 VARCHAR(100) NOT NULL CONSTRAINT DF_core_WorkOrders_Status DEFAULT (N'Open'),
        CreatedAt                DATETIME(3) NOT NULL CONSTRAINT DF_core_WorkOrders_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt                DATETIME(3) NOT NULL CONSTRAINT DF_core_WorkOrders_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT UQ_core_WorkOrders_WorkOrderNo UNIQUE (WorkOrderNo),
        CONSTRAINT CK_core_WorkOrders_QtyRequired_NonNegative CHECK (QtyRequired >= 0)
    );

    ALTER TABLE core.WorkOrders
      ADD CONSTRAINT FK_core_WorkOrders_Parts
      FOREIGN KEY (PartId) REFERENCES core.Parts(PartId);

    ALTER TABLE core.WorkOrders
      ADD CONSTRAINT FK_core_WorkOrders_Customers
      FOREIGN KEY (CustomerId) REFERENCES core.Customers(CustomerId);

    CREATE INDEX IX_core_WorkOrders_PartId ON core.WorkOrders(PartId);
    CREATE INDEX IX_core_WorkOrders_CustomerId ON core.WorkOrders(CustomerId);
    CREATE INDEX IX_core_WorkOrders_Status ON core.WorkOrders(`Status`);
    CREATE INDEX IX_core_WorkOrders_RushDueDate ON core.WorkOrders(RushDueDate) WHERE RushDueDate IS NOT NULL;
END

------------------------------------------------------------------------------
-- Work-order child record tables
------------------------------------------------------------------------------

-- MoldingRecords
IF OBJECT_ID('core.MoldingRecords','U') IS NULL
BEGIN
    CREATE TABLE core.MoldingRecords (
        MoldingRecordId   INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_MoldingRecords PRIMARY KEY CLUSTERED,
        WorkOrderId       INT NOT NULL,
        MoldDate          DATE NOT NULL,
        MoldShift         VARCHAR(100) NOT NULL,
        MoldOperator      VARCHAR(200) NOT NULL,
        PatternNo         VARCHAR(100) NULL,
        Alloy             VARCHAR(100) NULL,
        MoldNotes         LONGTEXT NULL,
        MoldingFinished   TINYINT(1) NOT NULL CONSTRAINT DF_core_MoldingRecords_MoldingFinished DEFAULT (0),
        CreatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_MoldingRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_MoldingRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_MoldingRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE
    );

    CREATE INDEX IX_core_MoldingRecords_WorkOrderId ON core.MoldingRecords(WorkOrderId);
    CREATE INDEX IX_core_MoldingRecords_MoldDate ON core.MoldingRecords(MoldDate);
END

-- PouringRecords
IF OBJECT_ID('core.PouringRecords','U') IS NULL
BEGIN
    CREATE TABLE core.PouringRecords (
        PouringRecordId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_PouringRecords PRIMARY KEY CLUSTERED,
        WorkOrderId     INT NOT NULL,
        PourDate        DATE NOT NULL,
        Alloy           VARCHAR(100) NULL,
        Notes           LONGTEXT NULL,
        CreatedAt       DATETIME(3) NOT NULL CONSTRAINT DF_core_PouringRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt       DATETIME(3) NOT NULL CONSTRAINT DF_core_PouringRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_PouringRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE
    );

    CREATE INDEX IX_core_PouringRecords_WorkOrderId ON core.PouringRecords(WorkOrderId);
    CREATE INDEX IX_core_PouringRecords_PourDate ON core.PouringRecords(PourDate);
END

-- HeatTreatRecords
IF OBJECT_ID('core.HeatTreatRecords','U') IS NULL
BEGIN
    CREATE TABLE core.HeatTreatRecords (
        HeatTreatRecordId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_HeatTreatRecords PRIMARY KEY CLUSTERED,
        WorkOrderId       INT NOT NULL,
        TreatDate         DATE NOT NULL,
        Temperature       DECIMAL(10,2) NULL,
        DurationHours     DECIMAL(10,2) NULL,
        Notes             LONGTEXT NULL,
        CreatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_HeatTreatRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_HeatTreatRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_HeatTreatRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE,

        CONSTRAINT CK_core_HeatTreatRecords_Duration_NonNegative CHECK (DurationHours IS NULL OR DurationHours >= 0),
        CONSTRAINT CK_core_HeatTreatRecords_Temp_Reasonable CHECK (Temperature IS NULL OR (Temperature >= -100 AND Temperature <= 4000))
    );

    CREATE INDEX IX_core_HeatTreatRecords_WorkOrderId ON core.HeatTreatRecords(WorkOrderId);
    CREATE INDEX IX_core_HeatTreatRecords_TreatDate ON core.HeatTreatRecords(TreatDate);
END

-- MachiningRecords
IF OBJECT_ID('core.MachiningRecords','U') IS NULL
BEGIN
    CREATE TABLE core.MachiningRecords (
        MachiningRecordId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_MachiningRecords PRIMARY KEY CLUSTERED,
        WorkOrderId       INT NOT NULL,
        MachineDate       DATETIME(3) NOT NULL,
        `Operator`        VARCHAR(100) NOT NULL,
        Notes             LONGTEXT NULL,
        CreatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_MachiningRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_MachiningRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_MachiningRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE
    );

    CREATE INDEX IX_core_MachiningRecords_WorkOrderId ON core.MachiningRecords(WorkOrderId);
    CREATE INDEX IX_core_MachiningRecords_MachineDate ON core.MachiningRecords(MachineDate);
END

-- AssemblyRecords
IF OBJECT_ID('core.AssemblyRecords','U') IS NULL
BEGIN
    CREATE TABLE core.AssemblyRecords (
        AssemblyRecordId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_AssemblyRecords PRIMARY KEY CLUSTERED,
        WorkOrderId      INT NOT NULL,
        AssemblyDate     DATETIME(3) NOT NULL,
        `Operator`       VARCHAR(100) NOT NULL,
        Notes            LONGTEXT NULL,
        CreatedAt        DATETIME(3) NOT NULL CONSTRAINT DF_core_AssemblyRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt        DATETIME(3) NOT NULL CONSTRAINT DF_core_AssemblyRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_AssemblyRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE
    );

    CREATE INDEX IX_core_AssemblyRecords_WorkOrderId ON core.AssemblyRecords(WorkOrderId);
    CREATE INDEX IX_core_AssemblyRecords_AssemblyDate ON core.AssemblyRecords(AssemblyDate);
END

-- ScrapRecords
IF OBJECT_ID('core.ScrapRecords','U') IS NULL
BEGIN
    CREATE TABLE core.ScrapRecords (
        ScrapRecordId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_ScrapRecords PRIMARY KEY CLUSTERED,
        WorkOrderId   INT NOT NULL,
        ScrapDate     DATETIME(3) NOT NULL,
        Reason        VARCHAR(100) NOT NULL,
        QtyScrapped   INT NOT NULL,
        CreatedAt     DATETIME(3) NOT NULL CONSTRAINT DF_core_ScrapRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt     DATETIME(3) NOT NULL CONSTRAINT DF_core_ScrapRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_ScrapRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE,

        CONSTRAINT CK_core_ScrapRecords_Qty_NonNegative CHECK (QtyScrapped >= 0),
        CONSTRAINT CK_core_ScrapRecords_Reason_NotBlank CHECK (LEN(LTRIM(RTRIM(Reason))) > 0)
    );

    CREATE INDEX IX_core_ScrapRecords_WorkOrderId ON core.ScrapRecords(WorkOrderId);
    CREATE INDEX IX_core_ScrapRecords_ScrapDate ON core.ScrapRecords(ScrapDate);
END

-- InspectionRecords
IF OBJECT_ID('core.InspectionRecords','U') IS NULL
BEGIN
    CREATE TABLE core.InspectionRecords (
        InspectionRecordId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_InspectionRecords PRIMARY KEY CLUSTERED,
        WorkOrderId        INT NOT NULL,
        InspectDate        DATETIME(3) NOT NULL,
        Inspector          VARCHAR(100) NOT NULL,
        Result             LONGTEXT NULL,
        CreatedAt          DATETIME(3) NOT NULL CONSTRAINT DF_core_InspectionRecords_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt          DATETIME(3) NOT NULL CONSTRAINT DF_core_InspectionRecords_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_InspectionRecords_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE,

        CONSTRAINT CK_core_InspectionRecords_Inspector_NotBlank CHECK (LEN(LTRIM(RTRIM(Inspector))) > 0)
    );

    CREATE INDEX IX_core_InspectionRecords_WorkOrderId ON core.InspectionRecords(WorkOrderId);
    CREATE INDEX IX_core_InspectionRecords_InspectDate ON core.InspectionRecords(InspectDate);
END

-- ChemistryResults
IF OBJECT_ID('core.ChemistryResults','U') IS NULL
BEGIN
    CREATE TABLE core.ChemistryResults (
        ChemistryResultId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_ChemistryResults PRIMARY KEY CLUSTERED,
        WorkOrderId       INT NOT NULL,
        HeatNumber        VARCHAR(100) NOT NULL,
        SampleNumber      VARCHAR(100) NOT NULL,
        DatePoured        DATETIME(3) NOT NULL,
        Furnace           VARCHAR(100) NULL,
        AlloyCode         VARCHAR(100) NULL,
        GrossWeight       DECIMAL(12,3) NULL,
        TapTemp           DECIMAL(10,2) NULL,
        C                DECIMAL(10,6) NULL,
        CreatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_ChemistryResults_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt         DATETIME(3) NOT NULL CONSTRAINT DF_core_ChemistryResults_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_ChemistryResults_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE,

        CONSTRAINT CK_core_ChemistryResults_HeatNumber_NotBlank CHECK (LEN(LTRIM(RTRIM(HeatNumber))) > 0),
        CONSTRAINT CK_core_ChemistryResults_SampleNumber_NotBlank CHECK (LEN(LTRIM(RTRIM(SampleNumber))) > 0),
        CONSTRAINT CK_core_ChemistryResults_C_Range CHECK (C IS NULL OR (C >= 0 AND C <= 10))
    );

    CREATE INDEX IX_core_ChemistryResults_WorkOrderId ON core.ChemistryResults(WorkOrderId);
    CREATE INDEX IX_core_ChemistryResults_DatePoured ON core.ChemistryResults(DatePoured);
END

-- AttachedFiles
IF OBJECT_ID('core.AttachedFiles','U') IS NULL
BEGIN
    CREATE TABLE core.AttachedFiles (
        AttachedFileId INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_AttachedFiles PRIMARY KEY CLUSTERED,
        WorkOrderId     INT NOT NULL,
        FileType        VARCHAR(100) NOT NULL,
        FileName        VARCHAR(255) NOT NULL,
        FilePath        VARCHAR(500) NOT NULL,
        AddDateTime     DATETIME(3) NOT NULL CONSTRAINT DF_core_AttachedFiles_AddDateTime DEFAULT SYSUTCDATETIME(),
        UploadedBy      VARCHAR(100) NOT NULL,
        Deleted         TINYINT(1) NOT NULL CONSTRAINT DF_core_AttachedFiles_Deleted DEFAULT (0),
        GridNumber      INT NULL,
        CreatedAt       DATETIME(3) NOT NULL CONSTRAINT DF_core_AttachedFiles_CreatedAt DEFAULT SYSUTCDATETIME(),
        UpdatedAt       DATETIME(3) NOT NULL CONSTRAINT DF_core_AttachedFiles_UpdatedAt DEFAULT SYSUTCDATETIME(),

        CONSTRAINT FK_core_AttachedFiles_WorkOrders
          FOREIGN KEY (WorkOrderId) REFERENCES core.WorkOrders(WorkOrderId) ON DELETE CASCADE,

        CONSTRAINT CK_core_AttachedFiles_FileName_NotBlank CHECK (LEN(LTRIM(RTRIM(FileName))) > 0),
        CONSTRAINT CK_core_AttachedFiles_FilePath_NotBlank CHECK (LEN(LTRIM(RTRIM(FilePath))) > 0)
    );

    CREATE INDEX IX_core_AttachedFiles_WorkOrderId ON core.AttachedFiles(WorkOrderId);
    CREATE INDEX IX_core_AttachedFiles_Deleted ON core.AttachedFiles(Deleted) INCLUDE (WorkOrderId);
END

-- AuditLogs
IF OBJECT_ID('core.AuditLogs','U') IS NULL
BEGIN
    CREATE TABLE core.AuditLogs (
        AuditLogId  INT AUTO_INCREMENT NOT NULL CONSTRAINT PK_core_AuditLogs PRIMARY KEY CLUSTERED,
        UserId      INT NOT NULL,
        `Action`    VARCHAR(400) NOT NULL,
        TableName   VARCHAR(100) NOT NULL,
        RecordId    INT NULL,
        `Timestamp` DATETIME(3) NOT NULL CONSTRAINT DF_core_AuditLogs_Timestamp DEFAULT SYSUTCDATETIME(),
        Notes       LONGTEXT NULL,

        CONSTRAINT FK_core_AuditLogs_Users
          FOREIGN KEY (UserId) REFERENCES core.Users(UserId)
    );

    CREATE INDEX IX_core_AuditLogs_UserId ON core.AuditLogs(UserId);
    CREATE INDEX IX_core_AuditLogs_Timestamp ON core.AuditLogs(`Timestamp`);
    CREATE INDEX IX_core_AuditLogs_TableName_RecordId ON core.AuditLogs(TableName, RecordId);
END

------------------------------------------------------------------------------
-- UPDATEDAT TRIGGERS (Strict + consistent)
------------------------------------------------------------------------------

DECLARE @tbl SYSNAME;

-- Helper: create an UpdatedAt trigger if column exists.
-- (Executed per-table to keep the script sqlcmd/SSMS friendly.)

-- core.Parts
IF OBJECT_ID('core.trg_Parts_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_Parts_UpdatedAt ON core.Parts
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.Parts t
    INNER JOIN inserted i ON i.PartId = t.PartId;
END
');

-- core.Customers
IF OBJECT_ID('core.trg_Customers_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_Customers_UpdatedAt ON core.Customers
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.Customers t
    INNER JOIN inserted i ON i.CustomerId = t.CustomerId;
END
');

-- core.Departments
IF OBJECT_ID('core.trg_Departments_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_Departments_UpdatedAt ON core.Departments
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.Departments t
    INNER JOIN inserted i ON i.DepartmentId = t.DepartmentId;
END
');

-- core.Users
IF OBJECT_ID('core.trg_Users_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_Users_UpdatedAt ON core.Users
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.Users t
    INNER JOIN inserted i ON i.UserId = t.UserId;
END
');

-- core.WorkOrders
IF OBJECT_ID('core.trg_WorkOrders_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_WorkOrders_UpdatedAt ON core.WorkOrders
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.WorkOrders t
    INNER JOIN inserted i ON i.WorkOrderId = t.WorkOrderId;
END
');

-- Child tables
IF OBJECT_ID('core.trg_MoldingRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_MoldingRecords_UpdatedAt ON core.MoldingRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.MoldingRecords t
    INNER JOIN inserted i ON i.MoldingRecordId = t.MoldingRecordId;
END
');

IF OBJECT_ID('core.trg_PouringRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_PouringRecords_UpdatedAt ON core.PouringRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.PouringRecords t
    INNER JOIN inserted i ON i.PouringRecordId = t.PouringRecordId;
END
');

IF OBJECT_ID('core.trg_HeatTreatRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_HeatTreatRecords_UpdatedAt ON core.HeatTreatRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.HeatTreatRecords t
    INNER JOIN inserted i ON i.HeatTreatRecordId = t.HeatTreatRecordId;
END
');

IF OBJECT_ID('core.trg_MachiningRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_MachiningRecords_UpdatedAt ON core.MachiningRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.MachiningRecords t
    INNER JOIN inserted i ON i.MachiningRecordId = t.MachiningRecordId;
END
');

IF OBJECT_ID('core.trg_AssemblyRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_AssemblyRecords_UpdatedAt ON core.AssemblyRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.AssemblyRecords t
    INNER JOIN inserted i ON i.AssemblyRecordId = t.AssemblyRecordId;
END
');

IF OBJECT_ID('core.trg_ScrapRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_ScrapRecords_UpdatedAt ON core.ScrapRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.ScrapRecords t
    INNER JOIN inserted i ON i.ScrapRecordId = t.ScrapRecordId;
END
');

IF OBJECT_ID('core.trg_InspectionRecords_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_InspectionRecords_UpdatedAt ON core.InspectionRecords
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.InspectionRecords t
    INNER JOIN inserted i ON i.InspectionRecordId = t.InspectionRecordId;
END
');

IF OBJECT_ID('core.trg_ChemistryResults_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_ChemistryResults_UpdatedAt ON core.ChemistryResults
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.ChemistryResults t
    INNER JOIN inserted i ON i.ChemistryResultId = t.ChemistryResultId;
END
');

IF OBJECT_ID('core.trg_AttachedFiles_UpdatedAt','TR') IS NULL
EXEC('
CREATE TRIGGER core.trg_AttachedFiles_UpdatedAt ON core.AttachedFiles
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    UPDATE t SET UpdatedAt = SYSUTCDATETIME()
    FROM core.AttachedFiles t
    INNER JOIN inserted i ON i.AttachedFileId = t.AttachedFileId;
END
');

------------------------------------------------------------------------------
-- REPORTING VIEWS (Normalized names; no spaces; consistent snake_case)
------------------------------------------------------------------------------

-- Work Orders (read model)
IF OBJECT_ID('rpt.vw_work_orders','V') IS NULL
EXEC('
CREATE VIEW rpt.vw_work_orders AS
SELECT
    wo.WorkOrderId          AS work_order_id,
    wo.WorkOrderNo          AS work_order_no,
    wo.PartId               AS part_id,
    p.PartNumber            AS part_number,
    p.`Description`         AS part_description,
    wo.CustomerId           AS customer_id,
    c.`Name`                AS customer_name,
    c.`Location`            AS customer_location,
    wo.AlloyCode            AS alloy_code,
    wo.QtyRequired          AS qty_required,
    wo.RushDueDate          AS rush_due_date,
    wo.SerialNo             AS serial_no,
    wo.AssemblyFinished     AS assembly_finished,
    wo.FinalInspectionComplete AS final_inspection_complete,
    wo.HeatTreatRequired    AS heat_treat_required,
    wo.JobComplete          AS job_complete,
    wo.`Status`             AS status,
    wo.CreatedAt            AS created_at,
    wo.UpdatedAt            AS updated_at
FROM core.WorkOrders wo
JOIN core.Parts p ON p.PartId = wo.PartId
JOIN core.Customers c ON c.CustomerId = wo.CustomerId;
');

-- Attached files
IF OBJECT_ID('rpt.vw_attached_files','V') IS NULL
EXEC('
CREATE VIEW rpt.vw_attached_files AS
SELECT
    af.AttachedFileId   AS attached_file_id,
    af.WorkOrderId      AS work_order_id,
    af.FileType         AS file_type,
    af.FileName         AS file_name,
    af.FilePath         AS file_path,
    af.AddDateTime      AS add_datetime,
    af.UploadedBy       AS uploaded_by,
    af.Deleted          AS deleted,
    af.GridNumber       AS grid_number,
    af.CreatedAt        AS created_at,
    af.UpdatedAt        AS updated_at
FROM core.AttachedFiles af;
');

-- Audit logs
IF OBJECT_ID('rpt.vw_audit_logs','V') IS NULL
EXEC('
CREATE VIEW rpt.vw_audit_logs AS
SELECT
    al.AuditLogId   AS audit_log_id,
    al.UserId       AS user_id,
    u.Username      AS username,
    al.`Action`     AS action,
    al.TableName    AS table_name,
    al.RecordId     AS record_id,
    al.`Timestamp`  AS `timestamp`,
    al.Notes        AS notes
FROM core.AuditLogs al
JOIN core.Users u ON u.UserId = al.UserId;
');

-- =========================================================
-- END townley_core_schema_strict.sql
-- =========================================================


-- =========================================================
-- BEGIN townley_core_compat_migration.sql
-- =========================================================
/*
Townley Platform - Compatibility + Incremental Migration Layer
-------------------------------------------------------------
Purpose:
- Map existing legacy dbo.* tables/columns into the new strict core.* model
- Support incremental migration without breaking the app

Assumptions:
- You have already deployed: townley_core_schema_strict.sql (creates core.* and rpt.*)
- Legacy tables exist under dbo.* (from Townleyfulldatabaseschema_portable.sql or similar)

This script is NON-DESTRUCTIVE:
- It does not DROP legacy objects
- It only creates schemas/views/stage mapping tables and migration stored procedures
*/

SET NOCOUNT ON;


IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'legacy') EXEC('CREATE SCHEMA legacy AUTHORIZATION dbo;');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stage')  EXEC('CREATE SCHEMA stage  AUTHORIZATION dbo;');


-- Stage mapping tables: legacy natural keys -> new core surrogate keys
IF OBJECT_ID('stage.PartMap','U') IS NULL
BEGIN
  CREATE TABLE stage.PartMap(
    LegacyPartNo VARCHAR(50) NOT NULL,
    PartId int NOT NULL,
    MigratedAt DATETIME(3) NOT NULL CONSTRAINT DF_stage_PartMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_PartMap PRIMARY KEY CLUSTERED (LegacyPartNo),
    CONSTRAINT UQ_stage_PartMap_PartId UNIQUE (PartId)
  );
END;

IF OBJECT_ID('stage.CustomerMap','U') IS NULL
BEGIN
  CREATE TABLE stage.CustomerMap(
    LegacyCustomerNumber VARCHAR(50) NOT NULL,
    CustomerId int NOT NULL,
    MigratedAt DATETIME(3) NOT NULL CONSTRAINT DF_stage_CustomerMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_CustomerMap PRIMARY KEY CLUSTERED (LegacyCustomerNumber),
    CONSTRAINT UQ_stage_CustomerMap_CustomerId UNIQUE (CustomerId)
  );
END;

IF OBJECT_ID('stage.UserMap','U') IS NULL
BEGIN
  CREATE TABLE stage.UserMap(
    LegacyUserId int NOT NULL,
    UserId int NOT NULL,
    MigratedAt DATETIME(3) NOT NULL CONSTRAINT DF_stage_UserMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_UserMap PRIMARY KEY CLUSTERED (LegacyUserId),
    CONSTRAINT UQ_stage_UserMap_UserId UNIQUE (UserId)
  );
END;

IF OBJECT_ID('stage.WorkOrderMap','U') IS NULL
BEGIN
  CREATE TABLE stage.WorkOrderMap(
    LegacyRecordNo int NOT NULL,
    WorkOrderId int NOT NULL,
    MigratedAt DATETIME(3) NOT NULL CONSTRAINT DF_stage_WorkOrderMap_MigratedAt DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_stage_WorkOrderMap PRIMARY KEY CLUSTERED (LegacyRecordNo),
    CONSTRAINT UQ_stage_WorkOrderMap_WorkOrderId UNIQUE (WorkOrderId)
  );
END;


/* ---------------------------
   LEGACY -> CORE SOURCE VIEWS
   --------------------------- */

-- Parts
CREATE OR ALTER VIEW legacy.vw_parts_source AS
SELECT
  p.PartNo        AS legacy_part_no,
  LTRIM(RTRIM(p.PartNo)) AS part_number,
  NULLIF(LTRIM(RTRIM(p.PartDescription)), '') AS description,
  NULLIF(LTRIM(RTRIM(p.Alloy)), '') AS alloy
FROM dbo.Parts p
WHERE NULLIF(LTRIM(RTRIM(p.PartNo)), '') IS NOT NULL;

-- Customers
CREATE OR ALTER VIEW legacy.vw_customers_source AS
SELECT
  c.CustomerNumber AS legacy_customer_number,
  NULLIF(LTRIM(RTRIM(c.CustomerName)), '') AS name
FROM dbo.Customers c
WHERE NULLIF(LTRIM(RTRIM(c.CustomerNumber)), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(c.CustomerName)), '') IS NOT NULL;

-- Users (legacy table is dbo.users)
CREATE OR ALTER VIEW legacy.vw_users_source AS
SELECT
  u.id AS legacy_user_id,
  NULLIF(LTRIM(RTRIM(u.username)), '') AS username,
  NULLIF(LTRIM(RTRIM(u.hashed_password)), '') AS hashed_password,
  NULLIF(LTRIM(RTRIM(u.role)), '') AS role,
  COALESCE(TRY_CONVERT(DATETIME(3), u.created_at), SYSUTCDATETIME()) AS created_at
FROM dbo.`users` u
WHERE NULLIF(LTRIM(RTRIM(u.username)), '') IS NOT NULL;

-- WorkOrders
CREATE OR ALTER VIEW legacy.vw_workorders_source AS
SELECT
  wo.RecordNo      AS legacy_record_no,
  NULLIF(LTRIM(RTRIM(wo.WorkOrderNo)), '') AS work_order_no,
  NULLIF(LTRIM(RTRIM(wo.PartNo)), '')      AS legacy_part_no,
  NULLIF(LTRIM(RTRIM(wo.CustomerName)), '') AS customer_name,
  NULLIF(LTRIM(RTRIM(wo.AlloyCode)), '') AS alloy_code,
  TRY_CONVERT(int, wo.QtyRequired) AS qty_required,
  TRY_CONVERT(date, wo.RushDueDate) AS rush_due_date,
  NULLIF(LTRIM(RTRIM(wo.SerialNo)), '') AS serial_no,
  ISNULL(wo.AssemblyFinished, 0) AS assembly_finished,
  ISNULL(wo.FinalInspComp, 0) AS final_inspection_complete,
  -- Legacy had HeatTreatFinished; strict core expects "HeatTreatRequired"
  ISNULL(wo.HeatTreatFinished, 0) AS heat_treat_required,
  CASE
    WHEN ISNULL(wo.FinalInspComp,0) = 1 THEN 1
    WHEN UPPER(LTRIM(RTRIM(ISNULL(wo.Status,'')))) IN ('COMPLETE','COMPLETED','DONE','CLOSED') THEN 1
    ELSE 0
  END AS job_complete,
  NULLIF(LTRIM(RTRIM(wo.Status)), '') AS status
FROM dbo.WorkOrders wo
WHERE NULLIF(LTRIM(RTRIM(wo.WorkOrderNo)), '') IS NOT NULL;

-- MoldingRecords (links by WorkOrderNo)
CREATE OR ALTER VIEW legacy.vw_moldingrecords_source AS
SELECT
  mr.RecordNo AS legacy_record_no,
  NULLIF(LTRIM(RTRIM(mr.WorkOrderNo)), '') AS work_order_no,
  TRY_CONVERT(date, mr.MoldDate) AS mold_date,
  NULLIF(LTRIM(RTRIM(mr.MoldShift)), '') AS mold_shift,
  NULLIF(LTRIM(RTRIM(mr.MoldOperator)), '') AS mold_operator,
  NULLIF(LTRIM(RTRIM(mr.PatternNo)), '') AS pattern_no,
  NULLIF(LTRIM(RTRIM(mr.Alloy)), '') AS alloy,
  NULLIF(LTRIM(RTRIM(mr.MoldNotes)), '') AS mold_notes,
  ISNULL(mr.MoldingFinished, 0) AS molding_finished,
  COALESCE(TRY_CONVERT(DATETIME(3), mr.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(DATETIME(3), mr.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.MoldingRecords mr
WHERE NULLIF(LTRIM(RTRIM(mr.WorkOrderNo)), '') IS NOT NULL;

-- PouringRecords (already has WorkOrderId in legacy)
CREATE OR ALTER VIEW legacy.vw_pouringrecords_source AS
SELECT
  pr.Id AS legacy_pouring_id,
  pr.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, pr.PourDate) AS pour_date,
  NULLIF(LTRIM(RTRIM(pr.Alloy)), '') AS alloy,
  NULLIF(LTRIM(RTRIM(pr.Notes)), '') AS notes,
  COALESCE(TRY_CONVERT(DATETIME(3), pr.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(DATETIME(3), pr.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.PouringRecords pr
WHERE pr.WorkOrderId IS NOT NULL;

-- HeatTreatRecords (legacy already keyed by WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_heattreatrecords_source AS
SELECT
  -- legacy doesn't have its own identity id; we'll migrate as one row per (WorkOrderId, TreatDate, Temperature, DurationHours)
  htr.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, htr.TreatDate) AS treat_date,
  TRY_CONVERT(int, htr.Temperature) AS temperature,
  TRY_CONVERT(decimal(10,2), htr.DurationHours) AS duration_hours,
  NULLIF(LTRIM(RTRIM(htr.Notes)), '') AS notes,
  SYSUTCDATETIME() AS created_at,
  SYSUTCDATETIME() AS updated_at
FROM dbo.HeatTreatRecords htr
WHERE htr.WorkOrderId IS NOT NULL;

-- MachiningRecords (legacy MachineTime uses a DOUBLE "Record" that usually corresponds to WorkOrders.RecordNo)
CREATE OR ALTER VIEW legacy.vw_machiningrecords_source AS
SELECT
  TRY_CONVERT(int, mt.Record) AS legacy_record_no,
  TRY_CONVERT(date, mt.MachineDate) AS machine_date,
  NULLIF(LTRIM(RTRIM(CAST(mt.ID AS VARCHAR(50)))), '') AS operator,
  NULLIF(LTRIM(RTRIM(mt.MachineNotes)), '') AS notes,
  COALESCE(TRY_CONVERT(DATETIME(3), mt.MachineDate), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(DATETIME(3), mt.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.MachineTime mt
WHERE TRY_CONVERT(int, mt.Record) IS NOT NULL;

-- AssemblyRecords (legacy already has WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_assemblyrecords_source AS
SELECT
  ar.Id AS legacy_assembly_id,
  ar.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, ar.AssemblyDate) AS assembly_date,
  NULLIF(LTRIM(RTRIM(ar.Assembler)), '') AS operator,
  NULLIF(LTRIM(RTRIM(ar.AssemblyNotes)), '') AS notes,
  COALESCE(TRY_CONVERT(DATETIME(3), ar.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(DATETIME(3), ar.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.AssemblyRecords ar
WHERE ar.WorkOrderId IS NOT NULL;

-- ScrapRecords (legacy already has WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_scraprecords_source AS
SELECT
  sr.Id AS legacy_scrap_id,
  sr.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, sr.ScrapDate) AS scrap_date,
  NULLIF(LTRIM(RTRIM(sr.ScrapReason)), '') AS reason,
  TRY_CONVERT(int, sr.ScrapQty) AS qty_scrapped,
  COALESCE(TRY_CONVERT(DATETIME(3), sr.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(DATETIME(3), sr.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.ScrapRecords sr
WHERE sr.WorkOrderId IS NOT NULL;

-- InspectionRecords (legacy already has WorkOrderId)
CREATE OR ALTER VIEW legacy.vw_inspectionrecords_source AS
SELECT
  ir.Id AS legacy_inspection_id,
  ir.WorkOrderId AS legacy_workorder_id,
  TRY_CONVERT(date, ir.InspectionDate) AS inspect_date,
  NULLIF(LTRIM(RTRIM(ir.Inspector)), '') AS inspector,
  CASE WHEN ISNULL(ir.Pass,0)=1 THEN 'PASS' ELSE 'FAIL' END AS result,
  COALESCE(TRY_CONVERT(DATETIME(3), ir.CreatedAt), SYSUTCDATETIME()) AS created_at,
  COALESCE(TRY_CONVERT(DATETIME(3), ir.UpdatedAt), SYSUTCDATETIME()) AS updated_at
FROM dbo.InspectionRecords ir
WHERE ir.WorkOrderId IS NOT NULL;

-- ChemistryResults (legacy uses snake_case columns; mostly compatible)
CREATE OR ALTER VIEW legacy.vw_chemistryresults_source AS
SELECT
  cr.id AS legacy_chem_id,
  cr.work_order_id AS legacy_workorder_id,
  TRY_CONVERT(int, cr.heat_number) AS heat_number,
  TRY_CONVERT(int, cr.sample_number) AS sample_number,
  TRY_CONVERT(date, cr.date_poured) AS date_poured,
  NULLIF(LTRIM(RTRIM(cr.furnace)), '') AS furnace,
  NULLIF(LTRIM(RTRIM(cr.alloy_code)), '') AS alloy_code,
  TRY_CONVERT(decimal(12,3), cr.gross_weight) AS gross_weight,
  TRY_CONVERT(decimal(12,3), cr.tap_temp) AS tap_temp,
  TRY_CONVERT(decimal(12,6), cr.C) AS C,
  COALESCE(TRY_CONVERT(DATETIME(3), cr.created_at), SYSUTCDATETIME()) AS created_at,
  SYSUTCDATETIME() AS updated_at
FROM dbo.ChemistryResults cr
WHERE cr.work_order_id IS NOT NULL;

-- Attachedfiles (legacy ties to MainScrapTbl; we'll map to WorkOrders via WorkorderNo)
CREATE OR ALTER VIEW legacy.vw_attachedfiles_source AS
SELECT
  af.ID AS legacy_attached_id,
  ms.WorkorderNo AS legacy_workorder_no,
  NULLIF(LTRIM(RTRIM(af.FileType)), '') AS file_type,
  NULLIF(LTRIM(RTRIM(af.FileName)), '') AS file_name,
  NULLIF(LTRIM(RTRIM(af.FilePath)), '') AS file_path,
  TRY_CONVERT(DATETIME(3), af.AddDateTime) AS add_datetime,
  NULLIF(LTRIM(RTRIM(af.Username)), '') AS uploaded_by,
  ISNULL(af.Deleted, 0) AS deleted,
  NULLIF(LTRIM(RTRIM(af.GridNumber)), '') AS grid_number
FROM dbo.Attachedfiles af
LEFT JOIN dbo.MainScrapTbl ms ON ms.ID = af.MainScrapTblID
WHERE NULLIF(LTRIM(RTRIM(af.FileName)), '') IS NOT NULL;

-- AuditLogs
CREATE OR ALTER VIEW legacy.vw_auditlogs_source AS
SELECT
  al.Id AS legacy_audit_id,
  al.UserId AS legacy_user_id,
  NULLIF(LTRIM(RTRIM(al.Action)), '') AS action,
  NULLIF(LTRIM(RTRIM(al.Resource)), '') AS table_name,
  TRY_CONVERT(int, NULL) AS record_id,
  COALESCE(TRY_CONVERT(DATETIME(3), al.Timestamp), SYSUTCDATETIME()) AS `timestamp`,
  NULLIF(LTRIM(RTRIM(al.Details)), '') AS notes
FROM dbo.AuditLogs al;


/* ---------------------------
   MIGRATION STORED PROCEDURES
   --------------------------- */

-- Parts
CREATE OR ALTER PROCEDURE core.sp_migrate_parts
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize)
      legacy_part_no,
      part_number,
      description,
      alloy
    FROM legacy.vw_parts_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.PartMap m WHERE m.LegacyPartNo = s.legacy_part_no)
    ORDER BY legacy_part_no
  )
  MERGE core.Parts AS tgt
  USING src
    ON tgt.PartNumber = src.part_number
  WHEN MATCHED THEN
    UPDATE SET
      tgt.Description = COALESCE(src.description, tgt.Description),
      tgt.Alloy       = COALESCE(src.alloy, tgt.Alloy),
      tgt.UpdatedAt   = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (PartNumber, Description, Alloy, CreatedAt, UpdatedAt)
    VALUES (src.part_number, COALESCE(src.description,''), src.alloy, SYSUTCDATETIME(), SYSUTCDATETIME())
  OUTPUT
    src.legacy_part_no,
    inserted.PartId
  INTO stage.PartMap(LegacyPartNo, PartId);
END;

-- Customers
CREATE OR ALTER PROCEDURE core.sp_migrate_customers
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize)
      legacy_customer_number,
      name
    FROM legacy.vw_customers_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.CustomerMap m WHERE m.LegacyCustomerNumber = s.legacy_customer_number)
    ORDER BY legacy_customer_number
  )
  MERGE core.Customers AS tgt
  USING src
    ON tgt.Name = src.name
  WHEN MATCHED THEN
    UPDATE SET tgt.UpdatedAt = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (Name, Location, CreatedAt, UpdatedAt)
    VALUES (src.name, NULL, SYSUTCDATETIME(), SYSUTCDATETIME())
  OUTPUT
    src.legacy_customer_number,
    inserted.CustomerId
  INTO stage.CustomerMap(LegacyCustomerNumber, CustomerId);
END;

-- Users
CREATE OR ALTER PROCEDURE core.sp_migrate_users
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize)
      legacy_user_id,
      username,
      hashed_password,
      role,
      created_at
    FROM legacy.vw_users_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.UserMap m WHERE m.LegacyUserId = s.legacy_user_id)
    ORDER BY legacy_user_id
  )
  MERGE core.Users AS tgt
  USING src
    ON tgt.Username = src.username
  WHEN MATCHED THEN
    UPDATE SET
      tgt.HashedPassword = COALESCE(src.hashed_password, tgt.HashedPassword),
      tgt.Role           = COALESCE(src.role, tgt.Role),
      tgt.UpdatedAt      = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (Username, HashedPassword, Role, CreatedAt, UpdatedAt)
    VALUES (src.username, src.hashed_password, COALESCE(src.role,'user'), src.created_at, SYSUTCDATETIME())
  OUTPUT
    src.legacy_user_id,
    inserted.UserId
  INTO stage.UserMap(LegacyUserId, UserId);
END;

-- WorkOrders (requires Parts + Customers migrated first)
CREATE OR ALTER PROCEDURE core.sp_migrate_workorders
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src_raw AS (
    SELECT TOP (@BatchSize)
      s.legacy_record_no,
      s.work_order_no,
      s.legacy_part_no,
      s.customer_name,
      s.alloy_code,
      s.qty_required,
      s.rush_due_date,
      s.serial_no,
      s.assembly_finished,
      s.final_inspection_complete,
      s.heat_treat_required,
      s.job_complete,
      s.status
    FROM legacy.vw_workorders_source s
    WHERE NOT EXISTS (SELECT 1 FROM stage.WorkOrderMap m WHERE m.LegacyRecordNo = s.legacy_record_no)
    ORDER BY s.legacy_record_no
  ),
  src AS (
    SELECT
      r.*,
      pm.PartId,
      cm.CustomerId
    FROM src_raw r
    LEFT JOIN stage.PartMap pm ON pm.LegacyPartNo = r.legacy_part_no
    LEFT JOIN dbo.Customers lc ON lc.CustomerName = r.customer_name
    LEFT JOIN stage.CustomerMap cm ON cm.LegacyCustomerNumber = lc.CustomerNumber
    WHERE pm.PartId IS NOT NULL AND cm.CustomerId IS NOT NULL
  )
  MERGE core.WorkOrders AS tgt
  USING src
    ON tgt.WorkOrderNo = src.work_order_no
  WHEN MATCHED THEN
    UPDATE SET
      tgt.PartId = src.PartId,
      tgt.CustomerId = src.CustomerId,
      tgt.AlloyCode = COALESCE(src.alloy_code, tgt.AlloyCode),
      tgt.QtyRequired = COALESCE(src.qty_required, tgt.QtyRequired),
      tgt.RushDueDate = COALESCE(src.rush_due_date, tgt.RushDueDate),
      tgt.SerialNo = COALESCE(src.serial_no, tgt.SerialNo),
      tgt.AssemblyFinished = src.assembly_finished,
      tgt.FinalInspectionComplete = src.final_inspection_complete,
      tgt.HeatTreatRequired = src.heat_treat_required,
      tgt.JobComplete = src.job_complete,
      tgt.Status = COALESCE(src.status, tgt.Status),
      tgt.UpdatedAt = SYSUTCDATETIME()
  WHEN NOT MATCHED THEN
    INSERT (WorkOrderNo, PartId, CustomerId, AlloyCode, QtyRequired, RushDueDate, SerialNo,
            AssemblyFinished, FinalInspectionComplete, HeatTreatRequired, JobComplete, Status,
            CreatedAt, UpdatedAt)
    VALUES (src.work_order_no, src.PartId, src.CustomerId, src.alloy_code,
            COALESCE(src.qty_required, 0), src.rush_due_date, src.serial_no,
            src.assembly_finished, src.final_inspection_complete, src.heat_treat_required, src.job_complete,
            COALESCE(src.status,'active'),
            SYSUTCDATETIME(), SYSUTCDATETIME())
  OUTPUT
    src.legacy_record_no,
    inserted.WorkOrderId
  INTO stage.WorkOrderMap(LegacyRecordNo, WorkOrderId);
END;

-- MoldingRecords (requires WorkOrders migrated)
CREATE OR ALTER PROCEDURE core.sp_migrate_moldingrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src_raw AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_moldingrecords_source
    ORDER BY legacy_record_no
  ),
  src AS (
    SELECT
      r.*,
      wom.WorkOrderId
    FROM src_raw r
    INNER JOIN core.WorkOrders wo ON wo.WorkOrderNo = r.work_order_no
    INNER JOIN stage.WorkOrderMap wom ON wom.WorkOrderId = wo.WorkOrderId
  )
  INSERT INTO core.MoldingRecords
    (WorkOrderId, MoldDate, MoldShift, MoldOperator, PatternNo, Alloy, MoldNotes, MoldingFinished, CreatedAt, UpdatedAt)
  SELECT
    s.WorkOrderId, s.mold_date, s.mold_shift, s.mold_operator, s.pattern_no, s.alloy, s.mold_notes, s.molding_finished, s.created_at, s.updated_at
  FROM src s
  WHERE NOT EXISTS (
    SELECT 1 FROM core.MoldingRecords x
    WHERE x.WorkOrderId = s.WorkOrderId AND x.MoldDate = s.mold_date AND ISNULL(x.PatternNo,'') = ISNULL(s.pattern_no,'')
  );
END;

-- PouringRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_pouringrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_pouringrecords_source
    ORDER BY legacy_pouring_id
  )
  INSERT INTO core.PouringRecords (WorkOrderId, PourDate, Alloy, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.pour_date,
    s.alloy,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.PouringRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.PourDate = s.pour_date AND ISNULL(x.Alloy,'')=ISNULL(s.alloy,'')
  );
END;

-- HeatTreatRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_heattreatrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_heattreatrecords_source
    ORDER BY legacy_workorder_id
  )
  INSERT INTO core.HeatTreatRecords (WorkOrderId, TreatDate, Temperature, DurationHours, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.treat_date,
    s.temperature,
    s.duration_hours,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.HeatTreatRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.TreatDate = s.treat_date AND ISNULL(x.Temperature,0)=ISNULL(s.temperature,0)
  );
END;

-- MachiningRecords (best-effort; requires MachineTime.Record -> legacy WorkOrders.RecordNo mapping)
CREATE OR ALTER PROCEDURE core.sp_migrate_machiningrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_machiningrecords_source
    ORDER BY legacy_record_no
  )
  INSERT INTO core.MachiningRecords (WorkOrderId, MachineDate, Operator, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.machine_date,
    s.operator,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_record_no
  WHERE NOT EXISTS (
    SELECT 1 FROM core.MachiningRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.MachineDate = s.machine_date AND ISNULL(x.Operator,'')=ISNULL(s.operator,'')
  );
END;

-- AssemblyRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_assemblyrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_assemblyrecords_source
    ORDER BY legacy_assembly_id
  )
  INSERT INTO core.AssemblyRecords (WorkOrderId, AssemblyDate, Operator, Notes, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.assembly_date,
    s.operator,
    s.notes,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.AssemblyRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.AssemblyDate = s.assembly_date AND ISNULL(x.Operator,'')=ISNULL(s.operator,'')
  );
END;

-- ScrapRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_scraprecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_scraprecords_source
    ORDER BY legacy_scrap_id
  )
  INSERT INTO core.ScrapRecords (WorkOrderId, ScrapDate, Reason, QtyScrapped, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.scrap_date,
    s.reason,
    COALESCE(s.qty_scrapped, 0),
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.ScrapRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.ScrapDate = s.scrap_date AND ISNULL(x.Reason,'')=ISNULL(s.reason,'')
  );
END;

-- InspectionRecords
CREATE OR ALTER PROCEDURE core.sp_migrate_inspectionrecords
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_inspectionrecords_source
    ORDER BY legacy_inspection_id
  )
  INSERT INTO core.InspectionRecords (WorkOrderId, InspectDate, Inspector, Result, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.inspect_date,
    s.inspector,
    s.result,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.InspectionRecords x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.InspectDate = s.inspect_date AND ISNULL(x.Inspector,'')=ISNULL(s.inspector,'')
  );
END;

-- ChemistryResults
CREATE OR ALTER PROCEDURE core.sp_migrate_chemistryresults
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_chemistryresults_source
    ORDER BY legacy_chem_id
  )
  INSERT INTO core.ChemistryResults (WorkOrderId, HeatNumber, SampleNumber, DatePoured, Furnace, AlloyCode, GrossWeight, TapTemp, C, CreatedAt, UpdatedAt)
  SELECT
    wom.WorkOrderId,
    s.heat_number,
    s.sample_number,
    s.date_poured,
    s.furnace,
    s.alloy_code,
    s.gross_weight,
    s.tap_temp,
    s.C,
    s.created_at,
    s.updated_at
  FROM src s
  INNER JOIN stage.WorkOrderMap wom ON wom.LegacyRecordNo = s.legacy_workorder_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.ChemistryResults x
    WHERE x.WorkOrderId = wom.WorkOrderId AND x.HeatNumber = s.heat_number AND x.SampleNumber = s.sample_number
  );
END;

-- AttachedFiles (via MainScrapTbl -> WorkorderNo)
CREATE OR ALTER PROCEDURE core.sp_migrate_attachedfiles
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src_raw AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_attachedfiles_source
    ORDER BY legacy_attached_id
  ),
  src AS (
    SELECT
      r.*,
      wo.WorkOrderId
    FROM src_raw r
    INNER JOIN core.WorkOrders wo ON wo.WorkOrderNo = r.legacy_workorder_no
  )
  INSERT INTO core.AttachedFiles (WorkOrderId, FileType, FileName, FilePath, AddDateTime, UploadedBy, Deleted, GridNumber, CreatedAt, UpdatedAt)
  SELECT
    s.WorkOrderId,
    s.file_type,
    s.file_name,
    s.file_path,
    COALESCE(s.add_datetime, SYSUTCDATETIME()),
    s.uploaded_by,
    ISNULL(s.deleted,0),
    s.grid_number,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
  FROM src s
  WHERE NOT EXISTS (
    SELECT 1 FROM core.AttachedFiles x
    WHERE x.WorkOrderId = s.WorkOrderId AND x.FileName = s.file_name AND ISNULL(x.FilePath,'')=ISNULL(s.file_path,'')
  );
END;

-- AuditLogs
CREATE OR ALTER PROCEDURE core.sp_migrate_auditlogs
  @BatchSize int = 5000
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH src AS (
    SELECT TOP (@BatchSize) *
    FROM legacy.vw_auditlogs_source
    ORDER BY legacy_audit_id
  )
  INSERT INTO core.AuditLogs (UserId, Action, TableName, RecordId, `Timestamp`, Notes)
  SELECT
    COALESCE(um.UserId, 1) AS UserId, -- fallback to admin user id 1 if not mapped
    COALESCE(s.action,'unknown'),
    COALESCE(s.table_name,'unknown'),
    s.record_id,
    s.`timestamp`,
    s.notes
  FROM src s
  LEFT JOIN stage.UserMap um ON um.LegacyUserId = s.legacy_user_id
  WHERE NOT EXISTS (
    SELECT 1 FROM core.AuditLogs x
    WHERE x.`Timestamp`=s.`timestamp` AND x.Action=COALESCE(s.action,'unknown') AND x.TableName=COALESCE(s.table_name,'unknown')
  );
END;

-- Convenience: run in safe dependency order
CREATE OR ALTER PROCEDURE core.sp_migrate_all
  @BatchSize int = 5000
AS
BEGIN
  EXEC core.sp_migrate_parts @BatchSize;
  EXEC core.sp_migrate_customers @BatchSize;
  EXEC core.sp_migrate_users @BatchSize;
  EXEC core.sp_migrate_workorders @BatchSize;

  EXEC core.sp_migrate_moldingrecords @BatchSize;
  EXEC core.sp_migrate_pouringrecords @BatchSize;
  EXEC core.sp_migrate_heattreatrecords @BatchSize;
  EXEC core.sp_migrate_machiningrecords @BatchSize;
  EXEC core.sp_migrate_assemblyrecords @BatchSize;
  EXEC core.sp_migrate_scraprecords @BatchSize;
  EXEC core.sp_migrate_inspectionrecords @BatchSize;
  EXEC core.sp_migrate_chemistryresults @BatchSize;
  EXEC core.sp_migrate_attachedfiles @BatchSize;
  EXEC core.sp_migrate_auditlogs @BatchSize;
END;

-- =========================================================
-- END townley_core_compat_migration.sql
-- =========================================================

-- =========================================================
-- END townley_deploy_only.sql
-- =========================================================


-- =========================================================
-- BEGIN townley_api_views_fastapi_exact.sql
-- =========================================================

-- =========================================================
-- Townley API Views (FastAPI-Exact Alignment)
-- Generated for strict core schema
-- =========================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'api')
BEGIN
    EXEC('CREATE SCHEMA api');
END

-- =========================================================
-- Audit API Views (audit.py)
-- =========================================================
CREATE OR ALTER VIEW api.vw_audit_entries AS
SELECT
    al.Id            AS id,
    al.RecordNo      AS record_no,
    al.Action        AS action,
    u.FullName       AS changed_by,
    al.CreatedAt     AS changed_at,
    al.Details       AS details
FROM core.AuditLogs al
LEFT JOIN core.Users u
    ON u.UserId = al.UserId;

-- =========================================================
-- Users API Views (auth.py)
-- =========================================================
CREATE OR ALTER VIEW api.vw_users AS
SELECT
    u.UserId      AS id,
    u.Email       AS email,
    u.FullName    AS full_name,
    u.IsActive    AS is_active
FROM core.Users u;

-- =========================================================
-- WorkOrders API Views (workorders.py)
-- =========================================================
CREATE OR ALTER VIEW api.vw_workorders AS
SELECT
    wo.WorkOrderNo   AS RecordNo,
    wo.Status        AS Status,
    wo.Description   AS Description,
    CONVERT(varchar(30), wo.CreatedAt, 126) AS CreatedAt
FROM core.WorkOrders wo;

-- =========================================================
-- END townley_api_views_fastapi_exact.sql
-- =========================================================


-- =========================================================
-- BEGIN townley_db_roles_and_permissions.sql
-- =========================================================
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

USE `Townley_MySQL`;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'townley_api_reader' AND type = 'R')
    CREATE ROLE townley_api_reader AUTHORIZATION dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'townley_core_writer' AND type = 'R')
    CREATE ROLE townley_core_writer AUTHORIZATION dbo;

GRANT SELECT ON SCHEMA::api TO townley_api_reader;

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::core TO townley_core_writer;

-- Defense in depth: make api.* read-only for broad principals by default.
DENY INSERT, UPDATE, DELETE ON SCHEMA::api TO PUBLIC;

-- Example bindings (uncomment + change user names):
-- EXEC sp_addrolemember 'townley_api_reader',  'your_db_user';
-- EXEC sp_addrolemember 'townley_core_writer','your_db_user';

-- =========================================================
-- END townley_db_roles_and_permissions.sql
-- =========================================================


-- =========================================================
-- BEGIN townley_api_view_guards.sql
-- =========================================================
-- =========================================================
-- Townley API View Guards (Optional but Strong)
-- Prevent any accidental writes to api.vw_* views
-- using INSTEAD OF triggers that raise an error.
--
-- Works alongside DENY permissions (defense in depth).
-- =========================================================

USE `Townley_MySQL`;
IF OBJECT_ID('api.tr_vw_users_readonly', 'TR') IS NOT NULL
    DROP TRIGGER api.tr_vw_users_readonly;

CREATE TRIGGER api.tr_vw_users_readonly
ON api.vw_users
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    RAISERROR('api.vw_users is read-only. Write to core.Users instead.', 16, 1);
    ROLLBACK TRANSACTION;
END

IF OBJECT_ID('api.tr_vw_audit_entries_readonly', 'TR') IS NOT NULL
    DROP TRIGGER api.tr_vw_audit_entries_readonly;

CREATE TRIGGER api.tr_vw_audit_entries_readonly
ON api.vw_audit_entries
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    RAISERROR('api.vw_audit_entries is read-only. Write to core.AuditLogs instead.', 16, 1);
    ROLLBACK TRANSACTION;
END

IF OBJECT_ID('api.tr_vw_workorders_readonly', 'TR') IS NOT NULL
    DROP TRIGGER api.tr_vw_workorders_readonly;

CREATE TRIGGER api.tr_vw_workorders_readonly
ON api.vw_workorders
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    RAISERROR('api.vw_workorders is read-only. Write to core.WorkOrders instead.', 16, 1);
    ROLLBACK TRANSACTION;
END

-- =========================================================
-- END townley_api_view_guards.sql
-- =========================================================
