-- =============================================
-- Test Script for dbo.GetPrintLogsForModel
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT;
DECLARE @PrinterID_Mars INT;
DECLARE @PrintID INT; -- To hold the output from RecordModelPrint
DECLARE @ReturnStatus INT;

-- Insert sample models and a printer
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;

-- Log two prints for the 'Benchy' model and one for the 'Cube'
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-02 14:00:00', @PrintEndDateTime='2025-08-02 15:30:00', @MaterialUsed=N'Resin', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Cube, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-03 09:00:00', @PrintEndDateTime='2025-08-03 09:20:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

---
PRINT '--- TEST 1: Get print logs for a model with a history ---';
-- Expected: A result set with 2 print logs for 'Benchy' and Return Status = 0
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = @ModelID_Benchy;
SELECT @ReturnStatus AS 'Return Status';

---
PRINT '--- TEST 2: Get print logs for a model with no history ---';
-- First, add a model with no logs
DECLARE @ModelID_NoLogs INT;
EXEC dbo.AddModel @ModelName = N'Empty Model', @SourceURL = N'http://c.com', @ModelID = @ModelID_NoLogs OUTPUT;
-- Expected: An empty result set and Return Status = 0
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = @ModelID_NoLogs;
SELECT @ReturnStatus AS 'Return Status';

---
PRINT '--- TEST 3: Not Found (ModelID does not exist) ---';
-- Expected: An empty result set and Return Status = 2
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

---
PRINT '--- TEST 4: Validation Failure (NULL ModelID) ---';
-- Expected: An empty result set and Return Status = 1
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO