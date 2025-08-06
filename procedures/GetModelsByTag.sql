-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves all models associated with a specific tag.
--
-- Parameters:
--   @TagID: The ID of the tag to search for.
--
-- Returns:
--   A result set containing all models assigned the specified tag.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @TagID was NULL.
--   2: Not Found. The provided @TagID does not exist in dbo.Tags.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetModelsByTag
    @TagID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. HANDLE PREDICTABLE OUTCOMES (Validation)
    IF @TagID IS NULL
    BEGIN
        -- Return an empty result set with the correct structure
        SELECT TOP (0) * FROM dbo.Models;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided TagID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Tags WHERE TagID = @TagID)
    BEGIN
        SELECT TOP (0) * FROM dbo.Models;
        RETURN 2; -- Not Found
    END

    -- 2. HANDLE THE MAIN OPERATION
    SELECT
        m.ModelID,
        m.ModelName,
        m.SourceURL,
        m.LicenseType,
        m.ModelDescription
    FROM
        dbo.Models AS m
    JOIN
        dbo.ModelTags AS mt ON m.ModelID = mt.ModelID
    WHERE
        mt.TagID = @TagID
    ORDER BY
        m.ModelName ASC;

    RETURN 0; -- Success

END
GO