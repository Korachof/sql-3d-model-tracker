-- =============================================
-- Procedure Name: add_tag
-- Purpose: Adds a new tag to the Tags table, or retrieves an existing tag's ID.
-- Usage: Called to ensure a tag exists and to get its tag_id for linking.
-- Parameters:
--   @TagName        NVARCHAR(100)  -- The name of the tag to add or retrieve.
-- Returns: The tag_id (INT) of the newly created or existing tag.
-- =============================================

CREATE OR ALTER PROCEDURE AddTag
    @TagName NVARCHAR(100)
AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

    DECLARE @TagID INT;

     -- Validate @TagName
    IF @TagName IS NULL OR LTRIM(RTRIM(@TagName)) = ''
    BEGIN
        RAISERROR('Error: Tag name cannot be empty.', 16, 1);
        RETURN -101; -- Consistent: Missing/Invalid Required String Input
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