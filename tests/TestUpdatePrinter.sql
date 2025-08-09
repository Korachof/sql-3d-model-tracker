-- =============================================
-- Test Script for dbo.UpdatePrinter
-- =============================================

-- First, ensure we have a clean slate.
-- We must delete from PrintLog first due to the foreign key constraint.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @PrinterID_1 INT, @PrinterID_2 INT;
DECLARE @ReturnStatus INT;

-- Insert two sample printers to work with
PRINT '--- Inserting initial test printers... ---';
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_1 OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_2 OUTPUT;

SELECT * FROM dbo.Printers; -- Show initial state

-- TEST 1: Successful Update
-- Expected: Return Status = 0. The 'Elegoo' printer is updated.
EXEC @ReturnStatus = dbo.UpdatePrinter
    @PrinterID = @PrinterID_1,
    @PrinterBrand = N'Elegoo', -- Unchanged
    @PrinterModelName = N'Mars 4 Ultra', -- New Model Name
    @PrinterMaterialType = N'Resin'; -- Unchanged
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Not Found (PrinterID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.UpdatePrinter
    @PrinterID = 999, -- This ID does not exist
    @PrinterBrand = N'Ghost',
    @PrinterModelName = N'Phantom',
    @PrinterMaterialType = N'Ectoplasm';
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 3: Unique Constraint Violation
-- Try to change the Bambu Lab printer to have the same name as the Elegoo printer.
-- Expected: Return Status = 3.
EXEC @ReturnStatus = dbo.UpdatePrinter
    @PrinterID = @PrinterID_2, -- Updating the Bambu Lab
    @PrinterBrand = N'Elegoo', -- This brand/model combo is now used by Printer 1
    @PrinterModelName = N'Mars 4 Ultra',
    @PrinterMaterialType = N'Resin';
SELECT @ReturnStatus AS 'Return Status (3 is Unique Violation)';

-- TEST 4: Validation Failure (NULL Model Name)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.UpdatePrinter
    @PrinterID = @PrinterID_1,
    @PrinterBrand = N'Elegoo',
    @PrinterModelName = NULL, -- Intentionally invalid
    @PrinterMaterialType = N'Resin';
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- FINAL VERIFICATION: View all printers
-- Expected: One printer updated, no other changes.
SELECT * FROM dbo.Printers;
GO
