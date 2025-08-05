-- =============================================
-- Author:      Your Name
-- Create date: 2025-08-05
-- Description: Inserts a new printer if one with the same brand and model
--              name does not already exist. Returns the ID of the new or
--              existing printer.
-- Outputs:     The ID of the new or existing printer.
-- Parameters:
--   @PrinterBrand:       The brand of the printer (e.g., 'Elegoo', 'Bambu Lab').
--   @PrinterModelName:   The model name of the printer (e.g., 'Mars 4 Ultra', 'P1S').
--   @PrinterMaterialType: The technology of the printer (e.g., 'Resin', 'Filament').
--   @PrinterID:          OUTPUT parameter. Contains the resulting PrinterID.
--
-- Returns
--   0: Success.
--   1: Validation Failed. A required parameter was NULL or empty.
--
-- THROWS (for unexpected failures):
--   This procedure will re-throw any unexpected system-level exception.
-- =============================================

CREATE OR ALTER PROCEDURE dbo.AddPrinter
    -- Required Parameters
    @PrinterBrand NVARCHAR(100),
    @PrinterModelName NVARCHAR(100),
    @PrinterMaterialType NVARCHAR(50),
    -- Output Parameter
    @PrinterID INT OUTPUT
AS
BEGIN
/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @PrinterBrand IS NULL OR LTRIM(RTRIM(@PrinterBrand)) = ''
        OR @PrinterModelName IS NULL OR LTRIM(RTRIM(@PrinterModelName)) = ''
        OR @PrinterMaterialType IS NULL OR LTRIM(RTRIM(@PrinterMaterialType)) = ''
    BEGIN
        SET @PrinterID = NULL;
        RETURN 1; -- Validation Failed
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        -- Initialize @PrinterID to NULL to prevent bugs.
        SET @PrinterID = NULL;

        -- Check if a printer with this Brand and ModelName already exists.
        SELECT @PrinterID = PrinterID
        FROM dbo.Printers
        WHERE PrinterBrand = @PrinterBrand
          AND PrinterModelName = @PrinterModelName;

        -- If @PrinterID is still NULL, the printer does not exist, so insert it.
        IF @PrinterID IS NULL
        BEGIN
            INSERT INTO dbo.Printers (
                PrinterBrand,
                PrinterModelName,
                PrinterMaterialType
            )
            VALUES (
                @PrinterBrand,
                @PrinterModelName,
                @PrinterMaterialType
            );

            -- Get the ID of the row we just inserted.
            SET @PrinterID = SCOPE_IDENTITY();
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

