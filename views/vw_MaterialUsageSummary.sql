-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-14
-- Description: Creates a view that summarizes print statistics for each
--              type of material used.
-- =============================================

CREATE OR ALTER VIEW dbo.vw_MaterialUsageSummary
AS
SELECT
    MaterialUsed,
    -- Count the total number of prints for this material
    COUNT(PrintID) AS TotalPrints,
    -- Count only the successful prints
    SUM(CASE WHEN PrintStatus = 'Success' THEN 1 ELSE 0 END) AS SuccessfulPrints,
    -- Count only the failed prints
    SUM(CASE WHEN PrintStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedPrints,
    -- Calculate the success rate as a percentage
    (SUM(CASE WHEN PrintStatus = 'Success' THEN 1.0 ELSE 0.0 END) / COUNT(PrintID)) * 100 AS SuccessRatePercentage
FROM
    dbo.PrintLog
GROUP BY
    MaterialUsed;
GO