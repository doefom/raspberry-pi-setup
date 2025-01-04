#!/bin/bash

# Raspberry Pi Zero 2 W Setup Script
# This script should be run as root or with sudo

# Set up error handling
set -e
exec 1> >(tee "setup_log.txt")
exec 2>&1

echo "Starting Raspberry Pi Zero 2 W setup script..."
echo "============================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo)"
    exit 1
fi

# Update and upgrade system
echo "Updating system packages..."
apt-get update
apt-get full-upgrade -y

# Install essential packages
echo "Installing essential packages..."
apt-get install -y \
    vim \
    git \
    htop \
    fail2ban \
    ufw \
    python3-pip \
    python3-venv \
    tmux \
    wget \
    curl \
    unzip \
    net-tools

# Configure UFW (firewall)
echo "Configuring firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Configure fail2ban
echo "Configuring fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban

# Enable SSH if not enabled
echo "Enabling SSH..."
touch /boot/ssh

# Add ll alias to .bashrc
echo "Adding ll alias to .bashrc..."
echo "alias ll='ls -la'" >> ~/.bashrc

# Final system update
echo "Performing final system update..."
apt-get update
apt-get full-upgrade -y
# apt-get autoremove -y
apt-get clean

echo "============================================"
echo "Setup completed successfully!"
echo "Please reboot your Raspberry Pi to apply all changes."
echo "You can review the setup log in setup_log.txt"
echo "============================================"
