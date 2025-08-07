-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-06
-- Description: Retrieves a list of all print logs from the dbo.PrintLog table,
--              ordered with the most recent prints first.
--
-- Parameters:
--   None
--
-- Returns:
--   A result set containing all columns for all print logs.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetPrintLogs
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE THE MAIN OPERATION
-- ===================================================================
    SELECT
        PrintID,
        ModelID,
        PrinterID,
        PrintStartDateTime,
        PrintEndDateTime,
        MaterialUsed,
        PrintStatus,
        PrintStatusDetails
    FROM
        dbo.PrintLog
    ORDER BY
        PrintStartDateTime DESC; -- Show the most recent prints first

END
GO