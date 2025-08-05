-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-05
-- Description: Retrieves a list of all models from the dbo.Models table.
--
-- Parameters:
--   None
--
-- Returns:
--   A result set containing all columns for all models.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetModels
AS
BEGIN
    SET NOCOUNT ON;

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