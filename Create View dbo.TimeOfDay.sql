CREATE VIEW dbo.TimeOfDay
WITH SCHEMABINDING
AS

SELECT 
[Puff]
, [Date] = CONVERT(DATE, [Date_Time])
, [Hour] = DATEPART(HOUR, [Date_Time])
, (
    CASE 
    WHEN DATEPART(HOUR, [Date_Time]) > 2 AND DATEPART(HOUR, [Date_Time]) < 6 THEN '1. Early Morning' 
    WHEN DATEPART(HOUR, [Date_Time]) > 2 AND DATEPART(HOUR, [Date_Time]) < 12 THEN '2. Morning' 
    WHEN DATEPART(HOUR, [Date_Time]) > 2 AND DATEPART(HOUR, [Date_Time]) < 18 THEN '3. Afternoon' 
    WHEN DATEPART(HOUR, [Date_Time]) > 2 AND DATEPART(HOUR, [Date_Time]) < 21 THEN '4. Evening' 
    ELSE '5. Night' END
    ) AS 'TimeOfDay'
FROM dbo.Puff 
GO

-- Create Indexes
CREATE UNIQUE CLUSTERED INDEX IX_Puff ON [dbo].[TimeOfDay] ([Puff] ASC)
GO

CREATE NONCLUSTERED INDEX IX_Date ON [dbo].[TimeOfDay] ([Date] ASC)
GO

CREATE NONCLUSTERED INDEX IX_Hour ON [dbo].[TimeOfDay] ([Hour] ASC)
GO
