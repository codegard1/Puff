MERGE dbo.Puff t 
USING dbo.Puff_Staging s
ON (t.Puff = s.Puff)
WHEN MATCHED
    THEN UPDATE 
        SET 
      t.[Puff] = s.[Puff]
    , t.[Date_Time] = s.[Date_Time]
    , t.[Time__s_] = s.[Time_s]
    , t.[Energy__mWh_] = s.[Energy_mWh]
    , t.[Power__W_] = s.[Power_W]
    , t.[Power_Set__W_] = s.[Power_Set_W]
    , t.[Cold_Ohms] = s.[Cold_Ohms]
    , t.[Cold_Temp__degF_] = s.[Cold_Temp_degF]
    , t.[Mod_Resistance] = s.[Mod_Resistance]
    , t.[Room_Temp] = s.[Room_Temp]
    , t.[Board_Temp] = s.[Board_Temp]
    , t.[Snapshot_Ohms] = s.[Snapshot_Ohms]
WHEN NOT MATCHED BY TARGET
    THEN INSERT (
      [Puff]
    , [Date_Time]
    , [Time__s_]
    , [Energy__mWh_]
    , [Power__W_]
    , [Power_Set__W_]
    , [Cold_Ohms]
    , [Cold_Temp__degF_]
    , [Mod_Resistance]
    , [Room_Temp]
    , [Board_Temp]
    , [Snapshot_Ohms]
    ) 
    VALUES (
      s.[Puff]
    , s.[Date_Time]
    , s.[Time_s]
    , s.[Energy_mWh]
    , s.[Power_W]
    , s.[Power_Set_W]
    , s.[Cold_Ohms]
    , s.[Cold_Temp_degF]
    , s.[Mod_Resistance]
    , s.[Room_Temp]
    , s.[Board_Temp]
    , s.[Snapshot_Ohms]
    )
WHEN NOT MATCHED BY SOURCE 
THEN DELETE;