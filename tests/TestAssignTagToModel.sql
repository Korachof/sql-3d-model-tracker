-- =============================================
-- Test Script for dbo.AssignTagToModel
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
DECLARE @ModelID_Benchy INT, @ModelID_Hull INT;
DECLARE @TagID_Cal INT, @TagID_Boat INT;
DECLARE @ReturnStatus INT;

-- Insert sample models and tags, and capture their new IDs
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Hull', @SourceURL = N'http://b.com', @ModelID = @ModelID_Hull OUTPUT;
EXEC dbo.AddTag @TagName = N'Calibration', @TagID = @TagID_Cal OUTPUT;
EXEC dbo.AddTag @TagName = N'Boat', @TagID = @TagID_Boat OUTPUT;

---
-- TEST 1: Assign a new tag to a model
-- Expected: Return Status = 0
EXEC @ReturnStatus = dbo.AssignTagToModel
    @ModelID = @ModelID_Benchy,
    @TagID = @TagID_Cal;
SELECT @ReturnStatus AS 'Return Status';

---
-- TEST 2: Assign another new tag to the same model
-- Expected: Return Status = 0
EXEC @ReturnStatus = dbo.AssignTagToModel
    @ModelID = @ModelID_Benchy,
    @TagID = @TagID_Boat;
SELECT @ReturnStatus AS 'Return Status';

---
-- TEST 3: Try to assign an existing tag again (duplicate)
-- Expected: Return Status = 0
EXEC @ReturnStatus = dbo.AssignTagToModel
    @ModelID = @ModelID_Benchy,
    @TagID = @TagID_Cal;
SELECT @ReturnStatus AS 'Return Status';

---
-- TEST 4: Foreign Key Violation (ModelID does not exist)
-- Expected: Return Status = 2
EXEC @ReturnStatus = dbo.AssignTagToModel
    @ModelID = 999, -- This ID does not exist
    @TagID = @TagID_Cal;
SELECT @ReturnStatus AS 'Return Status (2 is FK violation)';

---
-- TEST 5: Foreign Key Violation (TagID does not exist)
-- Expected: Return Status = 3
EXEC @ReturnStatus = dbo.AssignTagToModel
    @ModelID = @ModelID_Benchy,
    @TagID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (3 is FK violation)';

---
-- FINAL VERIFICATION: View all model-tag links
-- Expected: Two rows linking the 'Benchy' model to two different tags.
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