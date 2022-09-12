# ResponderCon-Prepreation
This repository houses all of the automation scripts/playbooks I made in support of the ResponderCon RansomCare Workshop. I worked on this project under Professor Ali Hadi of Champlain College. My tasking on the project was to automate the deployment of an environment that could facilitate a ransomware tabletop exercise. I also acted in a sysadmin capacity to build and maintain systems in support of this project. See the sections below for more information on the various scripts in this repository.

## ansible
This directory houses all the files that relate to ansible. Ansible was used to configure the Windows 10 clients in the environment. To use the files in this directory you would simply run the command `ansible-playbook -i inventory.txt -k windows-provision.yml` while in this directory. Note that the `-k` flag is the same as `--ask-pass` and is not required if you are using SSH keys. 

## linux-automation
This houses all the files designed to be run on a Linux host in the environment. Ideally, scripts in this directory are intended to fully build the services required for the system to operate in the workshop environment.
### guac_setup.sh
This script will fully build the Apache Guacamole server. This was tested on Ubuntu 22.04. The script will require some user input to work correctly. Specifically, you will need to enter a password for the mysql root user and the guacamole sql user. Additionally, when propted for a password after entering the previous two use the root password.

## vm-provisioning
The `vm-provisioning` directory stores all the files pertaining to the automatic creation of virtual machines on ESXi. These scripts were designed to run on a single ESXi server with no vCenter Server Appliance running. This means some functionality of the vSphere environment was not present. For this reason, some creative approaches were taken. 
### bulk-vms.ps1
This script connects to the specified ESXi server and creates the desired amount of VMs. To change the VM hardware requirements you must edit the script before running. This script will create VMs with a 1GB virtual hard disk and then remove the virtual hard disk. Once the virtual disk is removed it will add another virtual disk provisioned by the `esxi-vm.sh` script. The SCSI controller is hard-coded to be LSI Logical SAS. This is ideal for Windows 10 but may cause issues for other operating systems. Upon the completion of this script, a `vm_info.csv` file will be created. This is intended to be used with the `windows-automation/dhcp_provision.ps1` script. You should move the file to the `windows-automation` directory. 

## windows-automation
This directory contains files that relate to the automation of tasks on Windows host via PowerShell. These files are intended to be moved on Windows hosts and then executed to configure the host for the tabletop scenario. 
### Unattend.xml
This file is used to automatically configure Windows 10 during the initial setup. This will automatically make the user account and select all the installation settings that we want. This file was generated on the site http://www.windowsafg.com. This is used because we syspreped the template virtual machine before cloning. Without this, each VM would need to have a user account and other settings configured before they would be usable. The computer name value was removed from the unattend file so each system by default has a unique name though we plan on renaming them later. This file was used when syspreping by running the following command in the sysprep directory: `sysprep.exe /generalize /oobe /shutdown /unattend:C:\Windows\System32\Sysprep\Unattend.xml`. The user account for this unattend file is U:`Windows10` P:`Password1234567890`.
### dhcp_provision.ps1
This file is intended to run on the domain controller in the environment. The script will install DHCP and then create reservations for the VMs created by the tools in the `vm-provisioning` directory. This script is intended to ensure the IPs used in the ansible inventory file correlate to the correct virtual machine. Note: this script needs the output of the `bulk-vms.ps1` script. There seems to be some issues since this does not specify the DNS server. Will need to look at updating the script.
### malware-environment-setup.ps1
This script is not being used for the workshop. This is more of a personal script for setting up Windows 10 systems without security measures in place for testing malware. It was actually created as an extra credit assignment for a class. 
### vm_info.csv.template
This is a sample of the output from the `bulk-vms.ps1` script. Note that the true output will be named `vm_info.csv`. 
