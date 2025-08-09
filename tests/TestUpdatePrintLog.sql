-- =============================================
-- Test Script for dbo.UpdatePrintLog
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
DECLARE @ModelID_1 INT, @ModelID_2 INT;
DECLARE @PrinterID_1 INT, @PrinterID_2 INT;
DECLARE @PrintID_1 INT, @PrintID_2 INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
PRINT '--- Inserting initial test data... ---';
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_1 OUTPUT;
EXEC dbo.AddModel @ModelName = N'Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_2 OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_1 OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_2 OUTPUT;

EXEC dbo.RecordModelPrint @ModelID=@ModelID_1, @PrinterID=@PrinterID_1, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID_1 OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_2, @PrinterID=@PrinterID_2, @PrintStartDateTime='2025-08-02 14:00:00', @PrintEndDateTime='2025-08-02 15:30:00', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID_2 OUTPUT;

SELECT * FROM dbo.PrintLog; -- Show initial state

-- TEST 1: Successful Update 
-- Expected: Return Status = 0. PrintLog with PrintID 1 is updated.
EXEC @ReturnStatus = dbo.UpdatePrintLog
    @PrintID = @PrintID_1,
    @ModelID = @ModelID_1,
    @PrinterID = @PrinterID_2, -- Change printer
    @PrintStartDateTime = '2025-08-01 10:00:00',
    @PrintEndDateTime = '2025-08-01 12:30:00', -- Change end time
    @MaterialUsed = N'Tough Resin', -- Change material
    @PrintStatus = N'Success with notes', -- Change status
    @PrintStatusDetails = N'Minor warping on the stern.';
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Not Found (PrintID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.UpdatePrintLog @PrintID=999, @ModelID=@ModelID_1, @PrinterID=@PrinterID_1, @PrintStartDateTime='2025-01-01 00:00:00', @PrintEndDateTime='2025-01-01 01:00:00', @MaterialUsed=N'N/A', @PrintStatus=N'N/A';
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 3: Foreign Key Violation (New ModelID does not exist)
-- Expected: Return Status = 3.
EXEC @ReturnStatus = dbo.UpdatePrintLog
    @PrintID = @PrintID_1,
    @ModelID = 999, -- This ID does not exist
    @PrinterID = @PrinterID_1,
    @PrintStartDateTime = '2025-08-01 10:00:00',
    @PrintEndDateTime = '2025-08-01 12:30:00',
    @MaterialUsed = N'Tough Resin',
    @PrintStatus = N'Success';
SELECT @ReturnStatus AS 'Return Status (3 is FK Violation)';

-- TEST 4: Foreign Key Violation (New PrinterID does not exist)
-- Expected: Return Status = 4.
EXEC @ReturnStatus = dbo.UpdatePrintLog
    @PrintID = @PrintID_1,
    @ModelID = @ModelID_1,
    @PrinterID = 999, -- This ID does not exist
    @PrintStartDateTime = '2025-08-01 10:00:00',
    @PrintEndDateTime = '2025-08-01 12:30:00',
    @MaterialUsed = N'Tough Resin',
    @PrintStatus = N'Success';
SELECT @ReturnStatus AS 'Return Status (4 is FK Violation)';

-- TEST 5: Unique Constraint Violation
-- Try to change Print 1's start time to match Print 2's start time and model.
-- Expected: Return Status = 5.
EXEC @ReturnStatus = dbo.UpdatePrintLog
    @PrintID = @PrintID_1,
    @ModelID = @ModelID_2, -- Match ModelID of Print 2
    @PrinterID = @PrinterID_1,
    @PrintStartDateTime = '2025-08-02 14:00:00', -- Match Start Time of Print 2
    @PrintEndDateTime = '2025-08-02 15:00:00',
    @MaterialUsed = N'Resin',
    @PrintStatus = N'Success';
SELECT @ReturnStatus AS 'Return Status (5 is Unique Violation)';

-- FINAL VERIFICATION: View all print logs
-- Expected: One print log updated, no other changes.
SELECT * FROM dbo.PrintLog;
GO