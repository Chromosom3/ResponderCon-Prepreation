# vm-provisioning
The `vm-provisioning` directory stores all the files pertaining to the automatic creation of virtual machines on ESXi. These scripts were designed to run on a single ESXi server with no vCenter Server Appliance running. This means some functionality of the vSphere environment was not present. For this reason, some creative approaches were taken. 

## bulk-vms.ps1
This script connects to the specified ESXi server and creates the desired amount of VMs. To change the VM hardware requirements you must edit the script before running. This script will create VMs with a 1GB virtual hard disk and then remove the virtual hard disk. Once the virtual disk is removed it will add another virtual disk provisioned by the `esxi-vm.sh` script. The SCSI controller is hard-coded to be LSI Logical SAS. This is ideal for Windows 10 but may cause issues for other operating systems. Upon the completion of this script, a `vm_info.csv` file will be created. This is intended to be used with the `windows-automation/dhcp_provision.ps1` script. You should move the file to the `windows-automation` directory. 

## esxi-vms.sh
This script is used with the above script (`bulk-vms.ps1`) to provision multiple virtual machines at once. This script must be run first as it creates the hard disk files that are used by the other script when creating VMs. This file has threee vlaues that mater. These values are the first three lines of the script. They include the vm_template (this is the VM you are cloning from), vm_base_name (the new VM name for the clones), and the file path to the datastore where the files will be placed (this should always be `/vmfs/volumes/DATASTORE` where DATASTORE is the datastore name). 

## vm-snapshot-manager.ps1
This is a simple PowerCLI script that is used to manage snapshots in bulk. The script will connec to the target server, ask for the action to be taken, ask for a csv with the VM names, then execute your action on all the VMs. 

## vm.csv
This is a sample CSV file for the `vm-snapshot-manager.ps1` file. The CSV should have a header of `Name` and then contain a VM name on each line after that. 