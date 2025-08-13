-- =============================================
-- Test Script for dbo.vw_ModelPrintSummary
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
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT, @ModelID_Empty INT;
DECLARE @PrinterID INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample models and a printer
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddModel @ModelName = N'Empty Model', @SourceURL = N'http://c.com', @ModelID = @ModelID_Empty OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'TestBrand', @PrinterModelName = N'TestModel', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;

-- Log several prints for each model to test the view's calculations
-- 3 prints for the Benchy (2 success, 1 failed)
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-02 10:00:00', @PrintEndDateTime='2025-08-02 11:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-03 10:00:00', @PrintEndDateTime='2025-08-03 13:00:00', @MaterialUsed=N'PLA', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

-- 2 prints for the Cube (1 success, 1 failed)
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Cube, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-04 14:00:00', @PrintEndDateTime='2025-08-04 14:30:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Cube, @PrinterID=@PrinterID, @PrintStartDateTime='2025-08-05 14:00:00', @PrintEndDateTime='2025-08-05 15:30:00', @MaterialUsed=N'PETG', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

-- QUERYING THE dbo.vw_ModelPrintSummary VIEW
-- Expected: Three rows, one for each model, with correctly calculated stats.
-- Benchy: Total=3, Success=2, Failed=1, AvgDuration=120 mins
-- Cube:   Total=2, Success=1, Failed=1, AvgDuration=60 mins
-- Empty:  Total=0, Success=0, Failed=0, AvgDuration=NULL
SELECT * FROM dbo.vw_ModelPrintSummary ORDER BY ModelID;
GO