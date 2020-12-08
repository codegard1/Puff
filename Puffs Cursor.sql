USE Bills 
GO

DECLARE @puff INT
,@Date_Time datetime
,@Time__s_ float
,@Energy__mWh_ float
,@Power__W_ float
,@Power_Set__W_ tinyint
,@Cold_Ohms float
,@Cold_Temp__degF_ float
,@Mod_Resistance float
,@Room_Temp float
,@Board_Temp float
,@Snapshot_Ohms float

DECLARE @resultID INT

DECLARE cursor_puffs CURSOR
FOR SELECT TOP 10
    [Puff]
FROM dbo.Puff_Staging
ORDER BY [Puff]

OPEN cursor_puffs
FETCH NEXT FROM cursor_puffs INTO @puff
WHILE @@FETCH_STATUS = 0
    BEGIN

    PRINT @puff

    -- SELECT @result = (select [Puff])

END

CLOSE cursor_puffs
DEALLOCATE cursor_puffs