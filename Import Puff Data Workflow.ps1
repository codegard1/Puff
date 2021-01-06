<#
.Synopsis
  Short description
.DESCRIPTION
  Long description
.EXAMPLE
  Example of how to use this workflow
.EXAMPLE
  Another example of how to use this workflow
.INPUTS
  Inputs to this workflow (if any)
.OUTPUTS
  Output from this workflow (if any)
.NOTES
  General notes
.FUNCTIONALITY
  The functionality that best describes this workflow
#>



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


workflow Get-PuffData {
  [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1',
    HelpUri = 'http://www.microsoft.com/',
    ConfirmImpact = 'Medium')]
  [OutputType([String])]
  param (
    # This is a test. Please disregard. 
    [Parameter(Mandatory = $true, 
      Position = 0,
      ParameterSetName = 'Parameter Set 1')]
    [ValidateNotNull()]
    [Alias("p1")] 
    $Param1,
    $ServerInstance = "192.168.1.207",
    $Database = "Puff",
    [SecureString] $Credential
  )



}

Get-PuffData