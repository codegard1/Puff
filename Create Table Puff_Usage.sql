USE Puff;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puff_Usage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
	[power_mean] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Date] ON [dbo].[Puff_Usage]
(
	[start_date] ASC,
	[end_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
