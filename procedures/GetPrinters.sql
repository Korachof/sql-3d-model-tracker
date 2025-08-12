-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a paginated and sorted list of printers using
--              Dynamic SQL.
--
-- Parameters:
--   @SortBy:        (Optional) The column to sort by ('PrinterID', 'PrinterBrand', 'PrinterModelName', 'PrinterMaterialType'). Default is 'PrinterBrand'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'ASC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50.
--
-- Returns:
--   A result set containing a single page of printers.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrinters
    -- Declare optional parameters
    @SortBy NVARCHAR(100) = 'PrinterBrand',
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
            WHEN 'PrinterID' THEN 'PrinterID'
            WHEN 'PrinterBrand' THEN 'PrinterBrand'
            WHEN 'PrinterModelName' THEN 'PrinterModelName'
            WHEN 'PrinterMaterialType' THEN 'PrinterMaterialType'
            ELSE 'PrinterBrand' -- Default sort column
        END +
        CASE WHEN @SortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 2. HANDLE MAIN OPERATION BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @SQL = N'
        SELECT
            PrinterID,
            PrinterBrand,
            PrinterModelName,
            PrinterMaterialType
        FROM
            dbo.Printers
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