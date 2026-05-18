# Cloud Security: Virtual Datacenter (vDC) Architecture

This project demonstrates how to secure a virtual datacenter using network segmentation, dual‑NIC design, and centralized identity management. The environment is deployed on Virtuozzo Cloud and separates public web traffic from internal management and directory services.

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
