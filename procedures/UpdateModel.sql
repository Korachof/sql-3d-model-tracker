-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-07
-- Description: Updates the details for an existing model.
--
-- Parameters:
--   @ModelID:          The ID of the model to update.
--   @ModelName:        The new name for the model.
--   @SourceURL:        The new source URL for the model.
--   @LicenseType:      The new license type for the model.
--   @ModelDescription: The new description for the model.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--   2: Not Found. The provided @ModelID does not exist in dbo.Models.
--   3: Unique Constraint Violation. The new @SourceURL already exists for another model.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.UpdateModel
    @ModelID INT,
    @ModelName NVARCHAR(255),
    @SourceURL NVARCHAR(450),
    @LicenseType NVARCHAR(100) = NULL,
    @ModelDescription NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
        OR @ModelName IS NULL OR LTRIM(RTRIM(@ModelName)) = ''
        OR @SourceURL IS NULL OR LTRIM(RTRIM(@SourceURL)) = ''
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        RETURN 2; -- Not Found
    END

    -- Check if the new SourceURL is already in use by a DIFFERENT model
    IF EXISTS (SELECT 1 FROM dbo.Models WHERE SourceURL = @SourceURL AND ModelID <> @ModelID)
    BEGIN
        RETURN 3; -- Unique Constraint Violation
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        UPDATE dbo.Models
        SET
            ModelName = @ModelName,
            SourceURL = @SourceURL,
            LicenseType = @LicenseType,
            ModelDescription = @ModelDescription
        WHERE
            ModelID = @ModelID;

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