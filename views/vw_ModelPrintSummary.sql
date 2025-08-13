-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-13
-- Description: Creates a view that calculates and summarizes print statistics
--              for each model in the database.
-- =============================================

CREATE OR ALTER VIEW dbo.vw_ModelPrintSummary
AS
SELECT
    m.ModelID,
    m.ModelName,
    -- Count the total number of prints for this model
    COUNT(pl.PrintID) AS TotalPrints,
    -- Count only the successful prints
    SUM(CASE WHEN pl.PrintStatus = 'Success' THEN 1 ELSE 0 END) AS SuccessfulPrints,
    -- Count only the failed prints
    SUM(CASE WHEN pl.PrintStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedPrints,
    -- Calculate the average print duration in minutes for this model
    AVG(DATEDIFF(minute, pl.PrintStartDateTime, pl.PrintEndDateTime)) AS AverageDurationMinutes
FROM
    dbo.Models AS m
LEFT JOIN
    dbo.PrintLog AS pl ON m.ModelID = pl.ModelID
GROUP BY
    m.ModelID,
    m.ModelName;
GO