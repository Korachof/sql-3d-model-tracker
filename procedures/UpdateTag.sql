-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-09
-- Description: Updates the name for an existing tag.
--
-- Parameters:
--   @TagID:   The ID of the tag to update.
--   @TagName: The new name for the tag.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--   2: Not Found. The provided @TagID does not exist in dbo.Tags.
--   3: Unique Constraint Violation. The new @TagName already exists.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.UpdateTag
    @TagID INT,
    @TagName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @TagID IS NULL OR @TagName IS NULL OR LTRIM(RTRIM(@TagName)) = ''
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided TagID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Tags WHERE TagID = @TagID)
    BEGIN
        RETURN 2; -- Not Found
    END

    -- Check if the new TagName is already in use by a DIFFERENT tag
    IF EXISTS (SELECT 1 FROM dbo.Tags WHERE TagName = @TagName AND TagID <> @TagID)
    BEGIN
        RETURN 3; -- Unique Constraint Violation
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        UPDATE dbo.Tags
        SET
            TagName = @TagName
        WHERE
            TagID = @TagID;

        RETURN 0; -- Success

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