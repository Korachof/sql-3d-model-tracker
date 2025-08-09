-- =============================================
-- Test Script for dbo.GetPrintLogs
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
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT;
DECLARE @PrinterID_Mars INT, @PrinterID_P1S INT;
DECLARE @PrintID INT; -- To hold the output from RecordModelPrint
DECLARE @ReturnStatus INT;

-- Insert sample models and printers
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_P1S OUTPUT;

-- Insert a few sample print logs out of chronological order
-- Inserting test print logs...
-- Log 2 (The earliest print)
EXEC @ReturnStatus = dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
-- Log 3 (The latest print)
EXEC @ReturnStatus = dbo.RecordModelPrint @ModelID=@ModelID_Cube, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-08-05 14:00:00', @PrintEndDateTime='2025-08-05 14:30:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
-- Log 1 (A print in the middle)
EXEC @ReturnStatus = dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-07-20 08:00:00', @PrintEndDateTime='2025-07-20 18:00:00', @MaterialUsed=N'PETG', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

-- Verify that 3 logs were added to the table
SELECT * FROM dbo.PrintLog;
GO

---
-- EXECUTING dbo.GetPrintLogs
-- Expected: A result set with the 3 print logs, sorted with the most recent start time first.
-- The order should be: Cube, then Benchy (Resin), then Benchy (PETG).
EXEC dbo.GetPrintLogs;
GO