-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-09
-- Description: Deletes a printer from the database. Associated PrintLog
--              entries are removed automatically by the ON DELETE CASCADE
--              constraint.
--
-- Parameters:
--   @PrinterID: The ID of the printer to delete.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @PrinterID was NULL.
--   2: Not Found. The provided @PrinterID does not exist in dbo.Printers.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.DeletePrinter
    @PrinterID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @PrinterID IS NULL
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided PrinterID actually exists before attempting to delete
    IF NOT EXISTS (SELECT 1 FROM dbo.Printers WHERE PrinterID = @PrinterID)
    BEGIN
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        DELETE FROM dbo.Printers
        WHERE PrinterID = @PrinterID;

        RETURN 0; -- Success

    END TRY
-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    BEGIN CATCH
        THROW;
    END CATCH
END
GO
