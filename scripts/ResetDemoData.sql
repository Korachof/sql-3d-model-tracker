-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-14
-- Description: Wipes all data from the database and seeds it with a
--              curated set of sample data for demonstration purposes.
-- =============================================

CREATE OR ALTER PROCEDURE dbo.ResetDemoData
AS
BEGIN
    SET NOCOUNT ON;

-- =============================================
-- 1. WIPE EXISTING DATA
-- =============================================
    -- Delete from child tables first to respect foreign key constraints
    DELETE FROM dbo.PrintLog;
    DELETE FROM dbo.ModelTags;
    -- Then delete from parent tables
    DELETE FROM dbo.Models;
    DELETE FROM dbo.Tags;
    DELETE FROM dbo.Printers;

    -- Reset the identity counters for all tables
    DBCC CHECKIDENT ('dbo.PrintLog', RESEED, 0);
    DBCC CHECKIDENT ('dbo.ModelTags', RESEED, 0); -- Note: ModelTags has no IDENTITY, but this is harmless.
    DBCC CHECKIDENT ('dbo.Models', RESEED, 0);
    DBCC CHECKIDENT ('dbo.Tags', RESEED, 0);
    DBCC CHECKIDENT ('dbo.Printers', RESEED, 0);

-- =============================================
-- 2. SEED NEW DEMO DATA
-- =============================================
    BEGIN TRY
        -- Insert Printers
        INSERT INTO dbo.Printers (PrinterBrand, PrinterModelName, PrinterMaterialType) VALUES
        ('Bambu Lab', 'P1S', 'Filament'),
        ('Elegoo', 'Mars 4 Ultra', 'Resin'),
        ('Prusa', 'MK4', 'Filament');

        -- Insert Tags
        INSERT INTO dbo.Tags (TagName) VALUES
        ('Benchmark'),
        ('Functional Print'),
        ('Sci-Fi'),
        ('Miniature'),
        ('Articulated');

        -- Insert Models
        INSERT INTO dbo.Models (ModelName, SourceURL, LicenseType, ModelDescription) VALUES
        ('3DBenchy', 'https://www.thingiverse.com/thing:763622', 'Creative Commons - Attribution', 'The jolly 3D printing torture-test.'),
        ('Articulated Dragon', 'https://www.thingiverse.com/thing:28 articulated_dragon', 'CC BY-NC-SA 4.0', 'A popular articulated dragon model.'),
        ('Apollo 11 Saturn V', 'https://www.thingiverse.com/thing:911842', 'Creative Commons - Attribution', 'A detailed model of the Saturn V rocket.');

        -- Assign Tags to Models
        -- 3DBenchy -> Benchmark
        INSERT INTO dbo.ModelTags (ModelID, TagID) VALUES (1, 1);
        -- Articulated Dragon -> Articulated, Miniature
        INSERT INTO dbo.ModelTags (ModelID, TagID) VALUES (2, 5), (2, 4);
        -- Apollo 11 Saturn V -> Sci-Fi
        INSERT INTO dbo.ModelTags (ModelID, TagID) VALUES (3, 3);

        -- Log some Prints
        -- A successful Benchy print on the P1S
        INSERT INTO dbo.PrintLog (ModelID, PrinterID, PrintStartDateTime, PrintEndDateTime, MaterialUsed, PrintStatus, PrintStatusDetails) VALUES
        (1, 1, '2025-08-01 10:00:00', '2025-08-01 10:45:00', 'PLA', 'Success', 'Perfect first layer.');
        -- A failed Dragon print on the Mars 4
        INSERT INTO dbo.PrintLog (ModelID, PrinterID, PrintStartDateTime, PrintEndDateTime, MaterialUsed, PrintStatus, PrintStatusDetails) VALUES
        (2, 2, '2025-08-02 14:00:00', '2025-08-02 18:30:00', 'Standard Resin', 'Failed', 'Support failure on the left wing.');

        RETURN 0; -- Success
    END TRY

-- ===================================================================
-- 3. HANDLE UNEXPECTED FAILURES
-- ===================================================================
    BEGIN CATCH
        THROW;
    END CATCH
END
GO