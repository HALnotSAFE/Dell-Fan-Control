# Dell R620 Fan Script - Interactive by Halsafe.

# Define fan speed options
$fanSpeeds = @{
    "Off" = "0x00"
    "10%" = "0x0A"
    "20%" = "0x14"
    "30%" = "0x1E"
    "40%" = "0x28"
    "50%" = "0x32"
    "60%" = "0x3C"
    "70%" = "0x46"
    "80%" = "0x50"
    "90%" = "0x5A"
    "100%" = "0x64"
}

# File to store server details in the user's profile directory
$configFile = [System.IO.Path]::Combine($env:USERPROFILE, "serverConfig.json")

# Function to prompt user for server details
function Get-ServerDetails {
    param (
        [int]$serverCount
    )

    $details = @()
    for ($i = 1; $i -le $serverCount; $i++) {
        $ipAddress = Read-Host "Enter IP address for server $i"
        $username = Read-Host "Enter username for server $i"
        $password = Read-Host "Enter password for server $i"
        
        $fanSpeed = Read-Host "Enter fan speed for server $i (Options: Off, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%)"
        if (-not $fanSpeeds.ContainsKey($fanSpeed)) {
            Write-Host "Invalid fan speed. Please enter a valid option."
            $i--
            continue
        }

        $details += [pscustomobject]@{
            IPAddress = $ipAddress
            Username = $username
            Password = $password
            FanSpeed = $fanSpeeds[$fanSpeed]
        }
    }
    return $details
}

# Load previous configuration if exists
if (Test-Path $configFile) {
    $usePrevious = Read-Host "Previous configuration found. Would you like to use it? (yes/no)"
    if ($usePrevious -eq "yes") {
        $serverDetails = Get-Content $configFile | ConvertFrom-Json
    } else {
        $serverCount = Read-Host "Enter how many servers you have"
        $serverDetails = Get-ServerDetails -serverCount $serverCount
        $serverDetails | ConvertTo-Json | Set-Content $configFile
    }
} else {
    $serverCount = Read-Host "Enter how many servers you have"
    $serverDetails = Get-ServerDetails -serverCount $serverCount
    $serverDetails | ConvertTo-Json | Set-Content $configFile
}

# Navigate to the directory containing ipmitool
cd C:\ipmitool_1.8.18-dellemc_p001

# Run the ipmitool command for each server
foreach ($server in $serverDetails) {
    Write-Host "Setting fan speed for server: $($server.IPAddress)"
    
    ipmitool.exe -I lanplus -H $server.IPAddress -U $server.Username -P $server.Password raw 0x30 0x30 0x01 0x00
    ipmitool.exe -I lanplus -H $server.IPAddress -U $server.Username -P $server.Password raw 0x30 0x30 0x02 0xff $server.FanSpeed
}
