-- =============================================
-- Author:      Your Name
-- Create date: 2025-08-04
-- Description: Logs a 3D print job entry in the PrintLog table 
-- Outputs:     The ID of the new or existing tag.
-- Parameters:
--   @ModelID:            The ID of the model that was printed.
--   @MaterialUsed:       The material used for the print (e.g., PLA, PETG).
--   @PrintStatus:        The outcome of the print (e.g., Success, Failed).
--   @PrintDate:          The date the print job was run.
--   @DurationMinutes:    The duration of the print in minutes.
--   @PrintStatusDetails: (Optional) Additional details about the print status.
--   @PrintID:            OUTPUT parameter. Contains the new PrintID on success.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--   2: Foreign Key Violation. The provided @ModelID does not exist in dbo.Models.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.RecordModelPrint
    -- Required Parameters
    @RequestID UNIQUEIDENTIFIER,
    @ModelID INT,
    @MaterialUsed NVARCHAR(100),
    @PrintStatus NVARCHAR(50),
    @PrintDate DATE,
    @DurationMinutes INT,
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
    IF @RequestID is NULL
        OR @ModelID IS NULL
        OR @MaterialUsed IS NULL OR LTRIM(RTRIM(@MaterialUsed)) = ''
        OR @PrintStatus IS NULL OR LTRIM(RTRIM(@PrintStatus)) = ''
        OR @PrintDate IS NULL
        OR @DurationMinutes IS NULL
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

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        -- Initialize @PrintID to NULL to prevent bugs.
        SET @PrintID = NULL;

        -- Check if a print log with this RequestID already exists.
        SELECT @PrintID = PrintID
        FROM dbo.PrintLog
        WHERE RequestID = @RequestID;

        -- If @PrintID is still NULL, the log does not exist, so insert it.
        IF @PrintID IS NULL
        BEGIN
            INSERT INTO dbo.PrintLog (
                RequestID,
                ModelID,
                MaterialUsed,
                PrintStatus,
                PrintStatusDetails,
                PrintDate,
                DurationMinutes
            )
            VALUES (
                @RequestID,
                @ModelID,
                @MaterialUsed,
                @PrintStatus,
                @PrintStatusDetails,
                @PrintDate,
                @DurationMinutes
            );

            -- Get the ID of the row we just inserted.
            SET @PrintID = SCOPE_IDENTITY();
        END

        RETURN 0; -- Success

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    END TRY
    -- Unexpected Error Occured: Catch
    BEGIN CATCH
        -- Take original, detailed error and pass it up to calling app
        THROW;
    END CATCH
END
GO