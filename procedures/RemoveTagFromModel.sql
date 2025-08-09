-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-09
-- Description: Removes a specific tag assignment from a model by deleting
--              the corresponding record in the dbo.ModelTags junction table.
--
-- Parameters:
--   @ModelID: The ID of the model.
--   @TagID:   The ID of the tag to remove from the model.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. A required ID was NULL.
--   2: Not Found. The specified link between the model and tag does not exist.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.RemoveTagFromModel
    @ModelID INT,
    @TagID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL OR @TagID IS NULL
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the link to be deleted actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.ModelTags WHERE ModelID = @ModelID AND TagID = @TagID)
    BEGIN
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        DELETE FROM dbo.ModelTags
        WHERE ModelID = @ModelID
          AND TagID = @TagID;

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