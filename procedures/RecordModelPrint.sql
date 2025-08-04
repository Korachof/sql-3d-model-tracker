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
    SET NOCOUNT ON;

    -- 1. HANDLE PREDICTABLE OUTCOMES (Validation)
    IF @ModelID IS NULL
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

    -- 2. HANDLE THE MAIN OPERATION
    BEGIN TRY
        INSERT INTO dbo.PrintLog (
            ModelID,
            MaterialUsed,
            PrintStatus,
            PrintStatusDetails,
            PrintDate,
            DurationMinutes
        )
        VALUES (
            @ModelID,
            @MaterialUsed,
            @PrintStatus,
            @PrintStatusDetails,
            @PrintDate,
            @DurationMinutes
        );

        -- Get the ID of the row we just inserted.
        SET @PrintID = SCOPE_IDENTITY();

        RETURN 0; -- Success

    END TRY
    BEGIN CATCH
        -- Re-throws the original, detailed error to the calling application.
        THROW;
    END CATCH
END
GO