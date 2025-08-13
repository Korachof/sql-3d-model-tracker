-- =============================================
-- Author:      Chris Partin
-- Create date: 2025-08-13
-- Description: Creates a view that shows the 10 most recent print logs.
-- =============================================
CREATE OR ALTER VIEW dbo.vw_RecentPrints
AS
SELECT TOP (10)
    pl.PrintID,
    pl.ModelID, -- ADDED: To provide a unique identifier for the model.
    m.ModelName,
    p.PrinterBrand,
    p.PrinterModelName,
    pl.PrintStartDateTime,
    pl.PrintStatus
FROM
    dbo.PrintLog AS pl
JOIN
    dbo.Models AS m ON pl.ModelID = m.ModelID
JOIN
    dbo.Printers AS p ON pl.PrinterID = p.PrinterID
ORDER BY
    pl.PrintStartDateTime DESC;
GO