-- =============================================
-- Procedure Name: assign_tags
-- Purpose: Links one or more tags to a model in the ModelTags junction table
-- Usage: Called when categorizing models by characteristics or themes
-- Parameters:
--   @model_id          INT               -- Foreign key to Models table
--   @tag_id            INT               -- Foreign key to Tags table
-- Returns: integer status code (0 for success, negative for failure)
-- =============================================

