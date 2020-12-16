USE Puff;
GO

-- Copy Puff
TRUNCATE TABLE [Puff].dbo.[Puff]
GO
INSERT INTO [Puff].dbo.[Puff]
SELECT *
FROM [Puff].dbo.[Puff]
GO

-- Copy Puff_Interval 
TRUNCATE TABLE [Puff].dbo.[Puff_Interval]
GO
INSERT INTO [Puff].dbo.[Puff_Interval]
SELECT *
FROM [Puff].dbo.[Puff_Interval]
GO

-- Copy Puff_Usage
TRUNCATE TABLE [Puff].dbo.[Puff_Usage]
GO
INSERT INTO [Puff].dbo.[Puff_Usage]
SELECT
      [start_date]
      , [end_date]
      , [count_of_days]
      , [count_of_devices]
      , [puffs]
      , [puffs_per_day]
      , [percent_tp]
      , [energy_mean]
      , [energy_per_day]
      , [time_mean]
      , [time_per_day]
      , [power_mean]
FROM [Puff].dbo.[Puff_Usage]
ORDER BY [start_date] 
GO

-- Copy Puff_Usage_Staging
TRUNCATE TABLE [Puff].dbo.[Puff_Usage_Staging]
GO
INSERT INTO [Puff].dbo.[Puff_Usage_Staging]
SELECT *
FROM [Puff].dbo.[Puff_Usage_Staging]
GO

-- Copy Puff_Staging
TRUNCATE TABLE [Puff].dbo.[Puff_Staging]
GO
INSERT INTO [Puff].dbo.[Puff_Staging]
SELECT *
FROM [Puff].dbo.[Puff_Staging]
GO
