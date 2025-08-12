-- =============================================
-- Test Script for dbo.GetModelsByTag (with Pagination)
-- =============================================
-- First, ensure we have a clean slate and sample data to work with.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID INT, @TagID INT, @ReturnStatus INT;

-- Insert 12 sample models
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

-- Insert 3 sample tags
DECLARE @TagID_GPL INT, @TagID_MIT INT, @TagID_CC INT;
EXEC dbo.AddTag @TagName = N'GPL License', @TagID = @TagID_GPL OUTPUT;
EXEC dbo.AddTag @TagName = N'MIT License', @TagID = @TagID_MIT OUTPUT;
EXEC dbo.AddTag @TagName = N'Creative Commons', @TagID = @TagID_CC OUTPUT;

-- Assign tags to models based on their license type for testing
INSERT INTO dbo.ModelTags (ModelID, TagID)
SELECT ModelID, @TagID_GPL FROM dbo.Models WHERE LicenseType = 'GPL';
INSERT INTO dbo.ModelTags (ModelID, TagID)
SELECT ModelID, @TagID_MIT FROM dbo.Models WHERE LicenseType = 'MIT';
INSERT INTO dbo.ModelTags (ModelID, TagID)
SELECT ModelID, @TagID_CC FROM dbo.Models WHERE LicenseType LIKE 'CC BY%';

-- TEST 1: Get models for a tag (GPL License) with default sort/page
-- Expected: 4 models with the GPL license, sorted by name.
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = @TagID_GPL;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Sorting (Sort by ModelID DESC)
-- Expected: The same 4 models, but sorted by ID from highest to lowest.
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = @TagID_GPL, @SortBy = 'ModelID', @SortDirection = 'DESC';
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Pagination (Get Page 2, Size 2)
-- Expected: 2 models with the GPL license, sorted by name, showing the second page.
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = @TagID_GPL, @PageNumber = 2, @PageSize = 2;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 4: Not Found (TagID does not exist)
-- Expected: An empty result set and Return Status = 2.
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = 999;
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 5: Validation Failure (NULL TagID)
-- Expected: An empty result set and Return Status = 1.
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO
