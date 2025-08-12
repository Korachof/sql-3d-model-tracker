-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a paginated and sorted list of print logs using
--              Dynamic SQL.
--
-- Parameters:
--   @SortBy:        (Optional) The column to sort by. Default is 'PrintStartDateTime'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'DESC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50.
--
-- Returns:
--   A result set containing a single page of print logs.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrintLogs
    @SortBy NVARCHAR(100) = 'PrintStartDateTime',
    @SortDirection NVARCHAR(4) = 'DESC',
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @OrderByClause NVARCHAR(200);

-- ===================================================================
-- 1. HANDLE SORTING AND PREVENT SQL INJECTION
-- ===================================================================
    SET @OrderByClause =
        CASE @SortBy
            WHEN 'PrintID' THEN 'PrintID'
            WHEN 'ModelID' THEN 'ModelID'
            WHEN 'PrinterID' THEN 'PrinterID'
            WHEN 'PrintStartDateTime' THEN 'PrintStartDateTime'
            WHEN 'PrintEndDateTime' THEN 'PrintEndDateTime'
            WHEN 'MaterialUsed' THEN 'MaterialUsed'
            WHEN 'PrintStatus' THEN 'PrintStatus'
            ELSE 'PrintStartDateTime' -- Default sort column
        END +
        CASE WHEN @SortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 2. HANDLE MAIN OPERATION BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @SQL = N'
        SELECT
            PrintID,
            ModelID,
            PrinterID,
            PrintStartDateTime,
            PrintEndDateTime,
            MaterialUsed,
            PrintStatus,
            PrintStatusDetails
        FROM
            dbo.PrintLog
        ORDER BY' + @OrderByClause + 
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