-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-05
-- Description: Retrieves a paginated and sorted list models.
--
-- Parameters:
--   @SortBy:        (Optional) The column to sort by. Default is 'ModelName'.
--   @SortDirection: (Optional) The sort direction ('ASC' or 'DESC'). Default is 'ASC'.
--   @PageNumber:    (Optional) The page number to retrieve. Default is 1.
--   @PageSize:      (Optional) The number of items per page. Default is 50. 
--
-- Returns:
--   A result set containing all columns for all models.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetModels
    -- Optional parameters
    @SortBy NVARCHAR(100) = 'ModelName',
    @SortDirection NVARCHAR(4) = 'ASC',
    @PageNumber INT = 1,
    @PageSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE THE MAIN OPERATION
-- ===================================================================
    -- This procedure simply selects all data from the Models table.
    -- TODO: add parameters here for searching, sorting, and pagination.
    SELECT
        ModelID,
        ModelName,
        SourceURL,
        LicenseType,
        ModelDescription
    FROM
        dbo.Models

-- ===================================================================
-- 2. HANDLE SORTING
-- ===================================================================
    ORDER BY
        -- Dynamic Sorting Logic
        CASE WHEN @SortDirection = 'ASC' THEN
            CASE @SortBy
                WHEN 'ModelID' THEN CAST(ModelID AS NVARCHAR(MAX))
                WHEN 'ModelName' THEN ModelName
                WHEN 'LicenseType' THEN LicenseType
                ELSE ModelName
            END
        END ASC,
        CASE WHEN @SortDirection = 'DESC' THEN
            CASE @SortBy
                WHEN 'ModelID' THEN CAST(ModelID AS NVARCHAR(MAX))
                WHEN 'ModelName' THEN ModelName
                WHEN 'LicenseType' THEN LicenseType
                ELSE ModelName
            END
        END DESC;

-- ===================================================================
-- 3. HANDLE PAGINATION
-- ===================================================================
    -- Determine the starting point of pagination.
    -- If PageNumber = 3 and PageSize = 50, then we skip the first 2*50 (100) records
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    -- After skipping, provide the next number via PageSize.
    FETCH NEXT @PageSize ROWS ONLY;

END
GO