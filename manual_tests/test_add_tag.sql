USE ThreeDModelTrackerDB;
GO

-- Test 1: Add a brand new tag
EXEC AddTag @TagName = N'Calibration';
GO

-- Test 2: Add another brand new tag
EXEC AddTag @TagName = N'Starship';
GO

-- Test 3: Try to add an existing tag (should return existing ID, not create new row)
EXEC AddTag @TagName = N'Calibration';
GO

-- View all tags to confirm additions
SELECT tag_id, tag_name
FROM Tags;
GO