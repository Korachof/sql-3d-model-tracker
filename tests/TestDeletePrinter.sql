-- =============================================
-- Test Script for dbo.DeletePrinter
-- =============================================

-- First, ensure we have a clean slate and sample data.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @PrinterID_Mars INT, @PrinterID_P1S INT;
DECLARE @ModelID_Benchy INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
-- Inserting initial test data...
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_P1S OUTPUT;
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;

-- Log a print for the 'Mars' printer so we can test ON DELETE CASCADE
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

-- Initial State
SELECT * FROM dbo.Printers;
SELECT * FROM dbo.PrintLog;

-- TEST 1: Successful Delete
-- Expected: Return Status = 0. The 'Mars' printer and its print log are deleted.
EXEC @ReturnStatus = dbo.DeletePrinter @PrinterID = @PrinterID_Mars;
SELECT @ReturnStatus AS 'Return Status';

---
-- TEST 2: Not Found (PrinterID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.DeletePrinter @PrinterID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

---
-- TEST 3: Validation Failure (NULL PrinterID)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.DeletePrinter @PrinterID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

---
-- FINAL VERIFICATION: View all tables
-- Expected:
-- dbo.Printers: Only the 'P1S' printer should remain.
-- dbo.PrintLog: Should be empty.
SELECT * FROM dbo.Printers;
SELECT * FROM dbo.PrintLog;
GO