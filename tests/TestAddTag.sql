-- =============================================
-- Test Script for dbo.AddTag
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate.
DELETE FROM dbo.Tags;
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
GO

-- Declare variables to hold the output and return values from the procedure.
DECLARE @NewTagID INT;
DECLARE @ReturnStatus INT;

-- ==================================
-- SUCCESSFUL TESTS
-- ==================================
-- Test 1: Add a brand new tag.
-- Expected: Return Status = 0, Returned TagID = 1
EXEC @ReturnStatus = dbo.AddTag
    @TagName = N'Calibration',
    @TagID = @NewTagID OUTPUT;

SELECT 
    @ReturnStatus AS 'Return Status',
    @NewTagID AS 'Returned TagID';

-- Look up the tag that was just processed
SELECT * FROM dbo.Tags WHERE TagID = @NewTagID;

-- Test 2: Add another brand new tag.
-- Expected: Return Status = 0, Returned TagID = 2
EXEC @ReturnStatus = dbo.AddTag
    @TagName = N'Starship',
    @TagID = @NewTagID OUTPUT;

SELECT
    @ReturnStatus AS 'Return Status',
    @NewTagID AS 'Returned TagID';

-- Look up the tag that was just processed
SELECT * FROM dbo.Tags WHERE TagID = @NewTagID;

-- Test 3: Try to add an existing tag.
-- Expected: Return Status = 0, Returned TagID = 1 (the ID of the existing tag)
EXEC @ReturnStatus = dbo.AddTag
    @TagName = N'Calibration',
    @TagID = @NewTagID OUTPUT;

SELECT
    @ReturnStatus AS 'Return Status',
    @NewTagID AS 'Returned TagID';

-- Look up the tag that was just processed
SELECT * FROM dbo.Tags WHERE TagID = @NewTagID;

-- ==================================
-- VALIDATION FAILURE TESTS
-- ==================================

-- Test 4: Try to add a NULL tag name.
-- Expected: Return Status = 1 (validation failure), Returned TagID = NULL
EXEC @ReturnStatus = dbo.AddTag
    @TagName = NULL,
    @TagID = @NewTagID OUTPUT;

SELECT 
    @ReturnStatus AS 'Return Status',
    @NewTagID AS 'Returned TagID';

-- @NewTagID will be NULL, so the lookup below will correctly return nothing.
SELECT * FROM dbo.Tags WHERE TagID = @NewTagID;

-- ==================================
-- FINAL VERIFICATION
-- ==================================

-- View all tags to confirm additions
SELECT 
    TagID,
    TagName
FROM dbo.Tags;
GO