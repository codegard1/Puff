USE Puff;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puff_Usage_Staging](
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[count_of_days] [int] NULL,
	[count_of_devices] [float] NULL,
	[puffs] [float] NULL,
	[puffs_per_day] [float] NULL,
	[percent_tp] [float] NULL,
	[energy_mean] [float] NULL,
	[energy_per_day] [float] NULL,
	[time_mean] [float] NULL,
	[time_per_day] [float] NULL,
	[power_mean] [float] NULL
) ON [PRIMARY]
GO
