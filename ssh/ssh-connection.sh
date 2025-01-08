#!/bin/bash

# 1. Prompt the user to enter the username for the nodes
echo "Please enter the username for the nodes:"
read NODE_USER

# 2. Prompt the user to enter the password for username
echo "Please enter password for $NODE_USER:"
read -s PASSWORD

# 3. Check if .ssh directory exists
if [ -d ~/.ssh ]; then
    echo ".ssh directory already exists."
else
    echo ".ssh directory does not exist. Creating .ssh directory..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh  
    chown "$USER:$USER" ~/.ssh 
fi

# 4. Check if SSH keys already exist, if not create them
if [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH keys already exist, skipping key generation."
else
    echo "SSH keys not found, generating a new key pair..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" 
    chmod 600 ~/.ssh/id_rsa  
    chmod 644 ~/.ssh/id_rsa.pub 
    chown "$USER:$USER" ~/.ssh/id_rsa ~/.ssh/id_rsa.pub  
fi

# 5. Check if sshpass is installed, and install it if necessary
if ! command -v sshpass &> /dev/null; then
    echo "sshpass not found. Installing sshpass..."
    sudo apt-get update && sudo apt-get install -y sshpass
else
    echo "sshpass is already installed."
fi

# 6. Replace with actual IPs or hostnames of your nodes
K8S_NODES=("IP-1" "IP-2" "IP-3") 

# 7. Loop through the nodes, copy SSH key, and test SSH connectivity
for NODE in "${K8S_NODES[@]}"; do
    # Put 1 & 2  here if each node has different username & password
    
    echo "Copying SSH key to $NODE..."
    sshpass -p "$PASSWORD" ssh-copy-id -i ~/.ssh/id_rsa.pub "$NODE_USER@$NODE" || { echo "Error copying SSH key to $NODE"; exit 1; }

    echo "Testing SSH connectivity to $NODE ..."
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$NODE_USER@$NODE" "echo Connection to $NODE successful! " || { echo "Error testing SSH to $NODE"; exit 1; }
done

echo "SSH setup complete."
