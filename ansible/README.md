# ansible
This directory houses all the files that relate to ansible. Ansible was used to configure the Windows 10 clients in the environment. To use the files in this directory you would simply run the command `ansible-playbook -i inventory.txt -k windows-provision.yml` while in this directory. Note that the `-k` flag is the same as `--ask-pass` and is not required if you are using SSH keys. 

## ansible.cfg
This is the ansible configuration file. Have this in your working directory when running the playbook and it will use these settings. Note that if the file is world writable ansible will not use it. You can also put the settings in the `/etc/ansible/ansible.cfg` file. Currently, the file only disables the checking of host keys. 

## inventory.txt
This is the inventory file used by ansible for this deployment. This inventory file contains all the hosts' IP addresses, their hostname, and some vars for the SSH connections Windows 10. 

## windows-provision.yml
This file is the playbook used to provision the Windows 10 workstations. The playbook simply names and joins the system to the domain and changes the power settings to ensure the system is always awake for future playbooks. 