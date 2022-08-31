# Script: dhcp_provision.ps1
# Author: Dylan 'Chromosom3' Navarro
# Description: Used to make VMs in bulk

# Install DHCP 
Install-WindowsFeature DHCP -IncludeManagementTools
# Add the security groups required to manage DHCP.
netsh dhcp add securitygroups
Restart-Service dhcpserver

# Lets add the DHCP server as an authorized server for the domain. 
#$ip = (Get-NetIPAddress | Where-Object -FilterScript {$_.InterfaceAlias -eq "Ethernet" -and $_.AddressFamily -eq "IPv4"}).IPAddress
#$domain = (Get-WmiObject Win32_ComputerSystem).Domain
#Add-DhcpServerInDC -DnsName DHCP1.corp.contoso.com -IPAddress $ip
Add-DhcpServerInDC
#This prevents some errors that might occur where Server Manager doesn't know this is finished setting up. 
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2


$start_ip = Read-Host("Please enter the starting IP address for the DHCP scope")
$end_ip = Read-Host("Please enter the ending IP address for the DHCP scope")

Add-DhcpServerv4Scope -Name "DHCP Scope" -StartRange $start_ip -EndRange $end_ip -SubnetMask 255.255.255.0 -LeaseDuration 0.00:30:00