-- =============================================
-- Test Script for dbo.UpdateTag
-- =============================================

-- First, ensure we have a clean slate.
-- We must delete from ModelTags first due to the foreign key constraint.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @TagID_1 INT, @TagID_2 INT;
DECLARE @ReturnStatus INT;

-- Insert two sample tags to work with
-- Inserting initial test tags...
EXEC dbo.AddTag @TagName = N'Calibration', @TagID = @TagID_1 OUTPUT;
EXEC dbo.AddTag @TagName = N'Sci-Fi', @TagID = @TagID_2 OUTPUT;

SELECT * FROM dbo.Tags; -- Show initial state

-- TEST 1: Successful Update
-- Expected: Return Status = 0. The 'Calibration' tag is renamed.
EXEC @ReturnStatus = dbo.UpdateTag
    @TagID = @TagID_1,
    @TagName = N'Benchmark'; -- New Name
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Not Found (TagID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.UpdateTag
    @TagID = 999, -- This ID does not exist
    @TagName = N'Ghost Tag';
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 3: Unique Constraint Violation
-- Try to change the 'Sci-Fi' tag to 'Benchmark', which is now in use.
-- Expected: Return Status = 3.
EXEC @ReturnStatus = dbo.UpdateTag
    @TagID = @TagID_2, -- Updating the 'Sci-Fi' tag
    @TagName = N'Benchmark'; -- This name is now used by Tag 1
SELECT @ReturnStatus AS 'Return Status (3 is Unique Violation)';

-- TEST 4: Validation Failure (NULL Name)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.UpdateTag
    @TagID = @TagID_1,
    @TagName = NULL; -- Intentionally invalid
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- FINAL VERIFICATION: View all tags
-- Expected: One tag updated, no other changes.
SELECT * FROM dbo.Tags;
GO