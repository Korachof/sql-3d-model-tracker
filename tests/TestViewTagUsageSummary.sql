-- =============================================
-- Test Script for dbo.vw_TagUsageSummary
-- =============================================

-- First, ensure we have a clean slate and sample data.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_1 INT, @ModelID_2 INT, @ModelID_3 INT;
DECLARE @TagID_SciFi INT, @TagID_Mech INT, @TagID_Unused INT;
DECLARE @ReturnStatus INT;

-- Insert sample models and tags
-- Inserting initial test data...
EXEC dbo.AddModel @ModelName = N'Spaceship', @SourceURL = N'http://a.com', @ModelID = @ModelID_1 OUTPUT;
EXEC dbo.AddModel @ModelName = N'Robot', @SourceURL = N'http://b.com', @ModelID = @ModelID_2 OUTPUT;
EXEC dbo.AddModel @ModelName = N'Gunpla', @SourceURL = N'http://c.com', @ModelID = @ModelID_3 OUTPUT;

EXEC dbo.AddTag @TagName = N'Sci-Fi', @TagID = @TagID_SciFi OUTPUT;
EXEC dbo.AddTag @TagName = N'Mechanical', @TagID = @TagID_Mech OUTPUT;
EXEC dbo.AddTag @TagName = N'Unused', @TagID = @TagID_Unused OUTPUT;

-- Assign tags to create a varied count
-- 'Sci-Fi' is used 3 times
-- 'Mechanical' is used 2 times
-- 'Unused' is used 0 times
EXEC dbo.AssignTagToModel @ModelID = @ModelID_1, @TagID = @TagID_SciFi;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_2, @TagID = @TagID_SciFi;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_3, @TagID = @TagID_SciFi;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_2, @TagID = @TagID_Mech;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_3, @TagID = @TagID_Mech;

-- QUERYING THE dbo.vw_TagUsageSummary VIEW
-- Expected: Three rows with the correct ModelCount for each tag.
-- Sci-Fi: 3
-- Mechanical: 2
-- Unused: 0
SELECT * FROM dbo.vw_TagUsageSummary ORDER BY ModelCount DESC;
GO
