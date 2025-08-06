-- =============================================
-- Author:      Your Name
-- Create date: 2025-08-06
-- Description: Retrieves the print history for a specific model, ordered
--              with the most recent prints first.
--
-- Parameters:
--   @ModelID: The ID of the model to retrieve the print log for.
--
-- Returns:
--   A result set containing all print log entries for the specified model.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @ModelID was NULL.
--   2: Not Found. The provided @ModelID does not exist in dbo.Models.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrintLogsForModel
    @ModelID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. HANDLE PREDICTABLE OUTCOMES (Validation)
    IF @ModelID IS NULL
    BEGIN
        -- Return an empty result set with the correct structure
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 2; -- Not Found
    END

    -- 2. HANDLE THE MAIN OPERATION
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
        pl.ModelID = @ModelID
    ORDER BY
        pl.PrintStartDateTime DESC; -- Show the most recent prints first

    RETURN 0; -- Success

END
GO
