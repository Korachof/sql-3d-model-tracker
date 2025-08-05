-- =============================================
-- Author:      Chris Partin
-- Procedure Name: AssignTagToModel
-- Create date: 2025-08-05
-- Description: Assigns a tag to a model by creating a record in the
--              dbo.ModelTags junction table.
-- Outputs:    
-- Parameters:
--   @ModelID: The ID of the model to be tagged.
--   @TagID:   The ID of the tag to assign.
--
-- Returns:
--   0: Success. The link was created or already existed.
--   1: Validation Failed. A required ID was NULL.
--   2: Foreign Key Violation. The provided @ModelID does not exist.
--   3: Foreign Key Violation. The provided @TagID does not exist.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================

CREATE OR ALTER PROCEDURE dbo.AssignTagToModel
    -- Required Parameters
    @ModelID INT,
    @TagID INT
AS
BEGIN
/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================

IF @ModelID IS NULL OR @TagID IS NULL
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists in the Models table
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        RETURN 2; -- Foreign Key Violation for ModelID
    END

    -- Check if the provided TagID actually exists in the Tags table
    IF NOT EXISTS (SELECT 1 FROM dbo.Tags WHERE TagID = @TagID)
    BEGIN
        RETURN 3; -- Foreign Key Violation for TagID
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================

    BEGIN TRY
        -- Check if this link already exists. If not, insert it.
        IF NOT EXISTS (SELECT 1 FROM dbo.ModelTags WHERE ModelID = @ModelID AND TagID = @TagID)
        BEGIN
            INSERT INTO dbo.ModelTags (
                ModelID,
                TagID
            )
            VALUES (
                @ModelID,
                @TagID
            );
        END

        RETURN 0; -- Success (either created or already existed)
    END TRY

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================

BEGIN CATCH
        -- Re-throws the original, detailed error to the calling application.
        THROW;
    END CATCH
END
GO