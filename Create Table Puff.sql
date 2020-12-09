Use Puff;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puff]
(
    [Puff] [int] NOT NULL,
    [Date_Time] [datetime] NOT NULL,
    [Time__s_] [float] NOT NULL,
    [Energy__mWh_] [float] NOT NULL,
    [Power__W_] [float] NOT NULL,
    [Power_Set__W_] [tinyint] NOT NULL,
    [Cold_Ohms] [float] NOT NULL,
    [Cold_Temp__degF_] [float] NOT NULL,
    [Mod_Resistance] [float] NULL,
    [Room_Temp] [float] NULL,
    [Board_Temp] [float] NOT NULL,
    [Snapshot_Ohms] [float] NOT NULL,
    PRIMARY KEY CLUSTERED 
(
	[Puff] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
