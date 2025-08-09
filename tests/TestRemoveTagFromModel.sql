-- =============================================
-- Test Script for dbo.RemoveTagFromModel
-- =============================================
-- First, ensure we have a clean slate and sample data.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT;
DECLARE @TagID_Boat INT, @TagID_Test INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
-- Inserting initial test data...
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddTag @TagName = N'Boat', @TagID = @TagID_Boat OUTPUT;
EXEC dbo.AddTag @TagName = N'Test Print', @TagID = @TagID_Test OUTPUT;

-- Assign both tags to the 'Benchy' model
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Boat;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Test;

-- Initial State
SELECT * FROM dbo.ModelTags;

-- TEST 1: Successful Removal
-- Expected: Return Status = 0. The 'Boat' tag link is removed from the Benchy.
EXEC @ReturnStatus = dbo.RemoveTagFromModel
    @ModelID = @ModelID_Benchy,
    @TagID = @TagID_Boat;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Not Found (Link does not exist) 
-- The link for the 'Boat' tag was already removed, so trying again should fail.
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.RemoveTagFromModel
    @ModelID = @ModelID_Benchy,
    @TagID = @TagID_Boat;
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 3: Validation Failure (NULL ModelID)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.RemoveTagFromModel
    @ModelID = NULL,
    @TagID = @TagID_Test;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- TEST 4: Validation Failure (NULL TagID)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.RemoveTagFromModel
    @ModelID = @ModelID_Benchy,
    @TagID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- FINAL VERIFICATION: View all model-tag links
-- Expected: Only the link for the 'Test Print' tag should remain.
SELECT * FROM dbo.ModelTags;
GO