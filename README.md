# Dell Fan Control

This script allows you to configure the fan speeds of multiple Dell servers using the IPMI tool. It prompts the user for server details and fan speed settings, and stores these settings for future use. I only have tested on R620's but this should work for other Dell servers as well. 

## Prerequisites

1. **Download and Install IPMI Tool**

   Download the IPMI tool from Dell and install it to the default path. You can download it from the following link:
   
   [Dell IPMI Tool Download](https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=m63f3)

2. **PowerShell**

   This script is written in PowerShell and requires a Windows environment with PowerShell installed.

## Usage

### First Time Setup

1. **Clone or Download this Repository**

   Ensure you have this script (`DellR620FanScript.ps1`) on your machine.

2. **Run the Script**

   Open a PowerShell terminal and navigate to the directory containing the script. Run the script with the following command:

   ```.\DellR620FanScript.ps1```
## Enter Server Details

  The script will prompt you to enter the number of servers you want to configure. For each server, you will need to provide:

  - IP Address
  - Username
  - Password
  - Fan Speed (choose from the following options: Off, 10%, 20%, 30%, 40%, 50%, 60%, 70%, 80%, 90%, 100%)
  - The fan speed options correspond to the following hexadecimal values:

   - Off: 0x00
   - 10%: 0x0A
   - 20%: 0x14
   - 30%: 0x1E
   - 40%: 0x28
   - 50%: 0x32
   - 60%: 0x3C
   - 70%: 0x46
   - 80%: 0x50
   - 90%: 0x5A
   - 100%: 0x64
## Configuration Storage

  The script stores the entered server details and fan speed settings in a configuration file located in your user profile directory (serverConfig.json). This allows the script to reuse these details in future runs.

## Subsequent Runs
1. Run the Script

    Run the script again with the same command:
    ```.\DellR620FanScript.ps1```
  
2. Use Previous Configuration

    If a previous configuration is found, the script will ask if you want to use it. If you choose "yes", the script will proceed with the stored settings. If you choose "no", you will be prompted to enter new server details.
