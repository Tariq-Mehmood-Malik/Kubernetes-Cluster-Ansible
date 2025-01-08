# Kubernetes Cluster Setup with Ansible

This repository contains Ansible playbooks with shell script for installing Kubernetes and container runtime (containerd) on Ubuntu OS nodes.

## Prerequisites
- Ubuntu server nodes (at least 2) for the master and worker node.
- Ansible installed on your local/ Controller machine.

## Setup Steps

1. **Run SSH Script (Optional)**:
   - Perform this step if your Ansible Infrastructure is not set.
   - Edit & run `ssh-connection.sh` script on controller machine to set up SSH access to all of your nodes.
   - Script will ask username, which will be same for all nodes (you can modify script if each node has different username).
   - Script will ask for user password, which will be same for all nodes (you can modify script if each node has different password).
   - Make sure `passwordless sudo privileges` is set on each node for target user.
     
2. **Configure Ansible**: 
   - Edit an `inventory.ini` file with your nodes details.

3. **Deploy Kubernetes**:
   - Run ansible playbook.
     
     ```bash
     ansible-playbook -i ./inventory.ini playbook.yaml
     ```
     ***
   - If  `passwordless sudo privileges` are set try run below command:
     
     ```bash
     ansible-playbook -i ./inventory.ini playbook.yaml --ask-become-pass
     ```
     
     Make sure each node has same username & password.


4. **Cluster Creation**:
   - Follow steps mention in this [repository](https://github.com/Tariq-Mehmood-Malik/Kubernetes-Cluster-Creation?tab=readme-ov-file#cluster-creation) & feel free to contact me if need any help.  

## Scripts and Playbooks
- `ssh/ssh-connection.sh.sh`: Script to set up SSH access for your Ubuntu servers.
- `ansible/playbook.yml`: Ansible playbook to configure Kubernetes on all nodes.
- `ansible/inventory.ini`: Inventory file with all nodes details.

