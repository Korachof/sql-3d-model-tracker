/*
================================================================================
MASTER SETUP SCRIPT for 3D Model Print Tracker
================================================================================
INSTRUCTIONS:
1. Place this file in the root directory of your project.
2. In SSMS, go to the "Query" menu and select "SQLCMD Mode".
3. Connect to your SQL Server instance (the database should be 'master').
4. Open this file and click "Execute".

This script will create the database, tables, views, and all stored procedures.
================================================================================
*/

-- Use a command-line variable to set the database name, or default it.
:setvar DatabaseName "ThreeDModelsTrackerDB"

PRINT 'Beginning database setup for $(DatabaseName)...';
GO

-- Step 1: Create the database and all tables.
-- The CreateTables.sql script should handle the CREATE DATABASE and USE statements.
PRINT '--> Creating schema (database and tables)...';
:r .\schema\CreateTables.sql
PRINT '--> Schema creation complete.';
GO

-- Step 2: Create all stored procedures.
PRINT '--> Creating stored procedures...';

-- Add Procedures
:r .\procedures\AddModel.sql
:r .\procedures\AddTag.sql
:r .\procedures\AddPrinter.sql
:r .\procedures\AssignTagToModel.sql
:r .\procedures\RecordModelPrint.sql

-- Get Procedures
:r .\procedures\GetModels.sql
:r .\procedures\GetTags.sql
:r .\procedures\GetPrinters.sql
:r .\procedures\GetPrintLogs.sql
:r .\procedures\GetModelDetails.sql
:r .\procedures\GetModelsByTag.sql
:r .\procedures\GetTagsForModel.sql
:r .\procedures\GetPrintLogsForModel.sql
:r .\procedures\GetPrintLogsForPrinter.sql

-- Update Procedures
:r .\procedures\UpdateModel.sql
:r .\procedures\UpdateTag.sql
:r .\procedures\UpdatePrinter.sql
:r .\procedures\UpdatePrintLog.sql

-- Delete Procedures
:r .\procedures\DeleteModel.sql
:r .\procedures\DeleteTag.sql
:r .\procedures\DeletePrinter.sql
:r .\procedures\DeletePrintLog.sql
:r .\procedures\RemoveTagFromModel.sql

PRINT '--> Stored procedure creation complete.';
GO

-- Step 3: Create all views.
PRINT '--> Creating views...';
:r .\views\vw_PrinterPerformanceSummary.sql
:r .\views\vw_RecentPrints.sql
:r .\views\vw_TagUsageSummary.sql
:r .\views\vw_ModelPrintSummary.sql
:r .\views\vw_MaterialUsageSummary.sql
PRINT '--> View creation complete.';
GO

-- Step 4: Create utility scripts (like ResetDemoData)
PRINT '--> Creating utility scripts...';
:r .\scripts\ResetDemoData.sql
PRINT '--> Utility script creation complete.';
GO

PRINT '================================================';
PRINT 'DATABASE SETUP COMPLETE.';
PRINT '================================================';
GO