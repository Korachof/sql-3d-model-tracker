-- =============================================
-- Test Script for dbo.GetTagsForModel (with Pagination)
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

-- Insert a sample model to test with
EXEC dbo.AddModel @ModelName = N'Test Model', @SourceURL = N'http://a.com', @ModelID = @ModelID OUTPUT;

-- Insert 12 sample tags and assign them all to the test model
PRINT '--- Inserting and assigning test tags... ---';
EXEC dbo.AddTag @TagName = N'Sci-Fi', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Articulated', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Mechanical', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Functional Print', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Character', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Organizer', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Gadget', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Decoration', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Tool', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Toy', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Miniature', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;
EXEC dbo.AddTag @TagName = N'Cosplay', @TagID = @TagID OUTPUT;
EXEC dbo.AssignTagToModel @ModelID = @ModelID, @TagID = @TagID;

-- TEST 1: Default Behavior (Sort by Name ASC, Page 1, Size 50)
-- Expected: All 12 tags assigned to the model, sorted alphabetically by name.
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = @ModelID;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Sorting (Sort by TagID DESC)
-- Expected: All 12 tags, sorted by ID from 12 down to 1.
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = @ModelID, @SortBy = 'TagID', @SortDirection = 'DESC';
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Pagination (Get Page 2, Size 5)
-- Expected: 5 tags, sorted by name, starting from 'Functional Print'.
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = @ModelID, @PageNumber = 2, @PageSize = 5;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 4: Not Found (ModelID does not exist)
-- Expected: An empty result set and Return Status = 2.
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = 999;
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 5: Validation Failure (NULL ModelID)
-- Expected: An empty result set and Return Status = 1.
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO
