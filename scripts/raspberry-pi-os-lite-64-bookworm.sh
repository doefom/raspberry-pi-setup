#!/bin/bash

# Raspberry Pi OS Lite (64-bit) Debian Bookworm Setup Script
# This script should be run as root or with sudo

# Set up error handling
set -e

# Setup logging while keeping stdin available for prompts
exec 1> >(tee -a "setup_log.txt")
exec 2> >(tee -a "setup_log.txt" >&2)

# Function to prompt for yes/no questions
prompt_yes_no() {
    while true; do
        printf "%s" "$1"
        read -r response < /dev/tty
        case $response in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

clear
echo "Starting Raspberry Pi OS Lite (64-bit) setup script..."
echo "============================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo)"
    exit 1
fi

# Interactive configuration
echo ""
echo "Please configure which services you want to enable."
echo "Type 'y' for yes or 'n' for no and press ENTER after each question."
echo ""

ENABLE_UFW=$(prompt_yes_no "Enable UFW firewall? (y/n): ")
ENABLE_FAIL2BAN=$(prompt_yes_no "Enable fail2ban? (y/n): ")
ENABLE_SSH=$(prompt_yes_no "Enable SSH server? (y/n): ")
ENABLE_LL_ALIAS=$(prompt_yes_no "Add ll alias to .bashrc? (y/n): ")

echo ""
echo "You selected:"
echo "UFW firewall: $ENABLE_UFW"
echo "fail2ban: $ENABLE_FAIL2BAN"
echo "SSH server: $ENABLE_SSH"
echo "ll alias: $ENABLE_LL_ALIAS"
echo ""

echo "Press ENTER to start installation or CTRL+C to cancel"
read -r < /dev/tty

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