-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-07
-- Description: Retrieves all details for a single model, including its tags
--              and print history, by returning multiple result sets.
--
-- Parameters:
--   @ModelID: The ID of the model to retrieve details for.
--
-- Returns:
--   1. Result Set 1: The core model details from dbo.Models.
--   2. Result Set 2: A list of all tags assigned to the model.
--   3. Result Set 3: The complete print history for the model.
--
-- RETURN CODES (for predictable outcomes):
--   0: Success.
--   1: Validation Failed. The provided @ModelID was NULL.
--   2: Not Found. The provided @ModelID does not exist in dbo.Models.
--
-- =============================================
CREATE OR ALTER PROCEDURE dbo.GetModelDetails
    @ModelID INT
AS
BEGIN
    SET NOCOUNT ON;

-- ===================================================================
-- 1. HANDLE PREDICTABLE OUTCOMES
-- ===================================================================
    IF @ModelID IS NULL
    BEGIN
        -- Return empty structures for all three expected result sets
        SELECT TOP (0) * FROM dbo.Models;
        SELECT TOP (0) * FROM dbo.Tags;
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 1; -- Validation Failed
    END

    -- Check if the provided ModelID actually exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Models WHERE ModelID = @ModelID)
    BEGIN
        SELECT TOP (0) * FROM dbo.Models;
        SELECT TOP (0) * FROM dbo.Tags;
        SELECT TOP (0) * FROM dbo.PrintLog;
        RETURN 2; -- Not Found
    END

-- ===================================================================
-- 2. HANDLE THE MAIN OPERATION
-- ===================================================================
    -- Result Set 1: Core Model Details
    SELECT
        ModelID,
        ModelName,
        SourceURL,
        LicenseType,
        ModelDescription
    FROM
        dbo.Models
    WHERE
        ModelID = @ModelID;

    -- Result Set 2: Assigned Tags
    SELECT
        t.TagID,
        t.TagName
    FROM
        dbo.Tags AS t
    JOIN
        dbo.ModelTags AS mt ON t.TagID = mt.TagID
    WHERE
        mt.ModelID = @ModelID
    ORDER BY
        t.TagName ASC;

    -- Result Set 3: Print History
    SELECT
        pl.PrintID,
        pl.PrinterID,
        p.PrinterBrand,
        p.PrinterModelName,
        pl.PrintStartDateTime,
        pl.PrintEndDateTime,
        pl.MaterialUsed,
        pl.PrintStatus,
        pl.PrintStatusDetails
    FROM
        dbo.PrintLog AS pl
    JOIN
        dbo.Printers AS p ON pl.PrinterID = p.PrinterID
    WHERE
        pl.ModelID = @ModelID
    ORDER BY
        pl.PrintStartDateTime DESC;

    RETURN 0; -- Success

END
GO