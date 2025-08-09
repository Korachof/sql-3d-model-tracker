-- =============================================
-- Author:      Chris
-- Create date: 2025-08-09
-- Description: Updates the details for an existing print log entry.
--
-- Parameters:
--   @PrintID:            The ID of the print log to update.
--   @ModelID:            The new ModelID for the print log.
--   @PrinterID:          The new PrinterID for the print log.
--   @PrintStartDateTime: The new start time for the print.
--   @PrintEndDateTime:   The new end time for the print.
--   @MaterialUsed:       The new material used.
--   @PrintStatus:        The new print status.
--   @PrintStatusDetails: The new status details.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--   2: Not Found. The provided @PrintID does not exist.
--   3: Foreign Key Violation. The new @ModelID does not exist.
--   4: Foreign Key Violation. The new @PrinterID does not exist.
--   5: Unique Constraint Violation. The new ModelID/StartDateTime combo already exists.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.UpdatePrintLog
    @PrintID INT,
    @ModelID INT,
    @PrinterID INT,
    @PrintStartDateTime DATETIME2(0),
    @PrintEndDateTime DATETIME2(0),
    @MaterialUsed NVARCHAR(100),
    @PrintStatus NVARCHAR(50),
    @PrintStatusDetails NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @PrintID IS NULL
        OR @ModelID IS NULL
        OR @PrinterID IS NULL
        OR @PrintStartDateTime IS NULL
        OR @PrintEndDateTime IS NULL
        OR @MaterialUsed IS NULL OR LTRIM(RTRIM(@MaterialUsed)) = ''
        OR @PrintStatus IS NULL OR LTRIM(RTRIM(@PrintStatus)) = ''
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided PrintID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.PrintLog WHERE PrintID = @PrintID)
    BEGIN
        RETURN 2; -- Not Found
    END

    -- Check if the new foreign keys exist
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        RETURN 3; -- FK Violation for ModelID
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Printers WHERE PrinterID = @PrinterID)
    BEGIN
        RETURN 4; -- FK Violation for PrinterID
    END

    -- Check if the new ModelID/StartDateTime combo is already in use by a DIFFERENT print log
    IF EXISTS (
        SELECT 1 FROM dbo.PrintLog
        WHERE ModelID = @ModelID
          AND PrintStartDateTime = @PrintStartDateTime
          AND PrintID <> @PrintID
    )
    BEGIN
        RETURN 5; -- Unique Constraint Violation
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        UPDATE dbo.PrintLog
        SET
            ModelID = @ModelID,
            PrinterID = @PrinterID,
            PrintStartDateTime = @PrintStartDateTime,
            PrintEndDateTime = @PrintEndDateTime,
            MaterialUsed = @MaterialUsed,
            PrintStatus = @PrintStatus,
            PrintStatusDetails = @PrintStatusDetails
        WHERE
            PrintID = @PrintID;

        RETURN 0; -- Success

    END TRY

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    BEGIN CATCH
        -- Re-throws the original, detailed error to the calling application.
        THROW;
    END CATCH
END
GO