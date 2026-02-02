# Noyan DevSecOps Laboratory

Welcome to the **Noyan DevSecOps Lab** documentation. This project provides a fully automated, local infrastructure designed to simulate a real-world production environment. It focuses on **Infrastructure as Code (IaC)**, **Configuration Management**, and **Security Hardening** using industry-standard tools.

## Project Goal
The primary objective of this laboratory is to demonstrate how to build, configure, and secure a multi-tier architecture automatically. It serves as an educational platform for:
*   **DevOps:** Automating VM provisioning with Vagrant.
*   **SecOps:** Implementing security baselines (Hardening) using Ansible.
*   **SysAdmin:** Managing Linux (Ubuntu) environments.

## Key Features
*   **Multi-VM Architecture:** Simulates a realistic 3-tier setup (Control, App, Database).
*   **Automated Provisioning:** "Zero-touch" setup using Vagrant and Shell scripts.
*   **Configuration Management:** Uses Ansible to manage state and software.
*   **Isolated Network:** Uses a private network (`192.168.56.x`) for VM communication.
*   **Development Ready:** Source code is synced directly to the Control Node for easy development.

## Technology Stack

| Component | Technology | Version / Details |
| :--- | :--- | :--- |
| **Hypervisor** | VirtualBox | Provider for VMs |
| **Orchestration** | Vagrant | VM Lifecycle Management |
| **OS** | Ubuntu Linux | 22.04 LTS (Jammy Jellyfish) |
| **Config Mgmt** | Ansible | Provisioning & Hardening |
| **Scripting** | Bash / Shell | Initial Bootstrapping |

## Getting Started
To get this environment up and running, please refer to the following documents in order:
1.  [Prerequisites](./prerequisites.md) - Tools you need to install.
2.  [Architecture Overview](./architecture.md) - Understanding the topology.
3.  [Network Configuration](./networking.md) - IP allocations and connectivity.

---
*Maintainer: AliReza | Project: Noyan DevSecOps Environment*
