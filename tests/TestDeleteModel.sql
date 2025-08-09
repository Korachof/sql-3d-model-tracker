-- =============================================
-- Test Script for dbo.DeleteModel
-- =============================================

-- First, ensure we have a clean slate and sample data.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT;
DECLARE @TagID_Boat INT, @TagID_Cal INT;
DECLARE @PrinterID_Mars INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
PRINT '--- Inserting initial test data... ---';
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddTag @TagName = N'Boat', @TagID = @TagID_Boat OUTPUT;
EXEC dbo.AddTag @TagName = N'Calibration', @TagID = @TagID_Cal OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;

-- Assign tags and log a print for the 'Benchy' model
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Boat;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

PRINT '--- Initial State ---';
SELECT * FROM dbo.Models;
SELECT * FROM dbo.ModelTags;
SELECT * FROM dbo.PrintLog;

---
PRINT '--- TEST 1: Successful Delete ---';
-- Expected: Return Status = 0. The 'Benchy' model and its related data are deleted.
EXEC @ReturnStatus = dbo.DeleteModel @ModelID = @ModelID_Benchy;
SELECT @ReturnStatus AS 'Return Status';

---
PRINT '--- TEST 2: Not Found (ModelID does not exist) ---';
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.DeleteModel @ModelID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

---
PRINT '--- TEST 3: Validation Failure (NULL ModelID) ---';
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.DeleteModel @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

---
PRINT '--- FINAL VERIFICATION: View all tables ---';
-- Expected:
-- dbo.Models: Only the 'Calibration Cube' should remain.
-- dbo.ModelTags: Should be empty.
-- dbo.PrintLog: Should be empty.
SELECT * FROM dbo.Models;
SELECT * FROM dbo.ModelTags;
SELECT * FROM dbo.PrintLog;
GO