USE ThreeDModelsTrackerDB;
GO

-- SUCCESSFUL TESTS

-- Declare a variable to hold the output value from the stored procedure.
DECLARE @NewModelID INT;
DECLARE @ReturnStatus INT;

-- ==================================
-- SUCCESSFUL TESTS
-- ==================================

-- Test Case 1: Add a model with all details
EXEC dbo.AddModel
    @ModelName = N'Benchy the 3D Print Boat',
    @SourceURL = N'https://www.thingiverse.com/thing:763622',
    @LicenseType = N'CC BY-NC-SA 4.0',
    @ModelDescription = N'A classic 3D printing torture-test and benchmark model.',
    @ModelID = @NewModelID OUTPUT; -- Pass the variable and specify it's for OUTPUT

-- You can now see the ID that was returned
SELECT @NewModelID AS 'Newly Created Model ID';

-- Test Case 2: Add a model with only required details (LicenseType and Description will be NULL)
EXEC dbo.AddModel
    @ModelName = N'3DBenchy Hull',
    @SourceURL = N'https://www.thingiverse.com/thing:763622/files#license',
    @ModelID = @NewModelID OUTPUT; -- Reuse the same variable

SELECT @NewModelID AS 'Newly Created Model ID';

-- ==================================
-- VALIDATION FAILURE TESTS
-- ==================================

-- Test Case 3: Try to add a model with a missing (NULL) required name
-- This will return a status code of 1 and will not throw a system error.

EXEC @ReturnStatus = dbo.AddModel
    @ModelName = NULL,
    @SourceURL = N'http://badurl.com/model',
    @ModelID = @NewModelID OUTPUT;

SELECT @ReturnStatus AS 'Return Status (1 means validation failed)';

-- Test 4: Try to add a NULL tag name.
-- Expected: Return Status = 1 (validation failure), Returned TagID = NULL
EXEC @ReturnStatus = dbo.AddTag
    @TagName = NULL,
    @TagID = @NewTagID OUTPUT;

-- ==================================
-- FINAL VERIFICATION
-- ==================================

-- View all models to confirm they were added
SELECT
    ModelID,
    ModelName,
    SourceURL,
    LicenseType,
    ModelDescription
FROM
    dbo.Models;
GO