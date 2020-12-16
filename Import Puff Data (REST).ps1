Import-Module .\Invoke-SqlCmd2

Class PuffCollection {
  [Puff[]]$Data

  PuffCollection([Array]$JsonData) {
    ForEach ( $row in $JsonData) {
      try {
        $NewRecord = [Puff]::new($Row)
        $This.Data += $NewRecord
      }
      catch {
        Write-Error $_.Exception.Message
        Continue;
      }
    }
  }
}

Class Puff {
  [int]$puff;
  [string]$ts;
  [float]$time;
  [float]$energy;
  [float]$power;
  [float]$power_sp;
  [float]$cold_ohms;
  [float]$cold_temp;
  [float]$board_temp;
  [float]$snapshot_ohms;
  
  Puff([Object]$Row) {
    $This.puff = $Row.puff;
    $This.ts = $Row.ts;
    $This.time = $Row.time;
    $This.energy = $Row.energy;
    $This.power = $Row.power;
    $This.power_sp = $Row.power_sp;
    $This.cold_ohms = $Row.cold_ohms;
    $This.cold_temp = $Row.cold_temp;
    $This.board_temp = $Row.board_temp;
    $This.snapshot_ohms = $Row.snapshot_ohms;
  }
}

Class PuffUsageCollection {
  [PuffUsage[]]$Data

  PuffUsageCollection([Array]$JsonData) {
    ForEach ( $row in $JsonData) {
      try {
        $NewRecord = [PuffUsage]::new($Row)
        $This.Data += $NewRecord
      }
      catch {
        Write-Error $_.Exception.Message
        Continue;
      }
    }
  }
}

Class PuffUsage {
  [string]$start_date
  [string]$end_date
  [int]$count_of_days
  [int]$count_of_devices
  [float]$puffs
  [float]$puffs_per_day
  [float]$percent_tp
  [float]$energy_mean
  [float]$energy_per_day
  [float]$time_mean
  [float]$time_per_day
  [float]$power_mean
  
  PuffUsage([Object]$JsonData) {
    $This.start_date = $JsonData.start_date;
    $This.end_date = $JsonData.end_date;
    $This.count_of_days = $JsonData.count_of_days;
    $This.count_of_devices = $JsonData.count_of_devices;
    $This.puffs = $JsonData.puffs;
    $This.puffs_per_day = $JsonData.puffs_per_day;
    $This.percent_tp = $JsonData.percent_tp;
    $This.energy_mean = $JsonData.energy_mean;
    $This.energy_per_day = $JsonData.energy_per_day;
    $This.time_mean = $JsonData.time_mean;
    $This.time_per_day = $JsonData.time_per_day;
    $This.power_mean = $JsonData.power_mean;
  }
}

# Connection variables
$ServerInstance = "192.168.1.225" # Plex1
$Database = "Puff"
If ( $null -eq $Credential ) { $Credential = Get-Credential }  

# Step 1: Truncate the Staging Table
try {
  Invoke-Sqlcmd2 `
    -ServerInstance $ServerInstance `
    -Database $Database `
    -Credential $Credential `
    -Query "TRUNCATE TABLE dbo.Puff_Staging;" 

  Write-Host "Truncated Puff_Staging" -ForegroundColor Yellow
}
catch {
  Write-Error $_.Exception.Message
  Break;
}

# Step 2: Get LastId from Puff
$Query2 = "SELECT TOP 1 puff FROM dbo.Puff ORDER BY puff DESC;"
$LastId = (Invoke-Sqlcmd2 `
    -ServerInstance $ServerInstance `
    -Database $Database `
    -Credential $Credential `
    -Query $Query2)[0]

If ( $null -eq $LastId) { Break; }

Write-Host "Got LastId: $LastId" -ForegroundColor Yellow

# Step 3: Download new rows
$Headers = @{
  "Authorization" = "Basic dzA1Mks3V0liU2JzMk55bXBmRGhiVzYzOkN0bkxnOU0zNWF4RXNjMFhQR0toeTVQcA==";
  "Accept"        = "application/json";
}

# REST Endpoints
[String]$PuffsEndpoint = "https://api.ecigstats.org/v1/puffs/?device=pCQ7p42X51z-E66ojGu96Q&format=json&start=$LastId"
[String]$UsageEndpoint = "https://api.ecigstats.org/v1/usage/?account=current&format=json"

try {
  $PuffCollection = [PuffCollection]::New((Invoke-RestMethod -Uri $PuffsEndpoint -Headers $Headers).puffs)
}
catch {
  Write-Error $_.Exception.Message
  Break;
}

Write-Host "Inserting $($PuffCollection.data.Count) rows into Puff_Staging"
$Counter = 0
$total = $PuffCollection.data.Count

