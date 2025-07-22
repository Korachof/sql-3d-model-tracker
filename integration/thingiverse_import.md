<!-- =====================================================
  File Name: thingiverse_import.md
  Purpose: Outlines the integration strategy for importing
           3D model metadata from Thingiverse's public API
           into the sql-3d-model-tracker database.
  Scope:
    - Model metadata (name, license, source URL, description)
    - Tag data (semantic categorization via tags[])
  Goals:
    - Support scalable, reusable import logic for portfolio-quality tracking
    - Maintain lightweight complexity while showcasing architectural clarity
  Notes:
    - Thumbnail image support deferred unless UI is introduced
    - Tag integration aligns with existing schema and assign_tags.sql procedure
===================================================== -->
