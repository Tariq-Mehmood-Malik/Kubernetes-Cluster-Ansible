#!/bin/bash

# Prompt the user to enter the username for the nodes
echo "Please enter the username for the nodes:"
read NODE_USER

# Check if SSH keys already exist on local machine, if not create them
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH keys not found, generating a new key pair..."
    mkdir -p ~/.ssh  # Ensure the .ssh directory exists
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""  # Generate the key
else
    echo "SSH keys already exist, skipping key generation."
fi

# Set the list of nodes for your Kubernetes setup
# Replace with actual IPs or hostnames of your nodes
K8S_NODES=("IP-1" "IP-2" "IP-3")  # Example IPs, add more nodes if needed

# Loop through the nodes and copy the public key to each node
for NODE in "${K8S_NODES[@]}"; do
    echo "Copying SSH key to $NODE..."
    ssh-copy-id -i ~/.ssh/id_rsa.pub "$NODE_USER@$NODE" || { echo "Error copying SSH key to $NODE"; exit 1; }
    
    # Add the user to the sudoers file on each node
    echo "Adding $NODE_USER to the sudoers file on $NODE..."
    ssh "$NODE_USER@$NODE" 'sudo grep -q "^'"$NODE_USER"' ALL=(ALL:ALL) ALL" /etc/sudoers || echo "'"$NODE_USER"' ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers' || { echo "Error adding $NODE_USER to sudoers on $NODE"; exit 1; }
done

# Test SSH connectivity and passwordless sudo
echo "Testing SSH connectivity and passwordless sudo to all nodes..."
for NODE in "${K8S_NODES[@]}"; do
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$NODE_USER@$NODE" "echo Connection to $NODE successful! && sudo -n true && echo Passwordless sudo working on $NODE!" || { echo "Error testing SSH or sudo on $NODE"; exit 1; }
done

echo "SSH, sudoers, and passwordless sudo setup complete."
