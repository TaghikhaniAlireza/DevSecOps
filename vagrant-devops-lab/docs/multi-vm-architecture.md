content = '''# Step 5 – Multi-VM Architecture (Noyan DevOps Lab)

## Overview
This document describes the infrastructure architecture of the **Noyan Multi-VM DevOps Lab** built using **Vagrant** and **VirtualBox**. The goal of this step is to define and freeze the infrastructure design before any provisioning or configuration management is applied.

---

## Architecture Goals
- Simulate a real-world DevOps environment
- Enforce clear separation of responsibilities between nodes
- Provide a stable foundation for provisioning, Ansible, CI/CD, and security steps
- Keep the repository clean, readable, and production-oriented

---

## Virtual Machines Overview

| VM Name | Hostname | Role |
|------|---------|------|
| Noyan_Control | noyan-control | Control Plane (Ansible, CI/CD later) |
| Noyan_App | noyan-app | Application Server |
| Noyan_DB | noyan-db | Database Server |

All virtual machines are based on:
- **OS:** Ubuntu 22.04 LTS (jammy)
- **Provider:** VirtualBox
- **Managed by:** Vagrant

---

## Network Design

A **host-only private network** is used to allow internal communication between VMs while keeping them isolated from external networks.

| VM | Private IP Address |
|--|--|
| Noyan_Control | 192.168.56.10 |
| Noyan_App | 192.168.56.11 |
| Noyan_DB | 192.168.56.12 |

### Design Rationale
- Static IPs simplify Ansible inventory management
- Predictable addressing improves debugging and documentation
- Private network increases security and isolation

---

## Resource Allocation

| VM | RAM | CPU |
|--|--|--|
| Noyan_Control | 2048 MB | 2 |
| Noyan_App | 1536 MB | 1 |
| Noyan_DB | 1536 MB | 1 |

Resources are intentionally conservative to ensure compatibility with local development machines.

---

## Naming Convention

All virtual machines follow a strict naming convention:

