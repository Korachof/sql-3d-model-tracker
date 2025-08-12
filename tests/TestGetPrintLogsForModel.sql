-- ===========================================================
-- Test Script for dbo.GetPrintLogsForModel (with Pagination)
-- ===========================================================

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
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample models and a printer
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;

-- Log 5 prints for the 'Benchy' model to test pagination
PRINT '--- Inserting test print logs... ---';
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin A', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-02 14:00:00', @PrintEndDateTime='2025-08-02 15:30:00', @MaterialUsed=N'Resin B', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-07-20 08:00:00', @PrintEndDateTime='2025-07-20 18:00:00', @MaterialUsed=N'Resin C', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-05 09:00:00', @PrintEndDateTime='2025-08-05 09:20:00', @MaterialUsed=N'Resin D', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-06-15 11:00:00', @PrintEndDateTime='2025-06-15 11:30:00', @MaterialUsed=N'Resin E', @PrintStatus=N'Cancelled', @PrintID=@PrintID OUTPUT;

-- TEST 1: Default Behavior (Sort by StartDate DESC, Page 1)
-- Expected: 5 print logs for 'Benchy', sorted with the most recent first.
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = @ModelID_Benchy;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Sorting (Sort by MaterialUsed ASC)
-- Expected: 5 print logs for 'Benchy', sorted alphabetically by material.
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = @ModelID_Benchy, @SortBy = 'MaterialUsed', @SortDirection = 'ASC';
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Pagination (Get Page 2, Size 2)
-- Expected: 2 logs, sorted by start date DESC, showing the second page.
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = @ModelID_Benchy, @PageNumber = 2, @PageSize = 2;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 4: Get logs for a model with no history (Calibration Cube)
-- Expected: An empty result set and Return Status = 0.
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = @ModelID_Cube;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 5: Not Found (ModelID does not exist)
-- Expected: An empty result set and Return Status = 2.
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = 999;
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 6: Validation Failure (NULL ModelID)
-- Expected: An empty result set and Return Status = 1.
EXEC @ReturnStatus = dbo.GetPrintLogsForModel @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO