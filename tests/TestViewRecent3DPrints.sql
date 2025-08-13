-- =============================================
-- Test Script for dbo.vw_RecentPrints
-- =============================================
-- First, ensure we have a clean slate and sample data.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Printers;
DELETE FROM dbo.Models;
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @PrinterID INT;
DECLARE @ModelID_1 INT, @ModelID_2 INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert a sample printer and two models
PRINT '--- Inserting initial test data... ---';
EXEC dbo.AddPrinter @PrinterBrand = N'TestBrand', @PrinterModelName = N'TestModel', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddModel @ModelName = N'TestModel A', @SourceURL = N'http://a.com', @ModelID = @ModelID_1 OUTPUT;
EXEC dbo.AddModel @ModelName = N'TestModel B', @SourceURL = N'http://b.com', @ModelID = @ModelID_2 OUTPUT;

-- Log 12 prints with different start dates, split between the two models
PRINT '--- Inserting 12 test print logs... ---';
EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-01', @PrintEndDateTime='2025-01-01 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-02', @PrintEndDateTime='2025-01-02 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-03', @PrintEndDateTime='2025-01-03 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-04', @PrintEndDateTime='2025-01-04 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-05', @PrintEndDateTime='2025-01-05 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-06', @PrintEndDateTime='2025-01-06 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-07', @PrintEndDateTime='2025-01-07 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-08', @PrintEndDateTime='2025-01-08 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-09', @PrintEndDateTime='2025-01-09 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-10', @PrintEndDateTime='2025-01-10 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-11', @PrintEndDateTime='2025-01-11 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID, @PrintStartDateTime='2025-01-12', @PrintEndDateTime='2025-01-12 01:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

---
PRINT '--- QUERYING THE dbo.vw_RecentPrints VIEW ---';
-- Expected: A result set with exactly 10 rows, showing the prints from Jan 3rd to Jan 12th.
SELECT * FROM dbo.vw_RecentPrints;
GO