-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves all tags assigned to a specific model.
--
-- Parameters:
--   @ModelID: The ID of the model to retrieve tags for.
--
-- Returns:
--   A result set containing the TagID and TagName for all assigned tags.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @ModelID was NULL.
--   2: Not Found. The provided @ModelID does not exist in dbo.Models.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetTagsForModel
    @ModelID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
    BEGIN
        -- You can't return a result set AND a return code, so we select an empty result set first.
        SELECT TOP (0) * FROM dbo.Tags;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        SELECT TOP (0) * FROM dbo.Tags;
        RETURN 2; -- ModelID Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    -- Select all tags linked to the given ModelID
    SELECT
        t.TagID,
        t.TagName
    FROM
        dbo.Tags AS t
    JOIN
        dbo.ModelTags AS mt ON t.TagID = mt.TagID
    WHERE
        mt.ModelID = @ModelID
    ORDER BY
        t.TagName ASC;

    RETURN 0; -- Success

END
GO