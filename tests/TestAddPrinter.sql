-- =============================================
-- Test Script for dbo.AddPrinter
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate.
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare all variables at the start of the single test batch.
DECLARE @NewPrinterID INT;
DECLARE @ReturnStatus INT;

---
-- TEST 1: Add a new printer
-- Expected: Return Status = 0, a new PrinterID is created.
EXEC @ReturnStatus = dbo.AddPrinter
    @PrinterBrand = N'Elegoo',
    @PrinterModelName = N'Mars 4 Ultra',
    @PrinterMaterialType = N'Resin',
    @PrinterID = @NewPrinterID OUTPUT;

SELECT @ReturnStatus AS 'Return Status', @NewPrinterID AS 'Returned PrinterID';

---
-- TEST 2: Try to add the same printer again (duplicate)
-- Expected: Return Status = 0, the SAME PrinterID as Test 1 is returned.
EXEC @ReturnStatus = dbo.AddPrinter
    @PrinterBrand = N'Elegoo',
    @PrinterModelName = N'Mars 4 Ultra',
    @PrinterMaterialType = N'Resin',
    @PrinterID = @NewPrinterID OUTPUT;

SELECT @ReturnStatus AS 'Return Status', @NewPrinterID AS 'Returned PrinterID';

---
-- TEST 3: Add a second, different printer
-- Expected: Return Status = 0, a new PrinterID is created.
EXEC @ReturnStatus = dbo.AddPrinter
    @PrinterBrand = N'Bambu Lab',
    @PrinterModelName = N'P1S',
    @PrinterMaterialType = N'Filament',
    @PrinterID = @NewPrinterID OUTPUT;

SELECT @ReturnStatus AS 'Return Status', @NewPrinterID AS 'Returned PrinterID';

---
-- TEST 4: Validation Failure (NULL Brand)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.AddPrinter
    @PrinterBrand = NULL, -- Intentionally invalid
    @PrinterModelName = N'A1 Mini',
    @PrinterMaterialType = N'Filament',
    @PrinterID = @NewPrinterID OUTPUT;

SELECT @ReturnStatus AS 'Return Status (1 is validation failure)';

---
-- FINAL VERIFICATION: View all printers
-- Expected: Only two unique printers should exist in the table.
SELECT * FROM dbo.Printers;
GO
