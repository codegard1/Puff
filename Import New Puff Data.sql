-- Import new Puff Data from the staging table
-- Filter based on the most recent Puff (ID) from [dbo].[Puff]
-- This assumes that the staging table is named Puff_Staging

USE Bills;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE [dbo].[ImportNewPuffData]
    --  Name of the Table where staging data is stored
    @Staging_Table nvarchar(255) = 'Puff_Staging'
AS
-- body of the stored procedure

DECLARE @cutoff INT;
DECLARE @mark NVARCHAR;
DECLARE @count INT;

-- Get the cutoff ID by which to filter the staging table
SELECT @cutoff = (
    SELECT TOP 1
        [Puff]
    FROM [dbo].[Puff]
    ORDER BY [Puff] DESC 
)

--  get the number of rows that can be imported
SELECT @count = (
    SELECT COUNT([Puff])
    FROM dbo.[Puff]
    WHERE [Puff] > @cutoff
)

-- set the transaction description (mark)
SET @mark = CONCAT(CONCAT('Import new Puff data from ', @Staging_Table), CONCAT(@count, 'rows'))

IF (
    EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = @Staging_Table)
    AND (@count > 0)
)
BEGIN TRAN PUFF
    WITH MARK @mark
    INSERT INTO [dbo].[Puff]
    SELECT
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
    FROM [Bills].[dbo].[Puff_Staging]
    WHERE [Puff] > @cutoff
    ORDER BY [Puff] DESC
GO
