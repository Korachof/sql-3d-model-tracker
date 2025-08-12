-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a paginated and sorted list of tags using
--              Dynamic SQL.
--
-- Parameters:
--   @SortBy:        (Optional) The column to sort by ('TagID', 'TagName'). Default is 'TagName'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'ASC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50.
--
-- Returns:
--   A result set containing a single page of tags.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetTags
    @SortBy NVARCHAR(100) = 'TagName',
    @SortDirection NVARCHAR(4) = 'ASC',
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variable for main query string
    DECLARE @SQL NVARCHAR(MAX);
    -- Declare variable for sort by parameters to prevent SQL injection
    DECLARE @OrderByString NVARCHAR(200);

-- ===================================================================
-- 1. HANDLE SORTING AND PREVENT SQL INJECTION
-- ===================================================================
    SET @OrderByString =
        CASE @SortBy
            WHEN 'TagID' THEN 'TagID'
            WHEN 'TagName' THEN 'TagName'
            ELSE 'TagName' -- Default sort column
        END +
        CASE WHEN @SortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 2. HANDLE MAIN OPERATION BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @SQL = N'
        SELECT
            TagID,
            TagName
        FROM
            dbo.Tags
        ORDER BY ' + @OrderByString + 
        N' OFFSET (@PageNumber_Param - 1) * @PageSize_Param ROWS
        FETCH NEXT @PageSize_Param ROWS ONLY;';

-- ===================================================================
-- 3. EXECUTE THE DYNAMIC QUERY
-- ===================================================================
    EXEC sp_executesql
        @SQL,
        N'@PageNumber_Param INT, @PageSize_Param INT',
        @PageNumber_Param = @PageNumber,
        @PageSize_Param = @PageSize;
END
GO