# Kubernetes Cluster Setup with Ansible

This repository contains Ansible playbooks and SSH scripts for creating a Kubernetes cluster on Ubuntu nodes.

## Prerequisites
- Ubuntu server nodes (at least 2) for the master and worker node.
- SSH access to all nodes
- Ansible installed on your local machine

## Setup Steps

1. **Run SSH Script**: First, run the `scripts/setup_ssh.sh` script to set up SSH access to your Ubuntu nodes.

2. **Configure Ansible**: 
   - Create an `inventory` file with your server details (master and worker nodes).
   - Run the Ansible playbooks to set up Kubernetes.

3. **Deploy Kubernetes**: The playbooks will deploy the Kubernetes cluster.

## Scripts and Playbooks
- `scripts/setup_ssh.sh`: Script to set up SSH access for your Ubuntu servers.
- `ansible/setup_k8s_master.yml`: Ansible playbook to configure Kubernetes master node.
- `ansible/setup_k8s_worker.yml`: Ansible playbook to configure Kubernetes worker nodes.

