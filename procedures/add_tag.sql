-- =============================================
-- Author: Chris Partin
-- Procedure Name: add_tag
-- Description: Adds a new tag to the Tags table, or retrieves an existing tag's ID.
-- Outputs:     The ID of the new or existing tag.
-- Parameters:
--   @TagName   NVARCHAR(100)  -- The name of the tag to add or retrieve.
--   @TagID     INT PRIMARY KEY
-- Returns:
--              0 = Success
--              1 = Validation Failed: Tag name was NULL/empty
-- THROWS:      For unexpected failures/errors
--  Sends the original, detailed error message from SQL server to calling app
-- =============================================

CREATE OR ALTER PROCEDURE AddTag
    -- Input paramenter for the tag's name
    @TagName NVARCHAR(100)
    -- Output parameter to send the new/existing TagID back to the caller
    @TagID INT OUTPUT
AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

     -- Validate @TagName
    IF @TagName IS NULL OR LTRIM(RTRIM(@TagName)) = ''
    BEGIN
        RAISERROR('Error: Tag name cannot be empty.', 16, 1);
        RETURN 1; -- Missing/Invalid Required String Input
    END

    -- Begin transaction for data integrity
    BEGIN TRY

        -- Check if the tag already exists
        SELECT @TagID = TagID
        FROM dbo.Tags
        WHERE TagName = @TagName;

    -- If tag does not exist, insert it
        IF @TagID IS NULL
        BEGIN
            INSERT INTO dbo.Tags (TagName)
            VALUES (@TagName);

            -- Get ID of new tag and set
            SET @TagID = SCOPE_IDENTITY(); -- Get the ID of the newly inserted tag
        END

        -- Success!!!
        RETURN 0;
    
    END TRY
    -- Unexpected Error Occured: Catch
    BEGIN CATCH
        -- Take original, detailed error and pass it up to calling app
        THROW;
    END CATCH
END
GO