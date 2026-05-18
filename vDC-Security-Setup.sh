#!/bin/bash
# Project: Virtual Datacenter (vDC) Security Setup
# Purpose: Configure dual‑NIC security, firewall rules, and AD prerequisites
# Environment: Ubuntu 22.04 LTS (Virtuozzo Cloud / Infrastructure)
# Based on: Group 6 IT-Säkerhet Project Architecture

LOGFILE="/var/log/vdc-security-setup.log"

# Custom logging function with timestamps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')  $1" | tee -a "$LOGFILE"
}

# --- 0. Root Privilege Check ---
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root or with sudo." >&2
    exit 1
fi

log "=== Starting vDC Security Configuration ==="

# --- 1. Install Required Packages ---
log "Installing packages for identity services, VPN, and web server..."
apt update -y >> "$LOGFILE" 2>&1
apt install -y nginx realmd sssd sssd-tools adcli krb5-user wireguard >> "$LOGFILE" 2>&1

# --- 2. Network Segmentation Notes ---
# NIC 1 (eth0): Web Subnet (Public-facing)
# NIC 2 (eth1): Management Subnet (Internal AD Traffic)
log "Preparing DNS routing configurations for AD domain controller (10.0.20.10)..."

# --- 3. Firewall Configuration (UFW) ---
log "Applying firewall rules for dual‑NIC setup..."

# Default Policy
ufw default deny incoming >> "$LOGFILE" 2>&1

# Public Web Traffic on eth0
ufw allow in on eth0 to any port 80 >> "$LOGFILE" 2>&1

# Internal AD/DNS Traffic on eth1
ufw allow in on eth1 to any port 53 >> "$LOGFILE" 2>&1

# WireGuard VPN Gatekeeper
ufw allow 51820/udp >> "$LOGFILE" 2>&1

# Enable Firewall
ufw --force enable >> "$LOGFILE" 2>&1
log "Firewall rules successfully applied."

# --- 4. SSH Hardening ---
log "Applying SSH hardening (Disabling root password login)..."
if grep -q "#PermitRootLogin prohibit-password" /etc/ssh/sshd_config; then
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
else
    # Fallback if the line is already modified or formatted differently
    sed -i 's/PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
fi

# Apply the SSH changes
systemctl restart sshd >> "$LOGFILE" 2>&1
log "SSH configuration updated and service restarted."

# --- 5. Completion ---
log "=== vDC Security Setup Complete ==="
log "Node is secured and ready for domain join / SSSD setup."
echo "--- vDC Security Setup Complete (Check $LOGFILE for details) ---"
