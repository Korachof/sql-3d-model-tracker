USE ThreeDModelTrackerDB;
GO

-- SUCCESSFUL TESTS

-- Test Case 1: Add a model with all details
EXEC AddModel
    @ModelName = N'Benchy the 3D Print Boat',
    @SourceURL = N'https://www.thingiverse.com/thing:763622',
    @LicenseType = N'CC BY-NC-SA 4.0',
    @ModelDescription = N'A classic 3D printing torture-test and benchmark model.';

-- Test Case 2: Add a model with only required details (LicenseType and Description will be NULL)
EXEC AddModel
    @ModelName = N'3DBenchy Hull',
    @SourceURL = N'https://www.thingiverse.com/thing:763622/files#license';


-- ERROR HANDLING TESTS (LEAVE COMMENTED OUT UNLESS SPECIFICALLY TESTING THIS BEHAVIOR)

/* Test Case 3: Try to add a model with a missing (NULL) required name (should show an error)
EXEC AddModel
    @ModelName = NULL,
    @SourceURL = N'http://badurl.com/model';
*/

/* Test Case 4: Try to add a model with an empty string for SourceURL (should show an error)
EXEC AddModel
    @ModelName = N'Test Model',
    @SourceURL = N'';
*/

-- View all models to confirm they were added
SELECT model_id, model_name, source_url, license_type, model_description
FROM Models;
GO