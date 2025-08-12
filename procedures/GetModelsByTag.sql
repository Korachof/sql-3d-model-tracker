-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a paginated and sorted list of models for a specific tag.
--
-- Parameters:
--   @TagID:         The ID of the tag to search for.
--   @SortBy:        (Optional) The column to sort by ('ModelID', 'ModelName', 'LicenseType'). Default is 'ModelName'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'ASC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50.
--
-- Returns:
--   A result set containing a single page of models for the specified tag.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @TagID was NULL.
--   2: Not Found. The provided @TagID does not exist in dbo.Tags.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetModelsByTag
    @TagID INT,
    @SortBy NVARCHAR(100) = 'ModelName',
    @SortDirection NVARCHAR(4) = 'ASC',
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
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

-- ===================================================================
-- 2. HANDLE SORTING AND PREVENT SQL INJECTION
-- ===================================================================
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @OrderByString NVARCHAR(200);

    -- Build the ORDER BY clause safely
    SET @OrderByString =
        CASE @SortBy
            WHEN 'ModelID' THEN 'm.ModelID'
            WHEN 'ModelName' THEN 'm.ModelName'
            WHEN 'LicenseType' THEN 'm.LicenseType'
            ELSE 'm.ModelName' -- Default sort column
        END +
        CASE WHEN @SortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 3. HANDLE MAIN OPERATION BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @SQL = N'
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
            mt.TagID = @TagID_Param
        ORDER BY ' + @OrderByString +
        N' OFFSET (@PageNumber_Param - 1) * @PageSize_Param ROWS
        FETCH NEXT @PageSize_Param ROWS ONLY;';

-- ===================================================================
-- 4. EXECUTE THE DYNAMIC QUERY
-- ===================================================================
    EXEC sp_executesql
        @SQL,
        N'@TagID_Param INT, @PageNumber_Param INT, @PageSize_Param INT',
        @TagID_Param = @TagID,
        @PageNumber_Param = @PageNumber,
        @PageSize_Param = @PageSize;
END
GO