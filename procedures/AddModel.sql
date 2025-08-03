-- =============================================
-- Procedure Name: add_model
-- Purpose: Inserts a new 3D model into the Models table
-- Usage: Called when importing or manually adding model metadata
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
    @ModelDescription NVARCHAR(MAX) = NULL -- Optional parameter
    @ModelID INT OUTPUT

AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

    -- Validation/Error Handling for NOT NULL columns

    -- LTRIM(RTRIM) first removes all trailing spaces, then all leading spaces
    IF @ModelName IS NULL OR LTRIM(RTRIM(@ModelName)) = ''
        BEGIN
            -- Set output parameter to a known safe state before exiting
            SET @ModelID = NULL;
            -- Missing/Invalid Required String Input (Model name is NULL/Empty)
            RETURN 1;
        END

    IF @SourceURL IS NULL OR LTRIM(RTRIM(@SourceURL)) = ''
    BEGIN
        -- Set output parameter to a known safe state before exiting
            SET @ModelID = NULL;
            -- Missing/Invalid Required String Input (Model name is NULL/Empty)
            RETURN 1;
    END

    BEGIN TRY
        -- Insert a new model into the Models Table

        -- Add new rows into the table
        INSERT INTO Models (
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
        SET SCOPE_IDENTITY() AS NewModelID;

        -- Return 0 for success!
        RETURN 0;
    
    END TRY
    -- Unexpected Error Occured: Catch
    BEGIN CATCH
        -- Take original, detailed error and pass it up to calling app
        THROW;
    END CATCH

END;
GO
