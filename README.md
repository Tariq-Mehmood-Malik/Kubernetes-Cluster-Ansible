# Kubernetes Cluster Setup with Ansible

This repository contains Ansible playbooks with SSH scripts for creating a Kubernetes cluster on Ubuntu nodes.

## Prerequisites
- Ubuntu server nodes (at least 2) for the master and worker node.
- SSH access to all nodes.
- Ansible installed on your local machine.

## Setup Steps

1. **Run SSH Script**:
   - First edit & run `ssh-connection.sh` script to set up SSH access to all of your Ubuntu nodes.
   - Please note that username will be same for all nodes.
   - Script will ask for user password for each node to execute script.
     
2. **Configure Ansible**: 
   - Edit an `inventory` file with your nodes details.

3. **Deploy Kubernetes**:
   - Run ansible playbook.
     ```bash
     ansible-playbook -i ./inventory playbook.yml
     ```

4. **Cluster Creation**:
   - Follow steps mention in this [repository](https://github.com/Tariq-Mehmood-Malik/Kubernetes-Cluster-Creation?tab=readme-ov-file#cluster-creation) & feel free to contact me if need any help.  

## Scripts and Playbooks
- `ssh/ssh-connection.sh.sh`: Script to set up SSH access for your Ubuntu servers.
- `ansible/playbook.yml`: Ansible playbook to configure Kubernetes on all nodes.
- `ansible/inventory.ini`: Inventory file with all nodes details.

