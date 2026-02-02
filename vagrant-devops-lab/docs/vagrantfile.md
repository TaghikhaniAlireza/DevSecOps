# Vagrantfile Documentation

## Overview
This document explains the structure and design decisions of the `Vagrantfile` used in the **Noyan DevSecOps Environment**. The configuration defines a multi-VM local lab that simulates a real-world DevSecOps infrastructure using role separation and private networking.

The Vagrantfile is located at the root of the project and serves as the single source of truth for infrastructure provisioning.

---

## Vagrant Configuration Version
```ruby
Vagrant.configure("2") do |config|
```
- Uses **Vagrant configuration version 2**
- Ensures compatibility with modern Vagrant features and providers

---

## Base Box Configuration
```ruby
config.vm.box = "ubuntu/jammy64"
```
- All virtual machines are based on **Ubuntu 22.04 LTS (Jammy Jellyfish)**
- Guarantees a consistent and reproducible operating system across all nodes

---

## Global Synced Folder
```ruby
config.vm.synced_folder ".", "/vagrant"
```
- Syncs the project root directory from the host to `/vagrant` on all VMs
- Enables access to shared files, scripts, and documentation
- Useful for debugging and inspection during development

---

## Control Node – `noyan-control`

### Definition
```ruby
config.vm.define "noyan-control" do |control|
```

### Network Configuration
```ruby
control.vm.hostname = "noyan-control"
control.vm.network "private_network", ip: "192.168.56.10"
```
- Static private IP ensures predictable connectivity
- Acts as the **control plane** of the lab

### Provider Resources
```ruby
control.vm.provider "virtualbox" do |vb|
  vb.name   = "noyan-control"
  vb.memory = 1536
  vb.cpus  = 2
end
```
- Allocated more resources than other nodes
- Designed to run orchestration and automation tools (e.g. Ansible)

### Provisioning
```ruby
control.vm.provision "shell", path: "provisioning/shell/common.sh"
control.vm.provision "shell", path: "provisioning/shell/control.sh"
```
- `common.sh`: baseline configuration shared across all nodes
- `control.sh`: control-node-specific setup

### Ansible Synced Folder
```ruby
control.vm.synced_folder "provisioning/ansible", "/home/devops/ansible",
  owner: "devops",
  group: "devops"
```
- Makes Ansible playbooks available inside the control node
- Ensures correct ownership for the `devops` user

---

## Application Node – `noyan-app`

### Definition and Network
```ruby
config.vm.define "noyan-app" do |app|
  app.vm.hostname = "noyan-app"
  app.vm.network "private_network", ip: "192.168.56.11"
end
```

### Provider Resources
```ruby
app.vm.provider "virtualbox" do |vb|
  vb.name   = "noyan-app"
  vb.memory = 1024
  vb.cpus  = 1
end
```
- Lightweight configuration suitable for application workloads

### Provisioning
```ruby
app.vm.provision "shell", path: "provisioning/shell/common.sh"
app.vm.provision "shell", path: "provisioning/shell/app.sh"
```
- `app.sh` handles application-specific setup

---

## Database Node – `noyan-db`

### Definition and Network
```ruby
config.vm.define "noyan-db" do |db|
  db.vm.hostname = "noyan-db"
  db.vm.network "private_network", ip: "192.168.56.12"
end
```

### Provider Resources
```ruby
db.vm.provider "virtualbox" do |vb|
  vb.name   = "noyan-db"
  vb.memory = 1024
  vb.cpus  = 1
end
```

### Provisioning
```ruby
db.vm.provision "shell", path: "provisioning/shell/common.sh"
db.vm.provision "shell", path: "provisioning/shell/db.sh"
```
- `db.sh` is responsible for database-layer preparation

---

## Networking Model
- All nodes use a **private network (192.168.56.0/24)**
- No public or forwarded ports are defined
- Communication is restricted to internal VM-to-VM traffic

---

## Design Principles
- **Separation of Concerns**: each VM has a single, clear responsibility
- **Reproducibility**: static IPs and pinned base box
- **Extensibility**: prepared for further automation via Ansible

---

## Summary
This Vagrantfile provides a clean, modular, and realistic foundation for a DevSecOps lab. It focuses on clarity, role separation, and infrastructure best practices while remaining simple enough for learning and experimentation.
