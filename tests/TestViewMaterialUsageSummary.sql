-- =============================================
-- Test Script for dbo.vw_MaterialUsageSummary
-- =============================================

-- First, ensure we have a clean slate and sample data.
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

-- Insert a sample model and printer
PRINT '--- Inserting initial test data... ---';
EXEC dbo.AddModel @ModelName = N'Test Model', @SourceURL = N'http://a.com', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'TestBrand', @PrinterModelName = N'TestModel', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;

-- Log several prints with different materials and statuses to test the view's calculations
-- PLA: 3 prints (2 success, 1 failed) -> 66.6% success rate
-- PETG: 2 prints (1 success, 1 failed) -> 50% success rate
-- ABS: 1 print (0 success, 1 failed) -> 0% success rate
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-01', @PrintEndDateTime='2025-08-01 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-02', @PrintEndDateTime='2025-08-02 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-03', @PrintEndDateTime='2025-08-03 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-04', @PrintEndDateTime='2025-08-04 01:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-05', @PrintEndDateTime='2025-08-05 01:00', @MaterialUsed=N'PETG', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

EXEC dbo.RecordModelPrint @ModelID=@ModelID, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-06', @PrintEndDateTime='2025-08-06 01:00', @MaterialUsed=N'ABS', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

---
PRINT '--- QUERYING THE dbo.vw_MaterialUsageSummary VIEW ---';
-- Expected: Three rows, one for each material, with correctly calculated stats.
SELECT * FROM dbo.vw_MaterialUsageSummary ORDER BY TotalPrints DESC;
GO