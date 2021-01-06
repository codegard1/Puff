CREATE VIEW dbo.DailyTotals
AS
SELECT 
      CONVERT(DATE, [Date_Time]) as 'Date'
    , COUNT([Puff]) as 'Puff Count'
    , SUM([Time__s_]) as 'Sum Time'
    , SUM([Energy__mWh_]) as 'Sum Energy'
    , SUM([Power__W_]) as 'Sum Power'
    , SUM([Power_Set__W_]) as 'Sum Power Set'
    , SUM([Cold_Ohms]) as 'Sum Cold Ohms'
    , SUM([Cold_Temp__degF_]) as 'Sum Cold Temp'
    , SUM([Mod_Resistance]) as 'Sum ModResistance'
    , SUM([Room_Temp]) as 'Sum Room Temp'
    , SUM([Board_Temp]) as 'Sum Board Temp'
    , SUM([Snapshot_Ohms]) as 'Sum SnapshotOhms'
  FROM [Puff].[dbo].[Puff]
  GROUP BY CONVERT(DATE, [Date_Time])
--   ORDER BY CONVERT(DATE, [Date_Time]) DESC