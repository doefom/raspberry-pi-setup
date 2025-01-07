# Raspberry Pi Setup Scripts

This repository contains setup scripts for various Raspberry Pi OS versions. The scripts automate the installation and configuration of essential packages, security settings, and system configurations.

## Quick Setup Commands

### System Updates
```bash
sudo apt-get update
sudo apt-get full-upgrade -y
```

### Essential Tools
```bash
sudo apt-get install -y vim git htop tmux wget curl unzip net-tools
```

### UFW Firewall
```bash
sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
```

### Fail2ban
```bash
sudo apt-get install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### SSH Server
```bash
sudo touch /boot/ssh
sudo systemctl enable ssh
sudo systemctl start ssh
```

### Docker

Docs: https://docs.docker.com/engine/install/debian/#install-using-the-repository

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Then run:
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Verify Docker installation:
```bash
sudo docker run hello-world
```

#### Running Docker without sudo

Docs: https://docs.docker.com/engine/install/linux-postinstall/

```bash
sudo groupadd docker # group probably already exists
sudo usermod -aG docker $USER
newgrp docker
```

### Useful Aliases
```bash
echo "alias ll='ls -la'" >> ~/.bashrc
```

## Automated Setup Script

If you prefer to run the complete automated setup script that includes all the above configurations with interactive prompts, you can use:

### Raspberry Pi OS Lite (64-bit) - Debian Bookworm

Compatible with Raspberry Pi 3/4/400/5 and Pi Zero 2 W.

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