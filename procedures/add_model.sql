USE ThreeDModelTrackerDB;
GO

-- =============================================
-- Procedure Name: add_model
-- Purpose: Inserts a new 3D model into the Models table
-- Usage: Called when importing or manually adding model metadata
-- Parameters:
--   @name              NVARCHAR(255)     -- Display name of the model
--   @source_url        NVARCHAR(MAX)     -- Link to model source (e.g., Thingiverse)
--   @license_type      NVARCHAR(100)     -- License classification (e.g., Creative Commons)
--   @model_description       NVARCHAR(MAX)     -- Optional model notes or summary
-- Returns: Newly inserted Model ID (INT)
-- =============================================

CREATE OR ALTER PROCEDURE AddModel
    @ModelName NVARCHAR(255),
    @SourceURL NVARCHAR(MAX),
    @LicenseType NVARCHAR(100) = NULL, -- Optional parameter
    @ModelDescription NVARCHAR(MAX) = NULL -- Optional parameter

AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

    -- Validation/Error Handling for NOT NULL columns

    -- LTRIM(RTRIM) first removes all trailing spaces, then all leading spaces
    IF @ModelName IS NULL OR LTRIM(RTRIM(@ModelName)) = ''
        BEGIN
            RAISERROR('Model name cannot be empty.', 16, 1);
            RETURN -1; -- Set -1 for naming issue
        END

    IF @SourceURL IS NULL OR LTRIM(RTRIM(@SourceURL)) = ''
    BEGIN
        RAISERROR('Source URL cannot be empty.', 16, 1);
        RETURN -2;
    END

    -- Add new rows into the table
    INSERT INTO Models (
        model_name,
        source_url,
        license_type,
        model_description
    )
    
    -- Provide new data for the new rows
    VALUES (
        @ModelName,
        @SourceURL,
        @LicenseType,
        @ModelDescription
    );

    -- Return the newly added model's id
    SELECT SCOPE_IDENTITY() AS NewModelID;

END;
GO
