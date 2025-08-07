-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a list of all tags from the dbo.Tags table.
--
-- Parameters:
--   None
--
-- Returns:
--   A result set containing all columns for all tags.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetTags
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    -- Selects all data from the Tags table, ordered alphabetically.
    SELECT
        TagID,
        TagName
    FROM
        dbo.Tags
    ORDER BY
        TagName ASC;

END
GO
