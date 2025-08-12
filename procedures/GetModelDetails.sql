-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-07
-- Description: Retrieves all details for a single model, including paginated
--              and sorted lists of its tags and print history.
--
-- Parameters:
--   @ModelID:               The ID of the model to retrieve details for.
--   @TagSortBy:             (Optional) Column to sort tags by ('TagID', 'TagName').
--   @TagSortDirection:      (Optional) Sort direction for tags ('ASC' or 'DESC').
--   @TagPageNumber:         (Optional) Page number for tags.
--   @TagPageSize:           (Optional) Page size for tags.
--   @PrintLogSortBy:        (Optional) Column to sort print logs by.
--   @PrintLogSortDirection: (Optional) Sort direction for print logs.
--   @PrintLogPageNumber:    (Optional) Page number for print logs.
--   @PrintLogPageSize:      (Optional) Page size for print logs.
--
-- Returns:
--   1. Result Set 1: The core model details.
--   2. Result Set 2: A paginated list of assigned tags.
--   3. Result Set 3: A paginated print history.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetModelDetails
    @ModelID INT,
    @TagSortBy NVARCHAR(100) = 'TagName',
    @TagSortDirection NVARCHAR(4) = 'ASC',
    @TagPageNumber INT = 1,
    @TagPageSize INT = 50,
    @PrintLogSortBy NVARCHAR(100) = 'PrintStartDateTime',
    @PrintLogSortDirection NVARCHAR(4) = 'DESC',
    @PrintLogPageNumber INT = 1,
    @PrintLogPageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
    BEGIN
        -- Return empty structures for all three expected result sets
        SELECT TOP (0) * FROM dbo.Models;
        SELECT TOP (0) * FROM dbo.Tags;
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        SELECT TOP (0) * FROM dbo.Models;
        SELECT TOP (0) * FROM dbo.Tags;
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE CORE MODEL DETAILS - SINGLE ROW
-- ===================================================================
    SELECT * FROM dbo.Models WHERE ModelID = @ModelID;

-- ===================================================================
-- 3. HANDLE ASSIGNED TAGS SORTING AND PREVENT SQL INJECTION
-- ===================================================================
    DECLARE @TagSQL NVARCHAR(MAX), @TagOrderByClause NVARCHAR(200);
    SET @TagOrderByClause =
        CASE @TagSortBy
            WHEN 'TagID'
            THEN 'Tags.TagID'
            ELSE 'Tags.TagName'
        END +
        CASE WHEN @TagSortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 4. HANDLE ASSIGNED TAGS BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @TagSQL = N'
        SELECT Tags.TagID, Tags.TagName
        FROM dbo.Tags AS Tags -- More readable alias
        JOIN dbo.ModelTags AS ModelTags ON Tags.TagID = ModelTags.TagID
        WHERE ModelTags.ModelID = @ModelID_Param
        ORDER BY ' + @TagOrderByClause +
        N' OFFSET (@PageNumber_Param - 1) * @PageSize_Param ROWS
        FETCH NEXT @PageSize_Param ROWS ONLY;';

-- ===================================================================
-- 5. EXECUTE THE ASSIGNED TAGS DYNAMIC QUERY
-- ===================================================================
    EXEC sp_executesql @TagSQL,
    N'@ModelID_Param INT, @PageNumber_Param INT, @PageSize_Param INT',
    @ModelID_Param = @ModelID,
    @PageNumber_Param = @TagPageNumber,
    @PageSize_Param = @TagPageSize;

-- ===================================================================
-- 6. HANDLE PRINTLOG SORTING AND PREVENT SQL INJECTION
-- ===================================================================
    DECLARE @PrintLogSQL NVARCHAR(MAX), @PrintLogOrderByClause NVARCHAR(200);
    SET @PrintLogOrderByClause =
        CASE @PrintLogSortBy
            WHEN 'PrintID' THEN 'PrintLog.PrintID'
            WHEN 'PrintStartDateTime' THEN 'PrintLog.PrintStartDateTime'
            WHEN 'MaterialUsed' THEN 'PrintLog.MaterialUsed'
            WHEN 'PrintStatus' THEN 'PrintLog.PrintStatus'
            ELSE 'PrintLog.PrintStartDateTime'
        END +
        CASE WHEN @PrintLogSortDirection = 'DESC' THEN ' DESC' ELSE ' ASC' END;

-- ===================================================================
-- 7. HANDLE ASSIGNED TAGS BY BUILDING DYNAMIC QUERY STRING
-- ===================================================================
    SET @PrintLogSQL = N'
        SELECT PrintLog.PrintID, Printers.PrinterBrand, Printers.PrinterModelName, PrintLog.PrintStartDateTime, PrintLog.PrintEndDateTime, PrintLog.MaterialUsed, PrintLog.PrintStatus, PrintLog.PrintStatusDetails
        FROM dbo.PrintLog AS PrintLog -- More readable alias
        JOIN dbo.Printers AS Printers ON PrintLog.PrinterID = Printers.PrinterID
        WHERE PrintLog.ModelID = @ModelID_Param
        ORDER BY ' + @PrintLogOrderByClause +
        N' OFFSET (@PageNumber_Param - 1) * @PageSize_Param ROWS
        FETCH NEXT @PageSize_Param ROWS ONLY;';

-- ===================================================================
-- 8. EXECUTE THE PRINTLOG DYNAMIC QUERY
-- ===================================================================
    EXEC sp_executesql
    @PrintLogSQL,
    N'@ModelID_Param INT, @PageNumber_Param INT, @PageSize_Param INT',
    @ModelID_Param = @ModelID,
    @PageNumber_Param = @PrintLogPageNumber,
    @PageSize_Param = @PrintLogPageSize;

END
GO