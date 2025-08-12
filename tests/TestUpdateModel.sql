-- =============================================
-- Test Script for dbo.UpdateModel
-- =============================================

-- First, ensure we have a clean slate.
-- ON DELETE CASCADE will handle related tables.
DELETE FROM dbo.Models;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @ModelID_1 INT, @ModelID_2 INT;
DECLARE @ReturnStatus INT;

-- Insert two sample models to work with

-- Inserting initial test models... 
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_1 OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_2 OUTPUT;

SELECT * FROM dbo.Models; -- Show initial state
GO

-- Redeclare after GO for the main test batch
DECLARE @ModelID_1 INT = 1, @ModelID_2 INT = 2; -- Manually set IDs based on fresh seed
DECLARE @ReturnStatus INT;

-- TEST 1: Successful Update 
-- Expected: Return Status = 0. 'Benchy' model is updated.
EXEC @ReturnStatus = dbo.UpdateModel
    @ModelID = @ModelID_1,
    @ModelName = N'#3DBenchy', -- New Name
    @SourceURL = N'http://a.com/updated', -- New URL
    @LicenseType = N'GPLv3',
    @ModelDescription = N'An updated description.';
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Not Found (ModelID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.UpdateModel
    @ModelID = 999, -- This ID does not exist
    @ModelName = N'Ghost Model',
    @SourceURL = N'http://ghost.com';
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 3: Unique Constraint Violation
-- Try to change the Cube's URL to the Benchy's updated URL.
-- Expected: Return Status = 3.
EXEC @ReturnStatus = dbo.UpdateModel
    @ModelID = @ModelID_2, -- Updating the Cube
    @ModelName = N'Cube with Duplicate URL',
    @SourceURL = N'http://a.com/updated'; -- This URL is now used by Benchy
SELECT @ReturnStatus AS 'Return Status (3 is Unique Violation)';

-- TEST 4: Validation Failure (NULL Name)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.UpdateModel
    @ModelID = @ModelID_1,
    @ModelName = NULL, -- Intentionally invalid
    @SourceURL = N'http://a.com/updated';
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';

-- FINAL VERIFICATION: View all models
-- Expected: One model updated, no other changes.
SELECT * FROM dbo.Models;
GO