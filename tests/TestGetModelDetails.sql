-- =============================================
-- Test Script for dbo.GetModelDetails (with Pagination)
-- =============================================
-- First, ensure we have a clean slate and sample data.
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
DECLARE @ModelID_Test INT, @ModelID_Empty INT;
DECLARE @TagID_1 INT, @TagID_2 INT, @TagID_3 INT, @TagID_4 INT, @TagID_5 INT;
DECLARE @PrinterID_1 INT;
DECLARE @PrintID INT;
DECLARE @ReturnStatus INT;

-- Insert sample data
-- Inserting test data...
EXEC dbo.AddModel @ModelName = N'Comprehensive Test Model', @SourceURL = N'http://a.com', @ModelID = @ModelID_Test OUTPUT;
EXEC dbo.AddModel @ModelName = N'Empty Model', @SourceURL = N'http://b.com', @ModelID = @ModelID_Empty OUTPUT;
EXEC dbo.AddPrinter @PrinterBrand = N'TestBrand', @PrinterModelName = N'TestModel', @PrinterMaterialType = N'Filament', @PrinterID = @PrinterID_1 OUTPUT;
EXEC dbo.AddTag @TagName = N'Tag A', @TagID = @TagID_1 OUTPUT;
EXEC dbo.AddTag @TagName = N'Tag B', @TagID = @TagID_2 OUTPUT;
EXEC dbo.AddTag @TagName = N'Tag C', @TagID = @TagID_3 OUTPUT;
EXEC dbo.AddTag @TagName = N'Tag D', @TagID = @TagID_4 OUTPUT;
EXEC dbo.AddTag @TagName = N'Tag E', @TagID = @TagID_5 OUTPUT;

-- Assign tags and log prints for the test model
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Test, @TagID = @TagID_1;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Test, @TagID = @TagID_2;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Test, @TagID = @TagID_3;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Test, @TagID = @TagID_4;
EXEC dbo.AssignTagToModel @ModelID = @ModelID_Test, @TagID = @TagID_5;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Test, @PrinterID=@PrinterID_1, @PrintStartDateTime='2025-01-01', @PrintEndDateTime='2025-01-02', @MaterialUsed=N'PLA', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Test, @PrinterID=@PrinterID_1, @PrintStartDateTime='2025-02-01', @PrintEndDateTime='2025-02-02', @MaterialUsed=N'PETG', @PrintStatus=N'Success', @PrintID=@PrintID OUTPUT;
EXEC dbo.RecordModelPrint @ModelID=@ModelID_Test, @PrinterID=@PrinterID_1, @PrintStartDateTime='2025-03-01', @PrintEndDateTime='2025-03-02', @MaterialUsed=N'ABS', @PrintStatus=N'Failed', @PrintID=@PrintID OUTPUT;

-- TEST 1: Get details for a model with full history (Default Sort/Page)
-- Expected: Three result sets (Model Details, 5 Tags, 3 Print Logs)
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = @ModelID_Test;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 2: Get details with custom sorting and pagination
-- Expected: Three result sets:
-- 1. Model details for the 'Comprehensive Test Model'.
-- 2. Page 2 of tags (2 tags), sorted by TagID DESC.
-- 3. Page 1 of print logs (2 logs), sorted by PrintStatus ASC.
EXEC @ReturnStatus = dbo.GetModelDetails
    @ModelID = @ModelID_Test,
    @TagSortBy = 'TagID',
    @TagSortDirection = 'DESC',
    @TagPageNumber = 2,
    @TagPageSize = 3,
    @PrintLogSortBy = 'PrintStatus',
    @PrintLogSortDirection = 'ASC',
    @PrintLogPageNumber = 1,
    @PrintLogPageSize = 2;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 3: Get details for a model with no history
-- Expected: Three result sets (Model Details, empty Tags, empty Print History)
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = @ModelID_Empty;
SELECT @ReturnStatus AS 'Return Status';

-- TEST 4: Not Found (ModelID does not exist)
-- Expected: Three empty result sets and Return Status = 2
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = 999;
SELECT @ReturnStatus AS 'Return Status (2 is Not Found)';

-- TEST 5: Validation Failure (NULL ModelID)
-- Expected: Three empty result sets and Return Status = 1
EXEC @ReturnStatus = dbo.GetModelDetails @ModelID = NULL;
SELECT @ReturnStatus AS 'Return Status (1 is Validation Failure)';
GO