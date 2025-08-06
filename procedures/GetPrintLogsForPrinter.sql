-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves the print history for a specific printer, ordered
--              with the most recent prints first.
--
-- Parameters:
--   @PrinterID: The ID of the printer to retrieve the print log for.
--
-- Returns:
--   A result set containing all print log entries for the specified printer.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @PrinterID was NULL.
--   2: Not Found. The provided @PrinterID does not exist in dbo.Printers.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrintLogsForPrinter
    @PrinterID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. HANDLE PREDICTABLE OUTCOMES (Validation)
    IF @PrinterID IS NULL
    BEGIN
        -- Return an empty result set with the correct structure
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided PrinterID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Printers WHERE PrinterID = @PrinterID)
    BEGIN
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 2; -- Not Found
    END

    -- 2. HANDLE THE MAIN OPERATION
    SELECT
        pl.PrintID,
        pl.ModelID,
        m.ModelName, -- Joined to show the model name for context
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
        pl.PrinterID = @PrinterID
    ORDER BY
        pl.PrintStartDateTime DESC; -- Show the most recent prints first

    RETURN 0; -- Success

END
GO