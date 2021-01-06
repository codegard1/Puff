CREATE VIEW dbo.DailyAverage
AS
SELECT 
      CONVERT(DATE, [Date_Time]) as 'Date'
    -- , COUNT([Puff]) as 'Puff'
    , AVG([Time__s_]) as 'Avg Time'
    , AVG([Energy__mWh_]) as 'Avg Energy'
    , AVG([Power__W_]) as 'Avg Power'
    , AVG([Power_Set__W_]) as 'Avg Power Set'
    , AVG([Cold_Ohms]) as 'Avg Cold Ohms'
    , AVG([Cold_Temp__degF_]) as 'Avg Cold Temp'
    , AVG([Mod_Resistance]) as 'Avg Mod Resistance'
    , AVG([Room_Temp]) as 'Avg Room_Temp'
    , AVG([Board_Temp]) as 'Avg Board_Temp'
    , AVG([Snapshot_Ohms]) as 'Avg Snapshot_Ohms'
  FROM [Puff].[dbo].[Puff]
  GROUP BY CONVERT(DATE, [Date_Time])
--   ORDER BY CONVERT(DATE, [Date_Time]) DESC