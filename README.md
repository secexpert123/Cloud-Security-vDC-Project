Cloud Security: Virtual Datacenter (vDC)
This project demonstrates a secure, segmented cloud environment built on Virtuozzo. It features a "Dual-Network" architecture to isolate management traffic from public web traffic.

Architecture Design
Dual-NIC Configuration:

NIC1 (Web-Net): Handles public application traffic (10.0.10.0/24).

NIC2 (Mgmt-Net): Isolated internal network for Active Directory communication (10.0.20.0/24).

Identity Management: Centralized Linux user management by joining Ubuntu nodes to a Windows Active Directory domain (group6.local) using SSSD and Realmd.

Gatekeeper: Deployed a WireGuard VPN server with IP Forwarding enabled to serve as the single secure entry point for administrators.

Security Implementations
Security Groups: Created sg-web (Port 80) and sg-ad (DNS/AD Protocols) to act as cloud-level firewalls.

Access Control: Restricted SSH access to specific Floating IP ranges.

Automation: Enabled PAM (Pluggable Authentication Modules) to automatically create home directories for AD users on Linux login.

Tech Stack
Platform: Virtuozzo Cloud

Operating Systems: Ubuntu 22.04 LTS, Windows Server 2022

Security & VPN: WireGuard, UFW, Security Groups

Identity: Active Directory, SSSD, Kerberos, Realmd

Web: Nginx

What I Learned
Network segmentation and security best practices.

Active Directory integration with Linux.

VPN configuration and access control.

Cloud infrastructure security.

Resources Used
WireGuard Documentation

SSSD Documentation

Ubuntu Active Directory Integration

Author: Student Cloud ICT Engineer (Learning Project)

Last Updated: March 2026
