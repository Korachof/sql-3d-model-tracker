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
--              1 = Tag name was NULL/empty
--              50000 = An unexpected error occurred
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
        RETURN 1; -- Consistent: Missing/Invalid Required String Input
    END

    -- Check if the tag already exists
    SELECT @TagID = tag_id
    FROM Tags
    WHERE tag_name = @TagName;

    -- If tag does not exist, insert it
    IF @TagID IS NULL
    BEGIN
        INSERT INTO Tags (tag_name)
        VALUES (@TagName);

        SELECT @TagID = SCOPE_IDENTITY(); -- Get the ID of the newly inserted tag
    END

    -- Return the tag_id (either existing or newly created)
    SELECT @TagID AS TagID;
END;
GO