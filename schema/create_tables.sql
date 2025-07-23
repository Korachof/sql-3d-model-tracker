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

-- Models Table
CREATE TABLE Models (
    model_id INT PRIMARY KEY IDENTITY(1,1),
    model_name NVARCHAR(255) NOT NULL,
    -- Use-case for source-url is to connect to existing models via API
    source_url NVARCHAR(MAX) NOT NULL,
    license_type NVARCHAR(100) NULL,
    model_description NVARCHAR(MAX) NULL
);

-- Tags Table
CREATE TABLE Tags (
    tag_id INT PRIMARY KEY IDENTITY(1,1),
    tag_name NVARCHAR(100) NOT NULL UNIQUE
);

-- ModelTags Junction Table
CREATE TABLE ModelTags (
    model_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (model_id, tag_id),
    FOREIGN KEY (model_id) REFERENCES Models(model_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);

-- PrintLog Table
CREATE TABLE PrintLog (
    print_id INT PRIMARY KEY IDENTITY(1,1),
    model_id INT NOT NULL,
    material_used NVARCHAR(100) NOT NULL,
    print_status NVARCHAR(50) NOT NULL,
    print_status_details NVARCHAR(MAX),
    print_date DATE NOT NULL,
    -- If duration is unknown or forgotten, set to -1 for a placeholder
    duration_minutes INT NOT NULL,
    FOREIGN KEY (model_id) REFERENCES Models(model_id)
);
