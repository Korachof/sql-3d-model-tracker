-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-09
-- Description: Deletes a model and its associated data from the database.
--              Associated ModelTags and PrintLog entries are removed
--              automatically by the ON DELETE CASCADE constraint.
--
-- Parameters:
--   @ModelID: The ID of the model to delete.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @ModelID was NULL.
--   2: Not Found. The provided @ModelID does not exist in dbo.Models.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.DeleteModel
    @ModelID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists before attempting to delete
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        DELETE FROM dbo.Models
        WHERE ModelID = @ModelID;

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