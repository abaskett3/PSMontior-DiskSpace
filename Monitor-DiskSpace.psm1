Function Monitor-DiskSpace{
<#
    .SYNSOPSIS
    This is a simple script to monitor disk space on any given host for any drive on that host.
    
    .DESCRIPTION
    This is a simple script to monitor disk space on any given host for any drive on that host. Use CTRL + C to exit as the loop will go forever.
    
    .EXAMPLE
    Monitor-DiskSpace -server host.domain.local -driveLetter O

    .EXAMPLE
    PS C:\Windows\system32> Monitor-DiskSpace localhost C

    Drive Free Space (GB) Total Size (GB) Free %  VolumeName
    ----- --------------- --------------- ------  ----------
    C:            1355.56         1396.72 97.05 %           
    .EXAMPLE
    PS E:\Arland\Documents\WindowsPowershell\Modules> Monitor-DiskSpace 192.168.0.3 E

    Drive Free Space (GB) Total Size (GB) Free %  VolumeName
    ----- --------------- --------------- ------  ----------
    E:             961.68         1863.01 51.62 % Quarter Master

    .LINK
    https://github.com/webhead3/PSMontior-DiskSpace
#>
[CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,HelpMessage="Please enter the FQDN of the host you would like to monitor.",Position=0)]
        [string]$server,
        [Parameter(Mandatory=$true,HelpMessage="Please enter the drive letter without the colon and slash.",Position=1)]
        [string]$driveLetter
    )

    While (1 -lt 2){
        Get-WmiObject Win32_LogicalDisk -Computername $server |
        Where-Object {$_.DeviceID -like "$driveLetter*"} | 
        Select-Object @{Name="Drive";Expression={$_.DeviceID}},
            @{Name="Free Space (GB)";Expression={[math]::Round($_.FreeSpace / 1GB,2)}},
            @{Name="Total Size (GB)";Expression={[math]::Round($_.Size / 1GB,2)}},
            @{Name="Free %";Expression={($_.FreeSpace/$_.Size).toString("P")}},
            VolumeName | Format-Table -AutoSize
        Start-Sleep -Seconds 5
    }
}