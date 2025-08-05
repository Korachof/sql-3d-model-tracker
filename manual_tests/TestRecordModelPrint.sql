-- =============================================
-- Test Script for dbo.RecordModelPrint
-- =============================================
-- First, ensure we have a clean slate and a model to test with.
DELETE FROM dbo.PrintLog;
DELETE FROM dbo.Models;
DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
GO

-- Declare all variables at the start of the single test batch.
DECLARE @TestModelID INT;
DECLARE @NewPrintID INT;
DECLARE @ReturnStatus INT;

-- Insert a sample model to log prints against.
EXEC dbo.AddModel
    @ModelName = N'Test Model for Printing',
    @SourceURL = N'http://test.com/model/123',
    @ModelID = @TestModelID OUTPUT;

-- TEST 1: Log a new, successful print
-- Expected: Return Status = 0, a new PrintID is created.
EXEC @ReturnStatus = dbo.RecordModelPrint
    @ModelID = @TestModelID,
    @PrintStartDateTime = '2025-08-05 08:00:00',
    @PrintEndDateTime = '2025-08-05 09:30:00',
    @MaterialUsed = N'PLA',
    @PrintStatus = N'Success',
    @PrintID = @NewPrintID OUTPUT;

SELECT @ReturnStatus AS 'Return Status', @NewPrintID AS 'Returned PrintID';

-- TEST 2: Try to log the exact same print again (duplicate) 
-- Expected: Return Status = 0, the SAME PrintID as Test 1 is returned.
EXEC @ReturnStatus = dbo.RecordModelPrint
    @ModelID = @TestModelID,
    @PrintStartDateTime = '2025-08-05 08:00:00',
    @PrintEndDateTime = '2025-08-05 09:30:00',
    @MaterialUsed = N'PLA',
    @PrintStatus = N'Success',
    @PrintID = @NewPrintID OUTPUT;

SELECT @ReturnStatus AS 'Return Status', @NewPrintID AS 'Returned PrintID';

---
-- TEST 3: Validation Failure (NULL MaterialUsed)
-- Expected: Return Status = 1.
EXEC @ReturnStatus = dbo.RecordModelPrint
    @ModelID = @TestModelID,
    @PrintStartDateTime = '2025-08-05 10:00:00',
    @PrintEndDateTime = '2025-08-05 11:00:00',
    @MaterialUsed = NULL, -- Intentionally invalid
    @PrintStatus = N'Success',
    @PrintID = @NewPrintID OUTPUT;

SELECT @ReturnStatus AS 'Return Status (1 is validation failure)';

-- TEST 4: Foreign Key Violation (ModelID does not exist)
-- Expected: Return Status = 2.
EXEC @ReturnStatus = dbo.RecordModelPrint
    @ModelID = 999, -- This ID does not exist
    @PrintStartDateTime = '2025-08-05 12:00:00',
    @PrintEndDateTime = '2025-08-05 13:00:00',
    @MaterialUsed = N'PETG',
    @PrintStatus = N'Failed',
    @PrintID = @NewPrintID OUTPUT;

SELECT @ReturnStatus AS 'Return Status (2 is FK violation)';

-- FINAL VERIFICATION: View all print logs 
-- Expected: Only one print log should exist in the table.
SELECT * FROM dbo.PrintLog;
GO