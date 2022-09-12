# ansible
This directory houses all the files that relate to ansible. Ansible was used to configure the Windows 10 clients in the environment. To use the files in this directory you would simply run the command `ansible-playbook -i inventory.txt -k windows-provision.yml` while in this directory. Note that the `-k` flag is the same as `--ask-pass` and is not required if you are using SSH keys. 

## ansible.cfg
This is the ansible configuration file. Have this in your working directory when running the playbook and it will use these settings. Note that if the file is world writable ansible will not use it. You can also put the settings in the `/etc/ansible/ansible.cfg` file. Currently, the file only disables the checking of host keys. 

## inventory.txt
This is the inventory file used by ansible for this deployment. This inventory file contains all the hosts' IP addresses, their hostname, and some vars for the SSH connections Windows 10. 

## windows-disable-defender.yml
The commands in this playbook disable Windows Defender on a Windows 10 host. Specifically, it disabled anti-spyware, real-time monitoring, and sample submissions. Additionally, it also adds an exclusion for the C: drive on the Windows system. 

## windows-ipconfig-renew.yml
This simple playbook just issues the `ipconfig /renew` command to Windows hosts. This could also probably be done by using the module at the command line instead of calling a playbook. 

## windows-local-admin.yml
Another simple playbook. This one is used to add domain users to the local administrator group on all the targeted workstations. This was used in this workshop so they could run tools at the appropriate permissions level. 

## windows-move-files.yml
This playbook contains a simple PowerShell one-liner that moves files from one directory to another. This was used because tools were put on the wrong user profile for the workshop. The current script moves the files to the "Public Desktop" allowing all users to access the tools/files.

## windows-provision.yml
This file is the playbook used to provision the Windows 10 workstations. The playbook simply names and joins the system to the domain and changes the power settings to ensure the system is always awake for future playbooks. 

## windows-rdp.yml
This playbook is intended to enable RDP on a Windows 10 system as well as add the domain users group to the local remote desktop users group. Note if this is combined with the local admin playbook you don't need the line to add people to the remote desktop group. Administrators are already a member of that group. 

## windows-run-malware.yml
This simple playbook just runs an executable on hosts and then keeps the connection alive long enough for the malware to establish persistence. Note the ansible sleep method will not keep the process running. You need to have the `Start-Sleep` in the win_shell line. Since this is intended to run idling for an hour you don't want to run this on your primary shell. You can use screen or something else to have it run in the background. 