# Script: bulk-vms.ps1
# Author: Dylan 'Chromosom3' Navarro
# Description: Used to make VMs in bulk
# Needs PowerCLI Installed (Install-Module -Name VMware.PowerCLI)

# Connection Information
$esxi_ip = Read-Host "Please enter the server IP address"
$esxi_account = Get-Credential -Message "Please enter your ESXi Credentials"
# VM Settings
$datastore = "datastore1"
$CPUs = 4
$RAM = 8
$Network = "VM Network (LAN)"
$GuestID = "windows9_64Guest"  # Use '[VMware.Vim.VirtualMachineGuestOsIdentifier].GetEnumValues()' to get list
$disk_location = "[datastore1] bulk-vms"
# User Inputs
$name = Read-Host "Please enter the base name for the VMs you'd like to make"
[uint16]$vm_count = Read-Host "How many VMs do you need provisioned?"

Connect-VIServer -Server $esxi_ip -Credential $esxi_account
$vmhost = Get-VMHost -Name $esxi_ip

$vm_info = @{}

for ($vm_number = 1; $vm_number -le $vm_count; $vm_number++){
    $vm_name = "$name$vm_number"
    Write-Host("Making VM '$vm_name'...")
    $new_vm = New-VM -Name $vm_name -ResourcePool $vmhost -Datastore $datastore -NumCPU $CPUs -MemoryGB $RAM -DiskGB 1 -NetworkName $Network -CD -DiskStorageFormat Thin -GuestID $GuestID
    Write-Host("Removing disk from '$vm_name'...")
    $new_vm | Get-HardDisk | Remove-HardDisk -Confirm:$false
    Write-Host("Attaching disk '' to VM '$vm_name'")
    #New-HardDisk -DiskPath "$disk_location/$vm_name/$vm_name.vmdk" -VM $new_vm 
    New-HardDisk -DiskPath "$disk_location/$vm_name/$vm_name.vmdk" -VM $new_vm | New-ScsiController -BusSharingMode NoSharing -Type VirtualLsiLogicSAS
    $new_vm | Start-VM
    Start-Sleep -Seconds 10
    $vm_mac = ($new_vm | Get-NetworkAdapter).MacAddress
    $vm_info.Add($vm_name,$vm_mac)
}

$vm_info.GetEnumerator() | Export-Csv vm_info.csv