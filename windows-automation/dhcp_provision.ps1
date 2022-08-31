# Script: dhcp_provision.ps1
# Author: Dylan 'Chromosom3' Navarro
# Description: Used to make VMs in bulk

# Install DHCP 
Install-WindowsFeature DHCP -IncludeManagementTools
# Add the security groups required to manage DHCP.
netsh dhcp add securitygroups
Restart-Service dhcpserver
# Authorized the DHCP server in the domain
Add-DhcpServerInDC
#This prevents some errors that might occur where Server Manager doesn't know this is finished setting up. 
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Get the range from the user and setup the scope.
$start_ip = Read-Host("Please enter the starting IP address for the DHCP scope")
$end_ip = Read-Host("Please enter the ending IP address for the DHCP scope")
Add-DhcpServerv4Scope -Name "DHCP Scope" -StartRange $start_ip -EndRange $end_ip -SubnetMask 255.255.255.0 -LeaseDuration 0.00:30:00
# Setup reservations on the server.
$vm_info = Import-CSV .\vm_info.csv
$reservation_start = Read-Host("Please enter the starting IP reservation")
if ($reservation_start -match "[0-9]+.[0-9]+.[0-9]+"){
    # Gets the first three oct of the IP
    $ip_space = $matches[0]
    # We subtract one from the last oct so that the first vm (1) will be the number we originally entered.
    $last_oct = ([int](($reservation_start.Split("."))[3]) - 1)
    $scope_ip = $reservation_start + ".0"
    
    foreach ($vm in $vm_info) {
        if ($vm.Name -match "-[0-9]+"){
            # Returns "-NUMBER" so we need to remove the dash with the substring method.
            $vm_number = ($matches[0]).Substring(1)
        }
        $vm_ip = $ip_space + "." + ($last_oct + $vm_number)
        Add-DhcpServerv4Reservation -ScopeId $scope_ip -IPAddress $vm_ip -ClientId ${$vm.Value} -Description "Reservation for ${$vm.Name}"
    }
}