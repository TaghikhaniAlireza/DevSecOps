# Networking Architecture

This document describes the networking model of the Vagrant-based DevSecOps lab.
All networking decisions are intentional, minimal, and aligned with the lab’s
security and educational goals.

---

## 1. Networking Overview

The lab uses a **private, host-only network** to interconnect multiple virtual
machines while keeping them isolated from external networks.

Key characteristics:

- No public IP addresses
- No external inbound exposure
- Explicit inter-node communication rules
- Network segmentation aligned with application tiers

---

## 2. Network Topology

The environment consists of three nodes connected to the same private network:
192.168.56.0/24

### Logical Topology

| Node | Hostname | IP Address | Role |
|----|----|----|----|
| Control | `noyan-control` | `192.168.56.10` | Ansible controller |
| App | `noyan-app` | `192.168.56.11` | Web / Application - Nginx |
| DB | `noyan-db` | `192.168.56.12` | Database - PostgreSQL |

All communication occurs within this isolated network.

---

## 3. IP Addressing Scheme

Static IP addressing is used to ensure:

- Predictable Ansible inventory
- Stable firewall rules
- Explicit trust relationships

| Node | Hostname | IP Address | Role |
|----|----|----|----|
| Control | `noyan-control` | `192.168.56.10` | Ansible controller |
| App | `noyan-app` | `192.168.56.11` | Web / Application |
| DB | `noyan-db` | `192.168.56.12` | Database |

---

## 4. Network Isolation Model

### Host-Only / Private Network

- Nodes are **not reachable from external networks**
- Communication is limited to:
  - Other VMs in the lab
  - The host machine (for testing/debugging)

There is no routing or NAT-based exposure configured between nodes.

---

## 5. East-West Traffic Control

Inter-node (east-west) traffic is explicitly controlled using **iptables** rules
defined in Ansible.

### Allowed Flows

| Source | Destination | Port | Purpose |
|----|----|----|----|
| Any node | Any node | 22/TCP | SSH management |
| App | DB | 5432/TCP | PostgreSQL |
| Any | App | 80/TCP | HTTP |

### Denied by Default

All other inbound traffic is denied via default `DROP` policies.

---

## 6. Database Network Segmentation

PostgreSQL is intentionally isolated:

- Listens only on:
localhost, 192.168.56.12

```text
- Accepts connections only from:
192.168.56.11/32
```

This enforces a **single trusted client model** and prevents lateral movement
from other nodes.

---

## 7. Control Node Networking Role

The control node:

- Acts only as an **orchestrator**
- Does not expose application services
- Uses SSH over the private network for management

No application or database ports are opened on the control node.

---

## 8. Firewall as a Network Boundary

Although all nodes share the same subnet, **firewall rules act as the real
network boundary**.

Key principles:

- Same subnet ≠ full trust
- Network access is defined by role, not proximity
- Default-deny model enforced on every node

---

## 9. What This Networking Model Does NOT Include

This lab intentionally excludes:

- Load balancers
- Reverse proxies
- VLANs or multiple subnets
- Service mesh
- Overlay networking
- IPv6 configuration

These are omitted to keep the focus on **clarity and security fundamentals**.

---

## 10. Design Rationale

This networking model is designed to:

- Be easy to reason about
- Support strict firewall-based segmentation
- Align with Infrastructure-as-Code practices
- Serve as a foundation for future extensions

The simplicity of the network is a feature, not a limitation.

---
