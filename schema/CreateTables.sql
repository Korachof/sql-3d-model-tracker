-- =============================================
-- File Name: create_tables.sql
-- Purpose: Defines core database tables for the 3D Model Tracker
-- Tables Created:
--   Models        - Metadata for printable 3D models
--   Tags          - Categories or descriptors applied to models
--   ModelTags     - Junction table linking Models and Tags
--   PrintLog      - Records physical print job activity per model
-- Notes:
--   Includes primary keys, foreign keys, and recommended data types
--   Intended to be run during initial schema setup
-- =============================================

-- ===================================================================
-- 1. Model Table (Stores core information about each 3D Model)
-- ===================================================================
CREATE TABLE dbo.Models (
    ModelID INT PRIMARY KEY IDENTITY(1,1),
    ModelName NVARCHAR(255) NOT NULL,
    -- Use-case for source-url is to connect to existing models via API
    SourceURL NVARCHAR(450) NOT NULL UNIQUE,
    LicenseType NVARCHAR(100) NULL,
    ModelDescription NVARCHAR(MAX) NULL
);
GO

-- ===================================================================
-- 2. Printers Table (Stores unique Printers to print models)
-- ===================================================================
CREATE TABLE dbo.Printers (
    PrinterID INT PRIMARY KEY IDENTITY(1,1),
    PrinterBrand NVARCHAR(100) NOT NULL,
    PrinterModelName NVARCHAR(100) NOT NULL,
    PrinterMaterialType NVARCHAR(50) NOT NULL,
    -- Composite UNIQUE constraint to prevent duplicate printer entries.
    CONSTRAINT UQ_Printer_Brand_Model UNIQUE (PrinterBrand, PrinterModelName)
);
GO

-- ===================================================================
-- 3. Tags Table (Stores unique tags that can be applied to models)
-- ===================================================================
CREATE TABLE dbo.Tags (
    TagID INT PRIMARY KEY IDENTITY(1,1),
    TagName NVARCHAR(100) NOT NULL UNIQUE 
);
GO



-- ===================================================================
-- 4. ModelTags Junction Table 
-- (Creates a many-to-many relationship between Models and Tags)
-- ===================================================================
CREATE TABLE dbo.ModelTags (
    ModelID INT NOT NULL,
    TagID INT NOT NULL,
    PRIMARY KEY (ModelID, TagID),
    FOREIGN KEY (ModelID) REFERENCES dbo.Models(ModelID) ON DELETE CASCADE,
    FOREIGN KEY (TagID) REFERENCES dbo.Tags(TagID) ON DELETE CASCADE
);
GO

-- ===================================================================
-- 5. PrintLog Junction Table (Stores a record of each time a model is printed)
-- ===================================================================
CREATE TABLE dbo.PrintLog (
    PrintID INT PRIMARY KEY IDENTITY(1,1),
    ModelID INT NOT NULL,
    PrinterID INT NOT NULL,
    PrintStartDateTime DATETIME2(0) NOT NULL,
    PrintEndDateTime DATETIME2(0) NOT NULL,
    MaterialUsed NVARCHAR(100) NOT NULL,
    PrintStatus NVARCHAR(50) NOT NULL,
    PrintStatusDetails NVARCHAR(MAX) NULL,
    FOREIGN KEY (ModelID) REFERENCES dbo.Models(ModelID) ON DELETE CASCADE,
    FOREIGN KEY (PrinterID) REFERENCES dbo.Printers(PrinterID) ON DELETE CASCADE,
    -- Composite UNIQUE constraint to prevent logical duplicates.
    CONSTRAINT UQ_PrintLog_Model_Start UNIQUE (ModelID, PrintStartDateTime)
);
GO
