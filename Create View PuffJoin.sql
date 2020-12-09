USE Puff;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PuffJoin]
AS
    SELECT
        p1.[Puff]
      , p1.[Date_Time]
      , p1.[Time__s_]
      , p2.[End_Time]
      , p2.[Interval]
      , p1.[Energy__mWh_]
      , p1.[Power__W_]
      , p1.[Power_Set__W_]
      , p1.[Cold_Ohms]
      , p1.[Cold_Temp__degF_]
      , p1.[Mod_Resistance]
      , p1.[Room_Temp]
      , p1.[Board_Temp]
      , p1.[Snapshot_Ohms]
    FROM .[dbo].[Puff] p1
        LEFT JOIN dbo.[Puff_Interval] p2
        ON p2.[Id] = p1.[Puff]
GO
