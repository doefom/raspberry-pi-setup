# Raspberry Pi Setup Scripts

This repository contains setup scripts for various Raspberry Pi OS versions. The scripts automate the installation and configuration of essential packages, security settings, and system configurations.

## Available Scripts

### Raspberry Pi OS Lite (64-bit) - Debian Bookworm

Compatible with Raspberry Pi 3/4/400/5 and Pi Zero 2 W.

To run the setup script directly on your Raspberry Pi, use:

```bash
curl -sSL https://raw.githubusercontent.com/doefom/raspberry-pi-setup/refs/heads/main/scripts/raspberry-pi-os-lite-64-bookworm.sh | sudo bash
```

## What the scripts do

The setup scripts perform the following tasks:
- Update and upgrade system packages
- Install essential tools (vim, git, htop, etc.)
- Configure UFW firewall with basic rules
- Set up fail2ban for security
- Enable SSH access
- Configure useful aliases
- And more...

## Requirements

- Run the scripts as root or with sudo
- Active internet connection
- Fresh Raspberry Pi OS installation

## Logs

The setup process creates a `setup_log.txt` file in the current directory for troubleshooting. 