# Step 4: Import New Rows to Staging
ForEach ( $row in $PuffCollection.data) {
  $SqlParameters = @{
    "Puff"           = $Row.puff;
    "Date_Time"      = $Row.ts;
    "Time_s"         = $Row.time;
    "Energy_mWh"     = $Row.energy;
    "Power_W"        = $Row.power;
    "Power_Set_W"    = $Row.power_sp;
    "Cold_Ohms"      = $Row.cold_ohms;
    "Cold_Temp_degF" = $Row.cold_temp;
    "Mod_Resistance" = 0;
    "Room_Temp"      = 0;
    "Board_Temp"     = $Row.board_temp;
    "Snapshot_Ohms"  = $Row.snapshot_ohms;
  }

  $Query3 = @"
  INSERT INTO [dbo].[Puff_Staging]
    (
    [Puff]
    ,[Date_Time]
    ,[Time_s]
    ,[Energy_mWh]
    ,[Power_W]
    ,[Power_Set_W]
    ,[Cold_Ohms]
    ,[Cold_Temp_degF]
    ,[Mod_Resistance]
    ,[Room_Temp]
    ,[Board_Temp]
    ,[Snapshot_Ohms]
    )
VALUES
    (
      @Puff
      ,@Date_Time
      ,@Time_s
      ,@Energy_mWh
      ,@Power_W
      ,@Power_Set_W
      ,@Cold_Ohms
      ,@Cold_Temp_degF
      ,@Mod_Resistance
      ,@Room_Temp
      ,@Board_Temp
      ,@Snapshot_Ohms
     )
"@

  try {
    Invoke-Sqlcmd2 `
      -ServerInstance $ServerInstance `
      -Database $Database `
      -Credential $Credential `
      -Query $Query3 `
      -SqlParameters $SqlParameters `
  
  }
  catch {
    Continue;
  }

  $Counter++

  # Display Progess Bar
  Write-Progress `
    -Activity "Inserting Data to Puff_Staging" `
    -Status "Row $Counter of $Total" `
    -PercentComplete (($Counter / $Total) * 100) 
}


# Step 5: Merge Staging into Productions (susng a Stored Procedure)
$Query4 = "EXECUTE [dbo].[ImportNewPuffData];"
Invoke-Sqlcmd2 `
  -ServerInstance $ServerInstance `
  -Database $Database `
  -Credential $Credential `
  -Query $Query4

Write-Host "Inserted $Counter rows into Production"

# Step 6: Recalculate Puff Intervals
$Query5 = '.\Populate Table Puff_Intervals.sql'
Invoke-Sqlcmd2 `
  -ServerInstance $ServerInstance `
  -Database $Database `
  -Credential $Credential `
  -InputFile $Query5

Write-Host "Generated Puff Intervals"
  
# Step 7: Import Usage Data
try {
  $PuffUsageCollection = [PuffUsageCollection]::new((Invoke-RestMethod -Uri $UsageEndpoint -Headers $Headers).usage)
}
catch {
  Write-Error $_.Exception.Message
  Break;
}

# Truncate the Puff_Usage table
Invoke-Sqlcmd2 `
  -ServerInstance $ServerInstance `
  -Database $Database `
  -Credential $Credential `
  -Query "TRUNCATE TABLE $Database.dbo.Puff_Usage;"

$Counter = 0
$Total = $PuffUsageCollection.data.Count
Write-Host "Inserting $Total rows into Puff_Usage"

ForEach ( $row in $PuffUsageCollection.data) {

  $Query7 = @"
  INSERT INTO [dbo].[Puff_Usage]
    (
      [start_date],
      [end_date],
      [count_of_days],
      [count_of_devices],
      [puffs],
      [puffs_per_day],
      [percent_tp],
      [energy_mean],
      [energy_per_day],
      [time_mean],
      [time_per_day],
      [power_mean]
    )
VALUES
    (
      @start_date,
      @end_date,
      @count_of_days,
      @count_of_devices,
      @puffs,
      @puffs_per_day,
      @percent_tp,
      @energy_mean,
      @energy_per_day,
      @time_mean,
      @time_per_day,
      @power_mean
     )
"@

  $SqlParameters = @{
    "start_date"       = $row.start_date
    "end_date"         = $row.end_date
    "count_of_days"    = $row.count_of_days
    "count_of_devices" = $row.count_of_devices
    "puffs"            = $row.puffs
    "puffs_per_day"    = $row.puffs_per_day
    "percent_tp"       = $row.percent_tp
    "energy_mean"      = $row.energy_mean
    "energy_per_day"   = $row.energy_per_day
    "time_mean"        = $row.time_mean
    "time_per_day"     = $row.time_per_day
    "power_mean"       = $row.power_mean
  }

  try {
    Invoke-Sqlcmd2 `
      -ServerInstance $ServerInstance `
      -Database $Database `
      -Credential $Credential `
      -Query $Query7 `
      -SqlParameters $SqlParameters `

  }
  catch {
    Continue;
  }

  $Counter++

  # Display Progess Bar
  Write-Progress `
    -Activity "Inserting Data to Puff_Staging" `
    -Status "Row $Counter of $Total" `
    -PercentComplete (($Counter / $Total) * 100) 
}
