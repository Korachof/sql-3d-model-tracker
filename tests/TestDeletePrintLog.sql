-- =============================================
-- Test Script for dbo.DeletePrintLog
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
DECLARE @ModelID_Benchy INT;
DECLARE @PrinterID_Mars INT;
DECLARE @PrintID_1 INT, @PrintID_2 INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
-- Inserting initial test data...
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;

-- Log two prints to test with
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID_1 OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-02 14:00:00', @PrintEndDateTime='2025-08-02 15:30:00', @MaterialUsed=N'Resin', @PrintStatus=N'Failed', @PrintID=@PrintID_2 OUTPUT;

-- Initial State 
SELECT * FROM dbo.PrintLog;

-- TEST 1: Successful Delete
-- Expected: Return Status = 0. The first print log is deleted.
EXEC @ReturnStatus = dbo.DeletePrintLog @PrintID = @PrintID_1;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Not Found (PrintID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.DeletePrintLog @PrintID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 3: Validation Failure (NULL PrintID)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.DeletePrintLog @PrintID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- FINAL VERIFICATION: View all print logs
-- Expected: Only the second print log should remain.
SELECT * FROM dbo.PrintLog;
GO