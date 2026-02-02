# Prerequisites

This document describes all required tools, software, and basic knowledge needed to run and understand the **Noyan DevSecOps Vagrant Lab**.

This lab is designed to be both **hands-on** and **educational**, so understanding the prerequisites will help you get the most value from it.

---

## 1. Operating System Requirements

This lab is developed and tested on:

- Windows 10 / 11 (64-bit)
- macOS (Intel or Apple Silicon)
- Linux (Ubuntu/Debian-based)

> Windows users **must** enable virtualization from BIOS/UEFI.

---

## 2. Hardware Requirements

Minimum recommended system specifications:

- **CPU:** 4 cores (Virtualization enabled)
- **RAM:** 8 GB (16 GB recommended)
- **Disk Space:** At least 30 GB free
- **Virtualization:** Intel VT-x or AMD-V enabled

---

## 3. Required Software

### 3.1 VirtualBox

VirtualBox is used as the virtualization provider for Vagrant.

- Version: **7.x recommended**
- Download: https://www.virtualbox.org

Make sure the VirtualBox **Extension Pack** is also installed.

---

### 3.2 Vagrant

Vagrant is used to define and manage multi-VM environments.

- Version: **>= 2.3**
- Download: https://developer.hashicorp.com/vagrant/downloads

Verify installation:
```bash
vagrant --version
```
---

### 3.3 Vagrant Plugins (Optional but Recommended)

Some features may benefit from additional plugins:

- **vagrant-disksize** (for extending VM disk size)

Install:
```bash
vagrant plugin install vagrant-disksize
```

> This plugin is optional and currently commented in the `Vagrantfile`.

---

### 3.4 Git

Git is required to clone and manage the project source code.

- Version: Latest stable
- Download: https://git-scm.com

Verify:
```bash
git --version
```
---

### 3.5 SSH Client

SSH is required for VM access and Ansible communication.

- Windows:
  - OpenSSH (built-in on Windows 10/11)
  - Git Bash
- macOS / Linux:
  - Built-in OpenSSH

Verify:
```bash
ssh -V
```
---

## 4. Ansible Requirements

Ansible is executed **inside the control node** (`noyan-control`).

### 4.1 Control Node Design

- Ansible is **not required on the host machine**
- Ansible runs inside:
  - `noyan-control` VM
- Ansible files are synced to:
```bash
/home/devops/ansible
```
---

## 5. Networking Requirements

This lab uses **host-only private networking**.

### Assigned IP Addresses:

| VM Name        | IP Address        |
|---------------|-------------------|
| noyan-control | 192.168.56.10     |
| noyan-app     | 192.168.56.11     |
| noyan-db      | 192.168.56.12     |

Requirements:
- VirtualBox Host-Only Network enabled
- No conflict with existing networks

---

## 6. Required Knowledge (Recommended)

This lab is beginner-friendly but basic knowledge is helpful.

### Essential Concepts:
- Linux command line
- SSH
- Virtual Machines
- Basic networking (IP, subnet)

### Recommended Experience:
- Vagrant fundamentals
- Ansible basics (inventory, playbooks, roles)
- DevOps concepts
- Security hardening basics

---

## 7. User Permissions

The lab assumes the following Linux user exists inside VMs:

- **Username:** `devops`
- **Privileges:** passwordless sudo

This user is created and configured during VM provisioning.

---

## 8. Internet Access

An active internet connection is required for:

- Downloading base box (`ubuntu/jammy64`)
- Installing packages via `apt`
- Ansible role execution

---

## 9. Project Directory Structure

Before running the lab, ensure the project directory is intact:


vagrant-devops-lab/
├── Vagrantfile
├── docs/
├── provisioning/
│   ├── ansible/
│   └── shell/

---

## 10. Next Steps

Once all prerequisites are met, continue with:

**`first-vm.md`** – Launching and validating your first virtual machine.
