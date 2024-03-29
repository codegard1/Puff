USE Puff;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puff_Interval](
	[Id] [int] NOT NULL,
	[Interval] [int] NULL,
	[End_Time] [datetime] NULL,
	[Start_Time] [datetime] NULL,
	[Previous_Start] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_StartTime ON [dbo].[Puff_Interval] ([Start_Time])
GO

CREATE NONCLUSTERED INDEX IX_EndTime ON [dbo].[Puff_Interval] ([End_Time])
GO