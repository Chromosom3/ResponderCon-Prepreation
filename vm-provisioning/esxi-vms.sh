#!/bin/sh

# Script: esxi-vms.sh
# Author: Dylan 'Chromosom3' Navarro
# Description: Used to clone virtual disks in bulk. Intended to be run on the ESXi server.

vm_template="PRD-Win10-Template"
vm_base_name="PRD-Win10-"

cd /vmfs/volumes/vm-datastore
mkdir bulk-vms
original_disk="$vm_template/$vm_template.vmdk"
#echo "$original_disk"
END=6
for vm in $(seq 1 $END)
do
    vm_name="$vm_base_name$vm"
    mkdir bulk-vms/$vm_name
    new_disk="bulk-vms/$vm_name/$vm_name.vmdk"
    #echo "$new_disk"
    vmkfstools -i $original_disk $new_disk -d thin
done