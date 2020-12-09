USE Puff;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puff_Staging](
	[Puff] [smallint] NOT NULL,
	[Date_Time] [datetime2](7) NOT NULL,
	[Time_s] [float] NOT NULL,
	[Energy_mWh] [float] NOT NULL,
	[Power_W] [float] NOT NULL,
	[Power_Set_W] [tinyint] NOT NULL,
	[Cold_Ohms] [float] NOT NULL,
	[Cold_Temp_degF] [float] NOT NULL,
	[Mod_Resistance] [nvarchar](1) NULL,
	[Room_Temp] [nvarchar](1) NULL,
	[Board_Temp] [float] NOT NULL,
	[Snapshot_Ohms] [float] NOT NULL
) ON [PRIMARY]
GO
