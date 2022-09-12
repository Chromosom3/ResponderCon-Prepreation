# windows-automation
This directory contains files that relate to the automation of tasks on Windows host via PowerShell. These files are intended to be moved on Windows hosts and then executed to configure the host for the tabletop scenario. 

## Unattend.xml
This file is used to automatically configure Windows 10 during the initial setup. This will automatically make the user account and select all the installation settings that we want. This file was generated on the site http://www.windowsafg.com. This is used because we syspreped the template virtual machine before cloning. Without this, each VM would need to have a user account and other settings configured before they would be usable. The computer name value was removed from the unattend file so each system by default has a unique name though we plan on renaming them later. This file was used when syspreping by running the following command in the sysprep directory: `sysprep.exe /generalize /oobe /shutdown /unattend:C:\Windows\System32\Sysprep\Unattend.xml`. The user account for this unattend file is U:`Windows10` P:`Password1234567890`.

## dhcp_provision.ps1
This file is intended to run on the domain controller in the environment. The script will install DHCP and then create reservations for the VMs created by the tools in the `vm-provisioning` directory. This script is intended to ensure the IPs used in the ansible inventory file correlate to the correct virtual machine. Note: this script needs the output of the `bulk-vms.ps1` script. There seems to be some issues since this does not specify the DNS server. Will need to look at updating the script.

## malware-environment-setup.ps1
This script is not being used for the workshop. This is more of a personal script for setting up Windows 10 systems without security measures in place for testing malware. It was actually created as an extra credit assignment for a class. 

## user_creation.ps1
This script creates a fixed number of users with the same password. You need to specify the OU you want the users to be placed in, the default password for the users, and the number of users to create. 

## vm_info.csv.template
This is a sample of the output from the `bulk-vms.ps1` script. Note that the true output will be named `vm_info.csv`. 
