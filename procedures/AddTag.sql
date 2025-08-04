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
--              --   Set TagID to NULL
-- THROWS:      For unexpected failures/errors
--      Sends the original, detailed error message from SQL server to calling app
-- =============================================

CREATE OR ALTER PROCEDURE dbo.AddTag
    -- Input paramenter for the tag's name
    @TagName NVARCHAR(100),
    -- Output parameter to send the new/existing TagID back to the caller
    @TagID INT OUTPUT
AS
BEGIN

/* Prevent unnecessary output and aid in performance
   (Supress default back messages) */ 
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @TagName IS NULL OR LTRIM(RTRIM(@TagName)) = ''
    BEGIN
        -- Set output parameter to a known safe state before exiting
        SET @TagID = NULL;
        -- Missing/Invalid Required String Input (Tag name is NULL/Empty)
        RETURN 1; 
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    BEGIN TRY
        -- Set TagID to NULL to reset from previous add
        SET @TagID = NULL;

        -- Check if the tag already exists
        SELECT @TagID = TagID
        FROM dbo.Tags
        WHERE TagName = @TagName;

    -- If tag does not exist, insert it
        IF @TagID IS NULL
        BEGIN
            INSERT INTO dbo.Tags (TagName)
            VALUES (@TagName);

            -- Get the new tag's ID  and set it to the Output Parameter
            SET @TagID = SCOPE_IDENTITY();
        END

        -- Success!!!
        RETURN 0;

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    END TRY
    -- Unexpected Error Occured: Catch
    BEGIN CATCH
        -- Take original, detailed error and pass it up to calling app
        THROW;
    END CATCH
END
GO