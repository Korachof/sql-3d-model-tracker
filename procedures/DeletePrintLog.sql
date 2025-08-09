-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-09
-- Description: Deletes a single print log entry from the database.
--
-- Parameters:
--   @PrintID: The ID of the print log to delete.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @PrintID was NULL.
--   2: Not Found. The provided @PrintID does not exist in dbo.PrintLog.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.DeletePrintLog
    @PrintID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @PrintID IS NULL
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided PrintID actually exists before attempting to delete
    IF NOT EXISTS (SELECT 1 FROM dbo.PrintLog WHERE PrintID = @PrintID)
    BEGIN
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        DELETE FROM dbo.PrintLog
        WHERE PrintID = @PrintID;

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