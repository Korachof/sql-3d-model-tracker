-- =============================================
-- Test Script for dbo.GetModels (with Pagination)
-- =============================================
-- First, ensure we have a clean slate.
DELETE FROM dbo.Models;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @ModelID INT;
DECLARE @ReturnStatus INT;

-- Insert 12 sample models to test with
PRINT '--- Inserting test models... ---';
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @LicenseType = N'GPL', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Robot Arm', @SourceURL = N'http://b.com', @LicenseType = N'MIT', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Vase', @SourceURL = N'http://c.com', @LicenseType = N'CC BY-SA', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://d.com', @LicenseType = N'GPL', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Dragon', @SourceURL = N'http://e.com', @LicenseType = N'MIT', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Phone Stand', @SourceURL = N'http://f.com', @LicenseType = N'CC BY-NC', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Keychain', @SourceURL = N'http://g.com', @LicenseType = N'GPL', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Planter', @SourceURL = N'http://h.com', @LicenseType = N'CC BY-SA', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Gear', @SourceURL = N'http://i.com', @LicenseType = N'MIT', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Cookie Cutter', @SourceURL = N'http://j.com', @LicenseType = N'CC BY-NC', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Earbud Holder', @SourceURL = N'http://k.com', @LicenseType = N'GPL', @ModelID = @ModelID OUTPUT;
EXEC dbo.AddModel @ModelName = N'Cable Clip', @SourceURL = N'http://l.com', @LicenseType = N'CC BY-SA', @ModelID = @ModelID OUTPUT;

---
PRINT
-- TEST 1: Default Behavior (Sort by Name ASC, Page 1, Size 50)
-- Expected: All 12 models, sorted alphabetically by name.
EXEC dbo.GetModels;

---
PRINT
-- TEST 2: Sorting (Sort by ModelID DESC)
-- Expected: All 12 models, sorted by ID from 12 down to 1.
EXEC dbo.GetModels @SortBy = 'ModelID', @SortDirection = 'DESC';

---
PRINT
-- TEST 3: Pagination (Get Page 2, Size 5)
-- Expected: 5 models, sorted by name, starting from 'Dragon'.
EXEC dbo.GetModels @PageNumber = 2, @PageSize = 5;

---
PRINT
-- TEST 4: Sorting and Pagination Combined
-- Expected: 5 models, sorted by LicenseType DESC, showing the second page.
EXEC dbo.GetModels @SortBy = 'LicenseType', @SortDirection = 'DESC', @PageNumber = 2, @PageSize = 5;
GO
