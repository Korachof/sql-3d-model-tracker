-- =============================================
-- Author:      Your Name
-- Create date: 2025-08-04
-- Description: Logs a 3D print job. If a log for the same model and start
--              time already exists, it returns the existing PrintID.
-- Outputs:     The ID of the new or Model Print Record
-- Parameters:
--   @ModelID:            The ID of the model that was printed.
--   @PrinterID:          The ID of the printer used for the print.
--   @PrintStartDateTime: The precise date and time the print started.
--   @PrintEndDateTime:   The precise date and time the print ended.
--   @MaterialUsed:       The material used for the print.
--   @PrintStatus:        The outcome of the print (e.g., Success, Failed).
--   @PrintStatusDetails: (Optional) Additional details about the print status.
--   @PrintID:            OUTPUT parameter. Contains the new or existing PrintID.
--
-- Returns:
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--   2: Foreign Key Violation. The provided @ModelID does not exist in dbo.Models.
--   3: Foreign Key Violation. The provided @PrinterID does not exist.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.RecordModelPrint
    -- Required Parameters
    @ModelID INT,
    @PrinterID INT,
    @PrintStartDateTime DATETIME2(0),
    @PrintEndDateTime DATETIME2(0),
    @MaterialUsed NVARCHAR(100),
    @PrintStatus NVARCHAR(50),
    -- Optional Parameter
    @PrintStatusDetails NVARCHAR(MAX) = NULL,
    -- Output Parameter
    @PrintID INT OUTPUT
AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
        OR @PrintStartDateTime IS NULL
        OR @PrintEndDateTime IS NULL
        OR @MaterialUsed IS NULL OR LTRIM(RTRIM(@MaterialUsed)) = ''
        OR @PrintStatus IS NULL OR LTRIM(RTRIM(@PrintStatus)) = ''
    BEGIN
        SET @PrintID = NULL;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists in the Models table
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        SET @PrintID = NULL;
        RETURN 2; -- Foreign Key Violation
    END

    -- Check if the provided PrinterID actually exists in the Printers table
    IF NOT EXISTS (SELECT 1 FROM dbo.Printers WHERE PrinterID = @PrinterID)
    BEGIN
        SET @PrintID = NULL;
        RETURN 3; -- Foreign Key Violation for PrinterID
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        -- Initialize @PrintID to NULL to prevent bugs.
        SET @PrintID = NULL;

        -- Check if a print log with this ModelID and StartDateTime already exists.
        SELECT @PrintID = PrintID
        FROM dbo.PrintLog
        WHERE ModelID = @ModelID
          AND PrintStartDateTime = @PrintStartDateTime;

        -- If @PrintID is still NULL, the log does not exist, so insert it.
        IF @PrintID IS NULL
        BEGIN
            INSERT INTO dbo.PrintLog (
                ModelID,
                PrinterID,
                PrintStartDateTime,
                PrintEndDateTime,
                MaterialUsed,
                PrintStatus,
                PrintStatusDetails
            )
            VALUES (
                @ModelID,
                @PrinterID,
                @PrintStartDateTime,
                @PrintEndDateTime,
                @MaterialUsed,
                @PrintStatus,
                @PrintStatusDetails
            );

            -- Get the ID of the row we just inserted.
            SET @PrintID = SCOPE_IDENTITY();
        END

        RETURN 0; -- Success

    END TRY

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    BEGIN CATCH
        -- Take original, detailed error and pass it up to calling app
        THROW;
    END CATCH
END
GO