-- =============================================
-- Test Script for dbo.GetPrintLogs (with Pagination)
-- =============================================
-- First, ensure we have a clean slate.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID INT;
DECLARE @PrinterID INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert a sample model and printer to test with
EXEC dbo.AddModel @ModelName = N'Test Model', @SourceURL = N'http://a.com', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Test Brand', @PrinterModelName = N'Test Model', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;

-- Insert 12 sample print logs to test with
PRINT '--- Inserting test print logs... ---';
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-10 10:00:00', @PrintEndDateTime='2025-01-10 12:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-02-15 11:00:00', @PrintEndDateTime='2025-02-15 13:00:00', @MaterialUsed=N'PETG', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-03-20 12:00:00', @PrintEndDateTime='2025-03-20 14:00:00', @MaterialUsed=N'ABS', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-04-01 13:00:00', @PrintEndDateTime='2025-04-01 15:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-05-05 14:00:00', @PrintEndDateTime='2025-05-05 16:00:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-06-10 15:00:00', @PrintEndDateTime='2025-06-10 17:00:00', @MaterialUsed=N'ABS', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-07-15 16:00:00', @PrintEndDateTime='2025-07-15 18:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-20 17:00:00', @PrintEndDateTime='2025-08-20 19:00:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-09-01 18:00:00', @PrintEndDateTime='2025-09-01 20:00:00', @MaterialUsed=N'ABS', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-10-10 19:00:00', @PrintEndDateTime='2025-10-10 21:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-11-15 20:00:00', @PrintEndDateTime='2025-11-15 22:00:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-12-20 21:00:00', @PrintEndDateTime='2025-12-20 23:00:00', @MaterialUsed=N'ABS', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

-- TEST 1: Default Behavior (Sort by StartDate DESC, Page 1, Size 50) ---';
-- Expected: All 12 logs, sorted with the most recent start date first.
EXEC dbo.GetPrintLogs;

-- TEST 2: Sorting (Sort by MaterialUsed ASC)
-- Expected: All 12 logs, sorted alphabetically by material.
EXEC dbo.GetPrintLogs @SortBy = 'MaterialUsed', @SortDirection = 'ASC';

---
-- TEST 3: Pagination (Get Page 2, Size 5)
-- Expected: 5 logs, sorted by start date DESC, starting from the June print.
EXEC dbo.GetPrintLogs @PageNumber = 2, @PageSize = 5;

-- TEST 4: Sorting and Pagination Combined
-- Expected: 4 logs, sorted by PrintStatus ASC, showing the third page.
EXEC dbo.GetPrintLogs @SortBy = 'PrintStatus', @SortDirection = 'ASC', @PageNumber = 3, @PageSize = 4;
GO