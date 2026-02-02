# Architecture Overview

This document outlines the infrastructure topology, hardware specifications, and node roles defined in the `Vagrantfile`.

## High-Level Topology

The lab consists of **three virtual machines** running on a private network managed by VirtualBox. The Host machine (your PC) orchestrates the creation of these VMs via Vagrant.

graph TD
Host[Windows Host Machine] -- Vagrant --> VB[VirtualBox Hypervisor]

subgraph "Private Network (192.168.56.0/24)"
CN[noyan-control] -- SSH (Port 22) --> APP[noyan-app]
CN[noyan-control] -- SSH (Port 22) --> DB[noyan-db]
end

Host -- Synced Folder --> CN

## Virtual Machine Specifications

The environment uses **Ubuntu 22.04 (Jammy64)** as the base operating system for all nodes.

| Hostname | Role | IP Address | vCPU | RAM | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **noyan-control** | Ansible Controller | `192.168.56.10` | 2 | 1536 MB | The management node. It holds the Ansible inventory and playbooks. |
| **noyan-app** | Application Server | `192.168.56.11` | 1 | 1024 MB | Hosts the web application (Target Node). |
| **noyan-db** | Database Server | `192.168.56.12` | 1 | 1024 MB | Hosts the database service (Target Node). |

## 🔌 Integration & Data Flow

### 1. Provisioning Flow
*   **Shell Scripts:** Upon first boot, Vagrant executes `common.sh` on all nodes to install basic dependencies. Specific scripts (`control.sh`, `app.sh`, `db.sh`) run on respective nodes.
*   **Ansible Execution:** The `noyan-control` node is configured to run Ansible playbooks against itself (local connection) and the other two nodes via SSH.

### 2. Synced Folders
To facilitate development without needing to manually copy files:
*   **Source:** `./provisioning/ansible` (On Host)
*   **Destination:** `/home/devops/ansible` (On `noyan-control`)
*   **User/Group:** `devops:devops`

This allows you to edit Ansible playbooks on your Windows machine using VS Code, and the changes are immediately available inside the Control node.

### 3. User Access
According to the inventory configuration:
*   **Admin User:** `devops`
*   **Authentication:** SSH Private Key (`~/.ssh/id_rsa`)

