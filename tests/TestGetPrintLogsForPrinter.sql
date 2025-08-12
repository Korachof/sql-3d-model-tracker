-- =============================================================
-- Test Script for dbo.GetPrintLogsForPrinter (with Pagination)
-- =============================================================

-- First, ensure we have a clean slate.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT;
DECLARE @PrinterID_Mars INT, @PrinterID_P1S INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample models and printers
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_P1S OUTPUT;

-- Log 5 prints for the 'P1S' printer to test pagination, and 1 for the 'Mars'
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'PLA A', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-08-02 14:00:00', @PrintEndDateTime='2025-08-02 15:30:00', @MaterialUsed=N'PLA B', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-07-20 08:00:00', @PrintEndDateTime='2025-07-20 18:00:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-08-05 09:00:00', @PrintEndDateTime='2025-08-05 09:20:00', @MaterialUsed=N'ABS', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-06-15 11:00:00', @PrintEndDateTime='2025-06-15 11:30:00', @MaterialUsed=N'PLA C', @PrintStatus=N'Cancelled', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-10 10:00:00', @PrintEndDateTime='2025-08-10 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

-- TEST 1: Default Behavior (Sort by StartDate DESC, Page 1) for a printer with history
-- Expected: 5 print logs for the 'P1S', sorted with the most recent first.
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = @PrinterID_P1S;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Sorting (Sort by ModelName ASC)
-- Expected: 5 print logs for the 'P1S', sorted alphabetically by model name.
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = @PrinterID_P1S, @SortBy = 'ModelID', @SortDirection = 'ASC';
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Pagination (Get Page 2, Size 2)
-- Expected: 2 logs for the 'P1S', sorted by start date DESC, showing the second page.
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = @PrinterID_P1S, @PageNumber = 2, @PageSize = 2;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 4: Get logs for a printer with no history
-- First, add a printer with no logs
DECLARE @PrinterID_NoLogs INT;
EXEC dbo.AddPrinter @PrinterBrand = N'Anycubic', @PrinterModelName = N'Kobra', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_NoLogs OUTPUT;
-- Expected: An empty result set and Return Status = 0.
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = @PrinterID_NoLogs;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 5: Not Found (PrinterID does not exist)
-- Expected: An empty result set and Return Status = 2.
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = 999;
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 6: Validation Failure (NULL PrinterID)
-- Expected: An empty result set and Return Status = 1.
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO

