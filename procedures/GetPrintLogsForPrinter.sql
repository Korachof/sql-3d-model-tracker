-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a paginated and sorted list of print logs for a
--              specific printer.
--
-- Parameters:
--   @PrinterID:     The ID of the printer to retrieve logs for.
--   @SortBy:        (Optional) The column to sort by. Default is 'PrintStartDateTime'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'DESC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50.
--
-- Returns:
--   A result set containing a single page of print logs for the specified printer.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @PrinterID was NULL.
--   2: Not Found. The provided @PrinterID does not exist in dbo.Printers.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrintLogsForPrinter
    @PrinterID INT,
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
    IF @PrinterID IS NULL
    BEGIN
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 1; -- Validation Failed
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Printers WHERE PrinterID = @PrinterID)
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
            WHEN 'ModelID' THEN 'pl.ModelID'
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
            pl.ModelID,
            m.ModelName,
            pl.PrintStartDateTime,
            pl.PrintEndDateTime,
            pl.MaterialUsed,
            pl.PrintStatus,
            pl.PrintStatusDetails
        FROM
            dbo.PrintLog AS pl
        JOIN
            dbo.Models AS m ON pl.ModelID = m.ModelID
        WHERE
            pl.PrinterID = @PrinterID_Param
        ORDER BY ' + @OrderByString +
        N' OFFSET (@PageNumber_Param - 1) * @PageSize_Param ROWS
        FETCH NEXT @PageSize_Param ROWS ONLY;';

-- ===================================================================
-- 4. EXECUTE THE DYNAMIC QUERY
-- ===================================================================
    EXEC sp_executesql
        @SQL,
        N'@PrinterID_Param INT, @PageNumber_Param INT, @PageSize_Param INT',
        @PrinterID_Param = @PrinterID,
        @PageNumber_Param = @PageNumber,
        @PageSize_Param = @PageSize;
END
GO