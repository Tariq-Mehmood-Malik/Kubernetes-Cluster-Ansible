#!/bin/bash

# Prompt the user to enter the username for the nodes
echo "Please enter the username for the nodes:"
read NODE_USER

# Check if SSH keys already exist on local machine, if not create them
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH keys not found, generating a new key pair..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
else
    echo "SSH keys already exist, skipping key generation."
fi

# Set the list of nodes for your Kubernetes setup
# Replace with actual IPs or hostnames of your nodes
K8S_NODES=("192.168.0.162")

# Loop through the nodes and copy the public key to each node
# Use the user entered for nodes
for NODE in "${K8S_NODES[@]}"; do
    echo "Copying SSH key to $NODE..."
    ssh-copy-id -i ~/.ssh/id_rsa.pub "$NODE_USER@$NODE"
    
    # Add the user to the sudoers file for passwordless sudo access
    echo "Configuring passwordless sudo for $NODE_USER on $NODE..."
    ssh "$NODE_USER@$NODE" "echo '$NODE_USER ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$NODE_USER > /dev/null"
done

# Test SSH connectivity and passwordless sudo
echo "Testing SSH connectivity and passwordless sudo to all nodes..."
for NODE in "${K8S_NODES[@]}"; do
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$NODE_USER@$NODE" "echo Connection to $NODE successful! && sudo -n true && echo Passwordless sudo working on $NODE!"
done

echo "SSH and passwordless sudo setup complete."
