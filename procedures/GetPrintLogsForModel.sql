-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a paginated and sorted list of print logs for a
--              specific model.
--
-- Parameters:
--   @ModelID:       The ID of the model to retrieve logs for.
--   @SortBy:        (Optional) The column to sort by. Default is 'PrintStartDateTime'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'DESC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50.
--
-- Returns:
--   A result set containing a single page of print logs for the specified model.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @ModelID was NULL.
--   2: Not Found. The provided @ModelID does not exist in dbo.Models.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrintLogsForModel
    @ModelID INT,
    @SortBy NVARCHAR(100) = 'PrintStartDateTime',
    @SortDirection NVARCHAR(4) = 'DESC',
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
    BEGIN
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 1; -- Validation Failed
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        SELECT TOP (0) * FROM dbo.PrintLog;
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
            WHEN 'PrintID' THEN 'pl.PrintID'
            WHEN 'PrintStartDateTime' THEN 'pl.PrintStartDateTime'
            WHEN 'PrintEndDateTime' THEN 'pl.PrintEndDateTime'
            WHEN 'MaterialUsed' THEN 'pl.MaterialUsed'
            WHEN 'PrintStatus' THEN 'pl.PrintStatus'
            ELSE 'pl.PrintStartDateTime' -- Default sort column
        END +
        CASE WHEN @SortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 3. HANDLE MAIN OPERATION BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @SQL = N'
        SELECT
            pl.PrintID,
            pl.PrinterID,
            p.PrinterBrand,
            p.PrinterModelName,
            pl.PrintStartDateTime,
            pl.PrintEndDateTime,
            pl.MaterialUsed,
            pl.PrintStatus,
            pl.PrintStatusDetails
        FROM
            dbo.PrintLog AS pl
        JOIN
            dbo.Printers AS p ON pl.PrinterID = p.PrinterID
        WHERE
            pl.ModelID = @ModelID_Param
        ORDER BY ' + @OrderByString +
        N' OFFSET (@PageNumber_Param - 1) * @PageSize_Param ROWS
        FETCH NEXT @PageSize_Param ROWS ONLY;';

-- ===================================================================
-- 4. EXECUTE THE DYNAMIC QUERY
-- ===================================================================
    EXEC sp_executesql
        @SQL,
        N'@ModelID_Param INT, @PageNumber_Param INT, @PageSize_Param INT',
        @ModelID_Param = @ModelID,
        @PageNumber_Param = @PageNumber,
        @PageSize_Param = @PageSize;
END
GO

