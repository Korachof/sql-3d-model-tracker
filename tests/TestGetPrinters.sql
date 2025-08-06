-- =============================================
-- Test Script for dbo.GetPrinters
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate.
-- We must delete from PrintLog first due to the foreign key constraint.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @PrinterID_1 INT, @PrinterID_2 INT, @PrinterID_3 INT;
DECLARE @ReturnStatus INT;

-- Insert a few sample printers out of alphabetical order
PRINT '--- Inserting test printers... ---';
EXEC @ReturnStatus = dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4 Ultra', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_1 OUTPUT;
EXEC @ReturnStatus = dbo.AddPrinter @PrinterBrand = N'Prusa', @PrinterModelName = N'MK4', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_2 OUTPUT;
EXEC @ReturnStatus = dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_3 OUTPUT;

-- Verify that 3 printers were added to the table
SELECT * FROM dbo.Printers;
GO

---
PRINT '--- EXECUTING dbo.GetPrinters ---';
-- Expected: A result set with the 3 printers listed above, sorted alphabetically
-- first by PrinterBrand, then by PrinterModelName.
EXEC dbo.GetPrinters;
GO