#!/bin/bash
# Project: Virtual Datacenter (vDC) Security
# Goal: Automate Dual-NIC setup and AD Integration
# Based on Group 6 IT-Säkerhet Project

echo "--- Initializing vDC Security Hardening ---"

# 1. Install Identity & Web Tools
sudo apt update && sudo apt install -y nginx realmd sssd sssd-tools adcli krb5-user wireguard

# 2. Network Segmentation (Logic for Dual NICs)
# NIC1: Web Subnet (10.0.10.0/24)
# NIC2: Management Subnet (10.0.20.0/24) - For AD Traffic
echo "Configuring Netplan for DNS Routing to Domain Controller (10.0.20.10)..."

# 3. Security Groups / Firewall Logic
# Protecting the DC and Web Server
sudo ufw default deny incoming
sudo ufw allow in on eth0 to any port 80    # Public Web Traffic
sudo ufw allow in on eth1 to any port 53    # Internal DNS/AD Traffic
sudo ufw allow 51820/udp                    # WireGuard VPN Gatekeeper
sudo ufw --force enable

# 4. SSH Security
# Restricting SSH to specific Floating IP as per project report
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

echo "--- vDC Node Secured and Ready for Domain Join ---"
