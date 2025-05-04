#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "=========================="
echo "Installing Terraform..."
echo "=========================="
sudo apt-get update
sudo apt-get install -y wget gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt-get update
sudo apt-get install -y terraform

echo "=========================="
echo "Installing kubectl..."
echo "=========================="
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "=========================="
echo "Installing AWS CLI..."
echo "=========================="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install -y unzip
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "=========================="
echo "Installing Docker..."
echo "=========================="
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker "$USER"

echo ""
echo "=================================="
echo "All installations completed!"
echo "=================================="
echo "You may need to log out and log back in for Docker group changes to take effect."

# ==========================
# Version Check Commands
# ==========================
# Uncomment the lines below to verify installed versions

# echo "Terraform version:"
# terraform version

# echo "kubectl version:"
# kubectl version --client

# echo "AWS CLI version:"
# aws --version

# echo "Docker version:"
# docker --version

# echo "Docker Compose version:"
# docker compose version
