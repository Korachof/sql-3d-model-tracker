-- =============================================
-- Test Script for dbo.GetModelsByTag
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate and sample data to work with.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT;
DECLARE @TagID_Cal INT, @TagID_Boat INT, @TagID_Test INT;
DECLARE @ReturnStatus INT;

-- Insert sample models and tags
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddTag @TagName = N'Calibration', @TagID = @TagID_Cal OUTPUT;
EXEC dbo.AddTag @TagName = N'Boat', @TagID = @TagID_Boat OUTPUT;
EXEC dbo.AddTag @TagName = N'Test Print', @TagID = @TagID_Test OUTPUT;

-- Assign some tags to the models
-- Benchy gets 'Boat' and 'Test Print'
-- Cube gets 'Calibration' and 'Test Print'
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Boat;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Test;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Cube, @TagID = @TagID_Cal;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Cube, @TagID = @TagID_Test;

---
PRINT '--- TEST 1: Get models for a tag with multiple models (Test Print) ---';
-- Expected: A result set with 2 models ('Benchy' and 'Calibration Cube') and Return Status = 0
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = @TagID_Test;
SELECT @ReturnStatus AS 'Return Status';

---
PRINT '--- TEST 2: Get models for a tag with a single model (Boat) ---';
-- Expected: A result set with 1 model ('Benchy') and Return Status = 0
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = @TagID_Boat;
SELECT @ReturnStatus AS 'Return Status';

---
PRINT '--- TEST 3: Get models for a tag that exists but is not assigned ---';
-- First, add a tag that isn't used
DECLARE @TagID_Unused INT;
EXEC dbo.AddTag @TagName = N'Unused Tag', @TagID = @TagID_Unused OUTPUT;
-- Expected: An empty result set and Return Status = 0
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = @TagID_Unused;
SELECT @ReturnStatus AS 'Return Status';

---
PRINT '--- TEST 4: Not Found (TagID does not exist) ---';
-- Expected: An empty result set and Return Status = 2
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

---
PRINT '--- TEST 5: Validation Failure (NULL TagID) ---';
-- Expected: An empty result set and Return Status = 1
EXEC @ReturnStatus = dbo.GetModelsByTag @TagID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO