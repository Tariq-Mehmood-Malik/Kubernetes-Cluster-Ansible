#!/bin/bash

# Check if SSH keys already exist on local machine, if not create them
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH keys not found, generating a new key pair..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
else
    echo "SSH keys already exist, skipping key generation."
fi

# Set the list of nodes for your Kubernetes setup
# Replace with actual IPs or hostnames of your nodes
K8S_NODES=("IP-1/hostname" "IP-2/hostname" "IP-3/hostname")

# Loop through the nodes and copy the public key to each node
# Replace $USER with user name that is present on each node
for NODE in "${K8S_NODES[@]}"; do
    echo "Copying SSH key to $NODE..."
    ssh-copy-id -i ~/.ssh/id_rsa.pub "$USER@$NODE"
    
    # Add the user to the sudoers file for passwordless sudo access
    echo "Configuring passwordless sudo for $USER on $NODE..."
    ssh "$USER@$NODE" "echo '$USER ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$USER > /dev/null"
done

# Test SSH connectivity and passwordless sudo
echo "Testing SSH connectivity and passwordless sudo to all nodes..."
for NODE in "${K8S_NODES[@]}"; do
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$USER@$NODE" "echo Connection to $NODE successful! && sudo -n true && echo Passwordless sudo working on $NODE!"
done

echo "SSH and passwordless sudo setup complete."
