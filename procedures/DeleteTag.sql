-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-09
-- Description: Deletes a tag from the database. Associated ModelTags
--              entries are removed automatically by the ON DELETE CASCADE
--              constraint.
--
-- Parameters:
--   @TagID: The ID of the tag to delete.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @TagID was NULL.
--   2: Not Found. The provided @TagID does not exist in dbo.Tags.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.DeleteTag
    @TagID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @TagID IS NULL
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided TagID actually exists before attempting to delete
    IF NOT EXISTS (SELECT 1 FROM dbo.Tags WHERE TagID = @TagID)
    BEGIN
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        DELETE FROM dbo.Tags
        WHERE TagID = @TagID;

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