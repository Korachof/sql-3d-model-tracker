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

# Thingiverse Integration Plan

## Purpose

Import structured model data from Thingiverse’s public API into the `Models`, `Tags`, and `ModelTags` tables to establish a portfolio-grade, metadata-rich tracker for printable 3D models.

## Method

- Access model data via Thingiverse’s REST API (may require token)
- Use endpoints like:
  - `/search/` – to discover models
  - `/thing/:id` – for detailed metadata

## Fields to Extract

From each model JSON:

- `name` → `Models.name`
- `url` → `Models.source_url`
- `license` → `Models.license_type`
- `description` → `Models.description`
- `tags[].name` → `Tags.name` and `ModelTags` junction
- _(Optional for future)_ `thumbnail` → deferred

## Import Workflow

1. Query API for candidate models (by keyword, popularity, etc.)
2. For each model:
   - Parse relevant fields and sanitize
   - Insert into `Models` via `add_model.sql`
   - Extract tag names:
     - Insert any new tags into `Tags` table
     - Use `assign_tags.sql` to link tags to model
3. Store raw JSON for reference in `thingiverse_sample.json`

## Considerations

- Tag names should be trimmed, lowercased, and deduplicated
- License mapping may require normalization
- API limits may affect batch size—use backoff strategy if needed
- Image imports are deferred until UI integration
