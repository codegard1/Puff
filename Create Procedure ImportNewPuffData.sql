SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[ImportNewPuffData]
AS
-- body of the stored procedure

DECLARE @cutoff INT;
DECLARE @mark NVARCHAR;
DECLARE @count INT;
DECLARE @Staging_Table NVARCHAR(50);
DECLARE @Production_Table NVARCHAR(50);

SET @Staging_Table = 'Puff_Staging'
SET @Production_Table = 'Puff'

-- Get the cutoff ID by which to filter the staging table
SELECT @cutoff = ( SELECT MAX( [Puff] ) FROM [dbo].[Puff] )

--  get the number of rows that can be imported
SELECT @count = (
    SELECT COUNT([Puff])
    FROM dbo.[Puff]
    WHERE [Puff] > @cutoff
)

-- set the transaction description (mark)
SET @mark = CONCAT(CONCAT(@Staging_Table, ': Import new Puff data ('), CONCAT(@count, ' rows)'));

IF (
    EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = @Staging_Table)
    AND EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = @Production_Table)
    AND (@count > 0)
)
BEGIN TRAN PUFF
    WITH MARK @mark
    INSERT INTO [dbo].[Puff]
SELECT 
    [Puff]
    , [Date_Time]
    , [Time_s] as 'Time__s_'
    , [Energy_mWh] as 'Energy__mWh_'
    , [Power_W] as 'Power__W_'
    , [Power_Set_W] as 'Power_Set__W_'
    , [Cold_Ohms]
    , [Cold_Temp_degF] as 'Cold_Temp__degF_'
    , [Mod_Resistance]
    , [Room_Temp]
    , [Board_Temp]
    , [Snapshot_Ohms]
FROM [dbo].[Puff_Staging]
WHERE [Puff] > @cutoff
GO
