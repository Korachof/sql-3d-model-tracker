-- =============================================
-- Test Script for dbo.GetTags
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate.
-- We must delete from ModelTags first due to the foreign key constraint.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @TagID_1 INT, @TagID_2 INT, @TagID_3 INT;
DECLARE @ReturnStatus INT;

-- Insert a few sample tags out of alphabetical order
-- Inserting test tags...
EXEC @ReturnStatus = dbo.AddTag @TagName = N'Sci-Fi', @TagID = @TagID_1 OUTPUT;
EXEC @ReturnStatus = dbo.AddTag @TagName = N'Articulated', @TagID = @TagID_2 OUTPUT;
EXEC @ReturnStatus = dbo.AddTag @TagName = N'Mechanical', @TagID = @TagID_3 OUTPUT;

-- Verify that 3 tags were added to the table
SELECT * FROM dbo.Tags;
GO


-- EXECUTING dbo.GetTags
-- Expected: A result set with the 3 tags listed above, sorted alphabetically by TagName.
EXEC dbo.GetTags;
GO