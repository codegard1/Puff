ALTER VIEW dbo.DailyTotals
AS

SELECT 
      CONVERT(DATE, [Date_Time]) as 'Date'
    , COUNT([Puff]) as 'puffs'
    
    , AVG([Energy__mWh_]) as 'energy_mean'
    , SUM([Energy__mWh_]) as 'energy_per_day'

    , AVG([Time__s_]) as 'time_mean'
    , SUM([Time__s_]) as 'time_per_day'

    , AVG([Power__W_]) as 'power_mean'
    , SUM([Power__W_]) as 'power_per_day'

    , SUM([Power_Set__W_]) as 'Sum Power Set'
    , SUM([Cold_Ohms]) as 'Sum Cold Ohms'
    , SUM([Cold_Temp__degF_]) as 'Sum Cold Temp'
    , SUM([Board_Temp]) as 'Sum Board Temp'
    , SUM([Snapshot_Ohms]) as 'Sum SnapshotOhms'

    -- , SUM([Mod_Resistance]) as 'Sum ModResistance'
    -- , SUM([Room_Temp]) as 'Sum Room Temp'
  FROM [Puff].[dbo].[Puff]
  GROUP BY CONVERT(DATE, [Date_Time])

GO