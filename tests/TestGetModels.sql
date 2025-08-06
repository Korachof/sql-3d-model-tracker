-- =============================================
-- Test Script for dbo.GetModels
-- =============================================
USE ThreeDModelsTrackerDB;
GO

-- First, ensure we have a clean slate.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
GO

-- Declare variables for the entire test batch
DECLARE @ModelID_1 INT, @ModelID_2 INT, @ModelID_3 INT;
DECLARE @ReturnStatus INT;

-- Insert a few sample models out of alphabetical order
PRINT '--- Inserting test models... ---';
-- Add first Model -- "Robot Arm
EXEC @ReturnStatus = dbo.AddModel @ModelName = N'Robot Arm', @SourceURL = N'http://c.com', @ModelID = @ModelID_1 OUTPUT;
-- Add Second Model -- "Benchy"
-- Includes Name, URL, License Type, and Description
EXEC @ReturnStatus = dbo.AddModel
    @ModelName = N'Benchy',
    @SourceURL = N'http://a.com',
    @LicenseType = N'Creative Commons - Attribution', -- Added for testing
    @ModelDescription = N'The jolly 3D printing torture-test.', -- Added for testing
    @ModelID = @ModelID_2 OUTPUT;
-- Add Third Model -- "Calibration Cube"
EXEC @ReturnStatus = dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_3 OUTPUT;

-- Verify that 3 models were added to the table
SELECT * FROM dbo.Models;
GO

---
PRINT '--- EXECUTING dbo.GetModels ---';
-- Expected: A result set with the 3 models listed above, sorted alphabetically by ModelName.
EXEC dbo.GetModels;
GO
