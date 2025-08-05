-- =============================================
-- Author: Chris Partin
-- Procedure Name: add_model
-- Description: Inserts a new 3D model into the Models table
--              Called when importing or manually adding model metadata
-- Outputs:     The ID of the new or existing model.
-- Parameters:
--   @name                  NVARCHAR(255)     -- Display name of the model
--   @source_url            NVARCHAR(MAX)     -- Link to model source (e.g., Thingiverse)
--   @license_type          NVARCHAR(100)     -- License classification (e.g., Creative Commons)
--   @model_description     NVARCHAR(MAX)     -- Optional model notes or summary
-- Returns:
--                          0 = Success
--                          1 = Validation Failed: Tag name was NULL/empty
--                              --   Set TagID to NULL
-- THROWS:                  For unexpected failures/errors
--      Sends the original, detailed error message from SQL server to calling app
-- =============================================

CREATE OR ALTER PROCEDURE dbo.AddModel
    @ModelName NVARCHAR(255),
    @SourceURL NVARCHAR(MAX),
    @LicenseType NVARCHAR(100) = NULL, -- Optional parameter
    @ModelDescription NVARCHAR(MAX) = NULL, -- Optional parameter
    @ModelID INT OUTPUT

AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    -- LTRIM(RTRIM) first removes all trailing spaces, then all leading spaces
    IF @ModelName IS NULL OR LTRIM(RTRIM(@ModelName)) = '' 
    OR @SourceURL IS NULL OR LTRIM(RTRIM(@SourceURL)) = ''
    BEGIN
        -- Set output parameter to a known safe state before exiting
        SET @ModelID = NULL;
        -- Missing/Invalid Required String Input (Model name/Source URL is NULL/Empty)
        RETURN 1;
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        -- Initialize @ModelID to NULL to because SELECT
        -- doesn't change the variable if no row is found.
        SET @ModelID = NULL;

        -- Check if a model with this SourceURL already exists.
        SELECT @ModelID = ModelID
        FROM dbo.Models
        WHERE SourceURL = @SourceURL;

        -- If @ModelID is still NULL, the model does not exist, so insert it.
        IF @ModelID IS NULL
        BEGIN
            -- Add new rows into the table
            INSERT INTO dbo.Models (
                ModelName,
                SourceURL,
                LicenseType,
                ModelDescription
            )

            -- Provide new data for the new rows
            VALUES (
                @ModelName,
                @SourceURL,
                @LicenseType,
                @ModelDescription
            );

            -- Get the new models ID  and set it to the Output Parameter
            SET @ModelID = SCOPE_IDENTITY();
        END
        -- Return 0 for success!
        RETURN 0;
    
    END TRY

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    BEGIN CATCH
        -- Take original, detailed error and pass it up to calling app
        THROW;
    END CATCH

END;
GO
