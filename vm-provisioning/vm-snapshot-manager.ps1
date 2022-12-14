# Script: vm-snapshot-manager.ps1
# Author: Dylan 'Chromosom3' Navarro
# Description: Used to bulk manage VM snapshots
# Needs PowerCLI Installed (Install-Module -Name VMware.PowerCLI)

# Connection Information
$esxi_ip = Read-Host "Please enter the server IP address"
$esxi_account = Get-Credential -Message "Please enter your ESXi Credentials"
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server $esxi_ip -Credential $esxi_account

Write-Host("[1] Take Snapshots`n[2] Restore Snapshots`n[3] Remove Snapshot")
$selection= Read-Host("Enter your selection")
$vm_file= Read-Host("Please provide the name of the CSV you'd like to import")
$vm_list = Import-Csv $vm_file
$snapshot_name = Read-Host("Enter Snapshot Name")
if ($selection -eq "1") {
    $snapshot_description = (Read-Host("Enter Snapshot Description")) + " | This was automatically generated by vm-snapshot-manager.ps1"
    foreach ($vm in $vm_list) {
        Write-Host("Taking snapshots of $($VM.Name)...")
        New-Snapshot -VM $($VM.Name) -Name $snapshot_name -Description $snapshot_description
    }
} elseif ($selection -eq "2") {
    foreach ($vm in $vm_list) {
        Write-Host("Restoring $($VM.Name)...")
        Set-VM -VM $($vm.Name) -Snapshot (Get-Snapshot -VM $($vm.Name) -Name $snapshot_name) -confirm:$false
    }
} elseif ($selection -eq "3") {
    foreach ($vm in $vm_list) {
        Write-Host("Deleting snapshot $snapshot_name from $($VM.Name)...")
        Get-Snapshot -VM $($vm.Name) -Name $snapshot_name | Remove-Snapshot -RemoveChildren -confirm:$false
    }
} else {
    Write-Host("Invalid selection. Exiting...")
}