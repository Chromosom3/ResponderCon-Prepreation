# ResponderCon-Prepreation
This repository houses all of the automation scripts/playbooks I made in support of the ResponderCon RansomCare Workshop. I worked on this project under Professor Ali Hadi of Champlain College. My tasking on the project was to automate the deployment of an environment that could facilitate a ransomware tabletop exercise. I also acted in a sysadmin capacity to build and maintain systems in support of this project. See the sections below for more information on the various scripts in this repository.

## ansible
This directory houses all the files that relate to ansible. Ansible was used to configure the Windows 10 clients in the environment. To use the files in this directory you would simply run the command `ansible-playbook -i inventory.txt -k windows-provision.yml` while in this directory. Note that the `-k` flag is the same as `--ask-pass` and is not required if you are using SSH keys. 

## linux-automation
This houses all the files designed to be run on a Linux host in the environment. Ideally, scripts in this directory are intended to fully build the services required for the system to operate in the workshop environment.

## vm-provisioning
The `vm-provisioning` directory stores all the files pertaining to the automatic creation of virtual machines on ESXi. These scripts were designed to run on a single ESXi server with no vCenter Server Appliance running. This means some functionality of the vSphere environment was not present. For this reason, some creative approaches were taken.

## windows-automation
This directory contains files that relate to the automation of tasks on Windows host via PowerShell. These files are intended to be moved on Windows hosts and then executed to configure the host for the tabletop scenario. 