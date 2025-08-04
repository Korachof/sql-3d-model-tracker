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
    SourceURL NVARCHAR(MAX) NOT NULL UNIQUE,
    LicenseType NVARCHAR(100) NULL,
    ModelDescription NVARCHAR(MAX) NULL
);
GO

-- ===================================================================
-- 2. Tags Table (Stores unique tags that can be applied to models)
-- ===================================================================
CREATE TABLE dbo.Tags (
    TagID INT PRIMARY KEY IDENTITY(1,1),
    TagName NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- ===================================================================
-- 3. ModelTags Junction Table 
-- (Creates a many-to-many relationship between Models and Tags)
-- ===================================================================
CREATE TABLE dbo.ModelTags (
    ModelID INT NOT NULL,
    TagID INT NOT NULL,
    PRIMARY KEY (ModelID, TagID),
    FOREIGN KEY (ModelID) REFERENCES dbo.Models(ModelID),
    FOREIGN KEY (TagID) REFERENCES dbo.Tags(TagID)
);
GO

-- ===================================================================
-- 4. PrintLog Table (Stores a record of each time a model is printed)
-- ===================================================================
CREATE TABLE dbo.PrintLog (
    PrintID INT PRIMARY KEY IDENTITY(1,1),
    ModelID INT NOT NULL,
    MaterialUsed NVARCHAR(100) NOT NULL,
    PrintStatus NVARCHAR(50) NOT NULL,
    PrintStatusDetails NVARCHAR(MAX),
    PrintDate DATE NOT NULL,
    -- If duration is unknown or forgotten, set to -1 for a placeholder
    DurationMinutes INT NOT NULL,
    FOREIGN KEY (ModelID) REFERENCES dbo.Models(ModelID)
);
GO
