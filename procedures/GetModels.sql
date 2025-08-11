-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-05
-- Description: Retrieves a list of all models from the dbo.Models table.
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
    ORDER BY
        ModelName ASC;

END
GO