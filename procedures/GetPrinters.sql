-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a list of all printers from the dbo.Printers table.
--
-- Parameters:
--   None
--
-- Returns:
--   A result set containing all columns for all printers.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrinters
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE THE MAIN OPERATION
-- ===================================================================
    -- Selects all data from the Printers table.
    -- The results are ordered by Brand, then by Model Name for a predictable sort.
    SELECT
        PrinterID,
        PrinterBrand,
        PrinterModelName,
        PrinterMaterialType
    FROM
        dbo.Printers
    ORDER BY
        PrinterBrand ASC,
        PrinterModelName ASC;

END
GO