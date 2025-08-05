-- This script wipes all data from all tables but leaves the structure intact.

-- Step 1: Delete data from child tables first.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.ModelTags;
GO

-- Step 2: Delete data from parent tables.
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DELETE FROM dbo.Printers;
GO

-- Step 3: Reset the identity counters for all tables that have one.
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

PRINT 'All table data has been cleared and ID counters have been reset.';