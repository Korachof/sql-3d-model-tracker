-- ==================================================
-- Test Script for dbo.GetPrinters (with Pagination)
-- ==================================================

-- First, ensure we have a clean slate.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @PrinterID INT;
DECLARE @ReturnStatus INT;

-- Insert 12 sample printers to test with
PRINT '--- Inserting test printers... ---';
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4 Ultra', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Prusa', @PrinterModelName = N'MK4', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Bambu Lab', @PrinterModelName = N'P1S', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Anycubic', @PrinterModelName = N'Photon Mono', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Creality', @PrinterModelName = N'Ender 3', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Formlabs', @PrinterModelName = N'Form 3', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Ultimaker', @PrinterModelName = N'S5', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Raise3D', @PrinterModelName = N'Pro2', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Phrozen', @PrinterModelName = N'Sonic Mini 8K', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'LulzBot', @PrinterModelName = N'TAZ Workhorse', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Zortrax', @PrinterModelName = N'M200 Plus', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'MakerBot', @PrinterModelName = N'Replicator+', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID OUTPUT;

-- TEST 1: Default Behavior (Sort by Brand ASC, Page 1, Size 50)
-- Expected: All 12 printers, sorted alphabetically by brand.
EXEC dbo.GetPrinters;

-- TEST 2: Sorting (Sort by PrinterID DESC)
-- Expected: All 12 printers, sorted by ID from 12 down to 1.
EXEC dbo.GetPrinters @SortBy = 'PrinterID', @SortDirection = 'DESC';

-- TEST 3: Pagination (Get Page 2, Size 5)
-- Expected: 5 printers, sorted by brand, starting from 'Formlabs'.
EXEC dbo.GetPrinters @PageNumber = 2, @PageSize = 5;

-- TEST 4: Sorting and Pagination Combined
-- Expected: 4 printers, sorted by MaterialType DESC, showing the first page.
EXEC dbo.GetPrinters @SortBy = 'PrinterMaterialType', @SortDirection = 'DESC', @PageNumber = 1, @PageSize = 4;
GO
