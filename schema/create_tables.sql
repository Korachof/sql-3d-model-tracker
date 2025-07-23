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
    name NVARCHAR(255) NOT NULL,
    -- Use-case for source-url is to connect to existing models via API
    source_url NVARCHAR(MAX) NOT NULL,
    license_type NVARCHAR(100),
    description NVARCHAR(MAX)
);
