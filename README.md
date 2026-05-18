# Cloud Security: Virtual Datacenter (vDC) Architecture

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Security Controls](#security-controls)
3. [Tech Stack](#tech-stack)
4. [Engineering Outcomes](#engineering-outcomes)
5. [Code Snippet](#code-snippet)


## Architecture Overview
* **Dual‑NIC Network Segmentation**
  * **NIC 1 (Web-Net):** Public-facing subnet (`10.0.10.0/24`) for application traffic and Nginx.
  * **NIC 2 (Mgmt-Net):** Internal subnet (`10.0.20.0/24`) for domain communication, DNS, and administrative access.
* **Identity Integration:** Ubuntu nodes are joined to a Windows Active Directory domain (`group6.local`) using SSSD and Realmd.
* **Secure Access:** A WireGuard VPN server provides encrypted access for administrators.

## Security Controls
* **Interface-Based Firewalls:** UFW rules applied per interface to separate web, DNS/AD, and VPN traffic.
* **Security Groups:** `sg-web` for HTTP traffic and `sg-ad` for DNS/AD protocols.
* **SSH Hardening:** Root login disabled and access restricted to approved Floating IP ranges.
* **User Session Handling:** PAM configured to create home directories for AD users on login.

## Tech Stack
* **Platform:** Virtuozzo Cloud  
* **OS:** Ubuntu 22.04 LTS, Windows Server 2022  
* **Security:** WireGuard, UFW, Security Groups  
* **Identity:** Active Directory, SSSD, Kerberos, Realmd  
* **Web:** Nginx  

## Engineering Outcomes
- Designed a segmented cloud network with isolated public and management zones.  
- Integrated Linux systems with Active Directory for centralized authentication.  
- Configured secure VPN access for remote administration.  
- Applied practical host-level and cloud-level security controls.

## Code Snippet

Below is the core Bash automation script used in the vDC project.  
It configures firewall rules, SSH hardening, package installation, and prepares the node for AD integration.

```bash
#!/bin/bash

# Project: Virtual Datacenter (vDC) Security Setup
# Purpose: Configure dual-NIC security, firewall rules, and AD prerequisites
# Environment: Ubuntu 22.04 LTS (Virtuozzo Cloud / Infrastructure)

LOGFILE="/var/log/vdc-security-setup.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOGFILE"
}

# Root check
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root." >&2
    exit 1
fi

log "=== Starting vDC Security Configuration ==="

# Install packages
apt update -y
apt install -y nginx realmd sssd sssd-tools adcli krb5-user wireguard

# Firewall rules
ufw default deny incoming
ufw allow in on eth0 to any port 80
ufw allow in on eth1 to any port 53
ufw allow 51820/udp
ufw --force enable

log "Firewall rules applied."

# SSH Hardening
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

log "SSH configuration updated."
log "=== vDC Security Setup Complete ==="


## Skills Matrix

| Skill Area          | Technologies Used                          | Demonstrated Through                                  |
|---------------------|--------------------------------------------|-------------------------------------------------------|
| Network Segmentation| Dual-NIC, Subnets                          | Web-Net and Mgmt-Net separation                       |
| Identity Integration| AD, SSSD, Realmd, Kerberos                 | Joining Ubuntu to Windows AD                          |
| VPN & Remote Access | WireGuard                                 | Secure admin access                                   |
| Host Security       | UFW, SSH Hardening                         | Interface-based firewall rules, disabling root login  |

