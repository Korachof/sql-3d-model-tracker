-- =============================================
-- Test Script for dbo.GetModelDetails
-- =============================================
-- First, ensure we have a clean slate and sample data to work with.
DELETE FROM dbo.ModelTags;
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DELETE FROM dbo.Tags;
DELETE FROM dbo.Printers;
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
GO

-- Declare all variables for the entire test batch
DECLARE @ModelID_Benchy INT, @ModelID_Cube INT;
DECLARE @TagID_Cal INT, @TagID_Boat INT;
DECLARE @PrinterID_Mars INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
EXEC dbo.AddModel @ModelName = N'Benchy', @SourceURL = N'http://a.com', @ModelID = @ModelID_Benchy OUTPUT;
EXEC dbo.AddModel @ModelName = N'Calibration Cube', @SourceURL = N'http://b.com', @ModelID = @ModelID_Cube OUTPUT;
EXEC dbo.AddTag @TagName = N'Calibration', @TagID = @TagID_Cal OUTPUT;
EXEC dbo.AddTag @TagName = N'Boat', @TagID = @TagID_Boat OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'Elegoo', @PrinterModelName = N'Mars 4', @PrinterMaterialType = N'Resin', @PrinterID = @PrinterID_Mars OUTPUT;

-- Assign tags and log prints for the 'Benchy' model
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Benchy, @TagID = @TagID_Boat;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Benchy, @PrinterID=@PrinterID_Mars, @PrintStartDateTime='2025-08-01 10:00:00', @PrintEndDateTime='2025-08-01 12:00:00', @MaterialUsed=N'Resin', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;

-- TEST 1: Get details for a model with tags and print history
-- Expected: Three result sets (Model Details, Tags, Print History) and Return Status = 0
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = @ModelID_Benchy;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Get details for a model with no tags or history
-- Expected: Three result sets (Model Details, empty Tags, empty Print History) and Return Status = 0
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = @ModelID_Cube;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Not Found (ModelID does not exist)
-- Expected: Three empty result sets and Return Status = 2
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = 999; -- This ID does not exist
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 4: Validation Failure (NULL ModelID) ---';
-- Expected: Three empty result sets and Return Status = 1
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO