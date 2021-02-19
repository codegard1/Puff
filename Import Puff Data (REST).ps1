#Requires -Module Invoke-SqlCmd2
Install-Module Invoke-SqlCmd2
Import-Module Invoke-SqlCmd2

# Import-Module ".\Invoke-Parallel\Invoke-Parallel.ps1"


# Class Definitions to store REST Data
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

# Connection variable
$ServerInstance = "192.168.1.207" # SQL2
$Database = "Puff"

# Get credentials
$Credential = New-Object -TypeName System.Management.Automation.PSCredential `
-ArgumentList "chris", (Get-Content "gxddb0v.txt" | ConvertTo-SecureString) 
If( $null -eq $Credential ) { Write-Error "Invalid Credentials"; Break; }

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
$Query2 = "SELECT MAX(Puff) FROM dbo.Puff;"
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
[String]$PuffsEndpoint = "https://api.ecigstats.org/v1/puffs/?device=pCQ7p42X51z-E66ojGu96Q&format=json&start=$($LastId+1)"

# Usage is deprecated in favor of generating averages in SQL
# [String]$UsageEndpoint = "https://api.ecigstats.org/v1/usage/?account=current&format=json"

try {
  # Load the REST data into a PuffCollection 
  $PuffCollection = [PuffCollection]::New((Invoke-RestMethod -Uri $PuffsEndpoint -Headers $Headers).puffs)
}
catch {
  Write-Error $_.Exception.Message
  Break;
}

$total = $PuffCollection.data.Count
$Counter = 0

# Break if there is no new data
If($Total -eq 0){
  Write-Host "No new rows. Breaking..." -ForegroundColor Yellow
  Break;
}

Write-Host "Inserting $total rows into Puff_Staging"

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
    Write-Host $_.Exception.Message -ForegroundColor Red
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
  
