#!/bin/bash

# Raspberry Pi OS Lite (64-bit) Debian Bookworm Setup Script
# This script should be run as root or with sudo

# Set up error handling
set -e
exec 1> >(tee "setup_log.txt")
exec 2>&1

echo "Starting Raspberry Pi OS Lite (64-bit) setup script..."
echo "============================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo)"
    exit 1
fi

# Interactive configuration
echo "Please configure which services you want to enable:"

read -p "Enable UFW firewall? (y/n): " ENABLE_UFW
read -p "Enable fail2ban? (y/n): " ENABLE_FAIL2BAN
read -p "Enable SSH server? (y/n): " ENABLE_SSH
read -p "Add ll alias to .bashrc? (y/n): " ENABLE_LL_ALIAS

echo "Configuration complete. Starting installation..."
echo "============================================"

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
    python3-pip \
    python3-venv \
    tmux \
    wget \
    curl \
    unzip \
    net-tools

# Install and configure optional packages based on user choice
if [ "$ENABLE_UFW" = "y" ]; then
    echo "Installing and configuring UFW firewall..."
    apt-get install -y ufw
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw --force enable
fi

if [ "$ENABLE_FAIL2BAN" = "y" ]; then
    echo "Installing and configuring fail2ban..."
    apt-get install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
fi

if [ "$ENABLE_SSH" = "y" ]; then
    echo "Enabling and starting SSH..."
    touch /boot/ssh
    systemctl enable ssh
    systemctl start ssh
fi

if [ "$ENABLE_LL_ALIAS" = "y" ]; then
    echo "Adding ll alias to .bashrc..."
    echo "alias ll='ls -la'" >> ~/.bashrc
fi

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