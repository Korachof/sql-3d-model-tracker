-- =============================================
-- Test Script for dbo.GetTags (with Pagination)
-- =============================================
-- First, ensure we have a clean slate.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @TagID INT;
DECLARE @ReturnStatus INT;

-- Insert 12 sample tags to test with
PRINT '--- Inserting test tags... ---';
EXEC dbo.AddTag @TagName = N'Sci-Fi', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Articulated', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Mechanical', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Functional Print', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Character', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Organizer', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Gadget', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Decoration', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Tool', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Toy', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Miniature', @TagID = @TagID OUTPUT;
EXEC dbo.AddTag @TagName = N'Cosplay', @TagID = @TagID OUTPUT;

-- TEST 1: Default Behavior (Sort by Name ASC, Page 1, Size 50)
-- Expected: All 12 tags, sorted alphabetically by name.
EXEC dbo.GetTags;

-- TEST 2: Sorting (Sort by TagID DESC)
-- Expected: All 12 tags, sorted by ID from 12 down to 1.
EXEC dbo.GetTags @SortBy = 'TagID', @SortDirection = 'DESC';

-- TEST 3: Pagination (Get Page 2, Size 5)
-- Expected: 5 tags, sorted by name, starting from 'Gadget'.
EXEC dbo.GetTags @PageNumber = 2, @PageSize = 5;

-- TEST 4: Sorting and Pagination Combined
-- Expected: 4 tags, sorted by TagID DESC, showing the third page.
EXEC dbo.GetTags @SortBy = 'TagID', @SortDirection = 'DESC', @PageNumber = 3, @PageSize = 4;
GO