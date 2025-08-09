-- =============================================
-- Author:      Chris
-- Create date: 2025-08-09
-- Description: Updates the details for an existing printer.
--
-- Parameters:
--   @PrinterID:          The ID of the printer to update.
--   @PrinterBrand:       The new brand for the printer.
--   @PrinterModelName:   The new model name for the printer.
--   @PrinterMaterialType: The new material type for the printer.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--   2: Not Found. The provided @PrinterID does not exist in dbo.Printers.
--   3: Unique Constraint Violation. The new Brand/Model combination already exists.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================
CREATE OR ALTER PROCEDURE dbo.UpdatePrinter
    @PrinterID INT,
    @PrinterBrand NVARCHAR(100),
    @PrinterModelName NVARCHAR(100),
    @PrinterMaterialType NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @PrinterID IS NULL
        OR @PrinterBrand IS NULL OR LTRIM(RTRIM(@PrinterBrand)) = ''
        OR @PrinterModelName IS NULL OR LTRIM(RTRIM(@PrinterModelName)) = ''
        OR @PrinterMaterialType IS NULL OR LTRIM(RTRIM(@PrinterMaterialType)) = ''
    BEGIN
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided PrinterID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Printers WHERE PrinterID = @PrinterID)
    BEGIN
        RETURN 2; -- Not Found
    END

    -- Check if the new Brand/Model combination is already in use by a DIFFERENT printer
    IF EXISTS (
        SELECT 1 FROM dbo.Printers
        WHERE PrinterBrand = @PrinterBrand
          AND PrinterModelName = @PrinterModelName
          AND PrinterID <> @PrinterID
    )
    BEGIN
        RETURN 3; -- Unique Constraint Violation
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        UPDATE dbo.Printers
        SET
            PrinterBrand = @PrinterBrand,
            PrinterModelName = @PrinterModelName,
            PrinterMaterialType = @PrinterMaterialType
        WHERE
            PrinterID = @PrinterID;

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