-- =============================================
-- Test Script for dbo.GetPrintLogsForPrinter
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
DECLARE @ModelID_Benchy INT;
DECLARE @PrinterID_Mars INT, @PrinterID_P1S INT;
DECLARE @PrintID INT; -- To hold the output from RecordModelPrint
DECLARE @ReturnStatus INT;

-- Insert sample models and printers
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_P1S OUTPUT;

-- Log one print for the 'Mars' printer and two for the 'P1S'
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-08-02 14:00:00', @PrintEndDateTime='2025-08-02 15:30:00', @MaterialUsed=N'PLA', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_P1S, @PrintStartDateTime='2025-08-03 09:00:00', @PrintEndDateTime='2025-08-03 09:20:00', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

-- TEST 1: Get print logs for a printer with a history (P1S)
-- Expected: A result set with 2 print logs for the 'P1S' and Return Status = 0
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = @PrinterID_P1S;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Get print logs for a printer with no history
-- First, add a printer with no logs
DECLARE @PrinterID_NoLogs INT;
EXEC dbo.AddPrinter @PrinterBrand = N'Anycubic', @PrinterModelName = N'Kobra', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_NoLogs OUTPUT;
-- Expected: An empty result set and Return Status = 0
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = @PrinterID_NoLogs;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Not Found (PrinterID does not exist)
-- Expected: An empty result set and Return Status = 2
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 4: Validation Failure (NULL PrinterID)
-- Expected: An empty result set and Return Status = 1
EXEC @ReturnStatus = dbo.GetPrintLogsForPrinter @PrinterID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO
