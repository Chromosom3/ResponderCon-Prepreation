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