-- =============================================
-- Test Script for dbo.GetTagsForModel
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate and sample data to work with.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT;
DECLARE @TagID_Cal INT, @TagID_Boat INT, @TagID_Test INT;
DECLARE @ReturnStatus INT;

-- Insert sample models
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
-- Insert sample tags
EXEC dbo.AddTag @TagName = N'Calibration', @TagID = @TagID_Cal OUTPUT;
EXEC dbo.AddTag @TagName = N'Boat', @TagID = @TagID_Boat OUTPUT;
EXEC dbo.AddTag @TagName = N'Test Print', @TagID = @TagID_Test OUTPUT;

-- Assign tags to the models
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Boat;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Test;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Cube, @TagID = @TagID_Cal;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Cube, @TagID = @TagID_Test;

-- TEST 1: Get tags for a model with multiple tags (Benchy) ---';
-- Expected: A result set with 2 tags ('Boat' and 'Test Print') and Return Status = 0
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = @ModelID_Benchy;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Get tags for another model with multiple tags
-- including a shared tag with Benchy. (Calibration Cube) ---';
-- Expected: A result set with 2 tags ('Calibration' and 'Test Print') and Return Status = 0
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = @ModelID_Cube;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Get tags for a model that has no tags assigned ---';
-- First, add a model with no tags
DECLARE @ModelID_NoTags INT;
EXEC dbo.AddModel @ModelName = N'Empty Model', @SourceURL = N'http://c.com', @ModelID = @ModelID_NoTags OUTPUT;
-- Expected: An empty result set and Return Status = 0
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = @ModelID_NoTags;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 4: Not Found (ModelID does not exist) ---';
-- Expected: An empty result set and Return Status = 2
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 5: Validation Failure (NULL ModelID) ---';
-- Expected: An empty result set and Return Status = 1
EXEC @ReturnStatus = dbo.GetTagsForModel @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- FINAL VERIFICATION: View all model-tag links ---';
-- Expected: Four rows linking the models to their tags.
SELECT
    m.ModelName,
    t.TagName
FROM
    dbo.ModelTags AS mt
JOIN
    dbo.Models AS m ON mt.ModelID = m.ModelID
JOIN
    dbo.Tags AS t ON mt.TagID = t.TagID;
GO
