# Security Architecture & Hardening

This document describes the security controls implemented in this lab environment.
All security measures are applied **exclusively through Ansible** and are fully
code-driven.

> Scope: Host-level hardening, network controls, and service-level security  
> Environment: Vagrant-based multi-VM lab (Control, App, DB)

---

## 1. Security Model Overview

The security design follows a **layered (defense-in-depth)** approach:

- **System Hardening** (OS-level)
- **Network Security** (iptables-based firewall)
- **Service Hardening**
  - SSH
  - Nginx (App node)
  - PostgreSQL (DB node)

Security is enforced via the following Ansible roles:

| Role | Purpose |
|----|----|
| `preflight` | Safety checks before applying changes |
| `system_hardening` | OS, SSH, firewall hardening |
| `nginx_hardening` | Secure Nginx baseline |
| `postgresql_baseline` | Secure PostgreSQL baseline |

---

## 2. Preflight Safety Controls

Before applying any configuration, the `preflight` role ensures:

- Controlled execution order
- Defined defaults and variables
- Safe role metadata and dependency handling
- A testable structure (`tests/` directory)

This role reduces the risk of misconfiguration during early provisioning stages.

---

## 3. System Hardening (All Nodes)

Implemented via `roles/system_hardening`.

### 3.1 Base OS Configuration

- Timezone enforced: `Asia/Tehran`
- Locale enforced: `en_US.UTF-8`
- Time synchronization enabled via `systemd-timesyncd`
- Essential operational packages installed (`curl`, `wget`, `vim`, etc.)

These controls ensure predictable system behavior across all nodes.

---

## 4. SSH Hardening

SSH hardening is applied on **all nodes** in *safe mode*.

### Implemented Controls

- Root login disabled:
PermitRootLogin no

```text
- SSH idle timeout enforced:
  - `ClientAliveInterval 300`
  - `ClientAliveCountMax 2`
- Legal / audit SSH banner configured:
Authorized access only. All activity may be monitored.
```

text
- SSH configuration validated before reload:
sshd -t

```text
- Service reload instead of restart (to prevent lockout)
```
### Explicitly Not Enforced (Commented by Design)

- SSH user allowlist (`AllowUsers`)
- IPv4-only enforcement

These are intentionally commented to keep the lab accessible and safe.

---

## 5. Network Security (Firewall)

Firewall rules are enforced using **iptables** and persisted with
`iptables-persistent`.

### Default Policy

| Chain | Policy |
|----|----|
| INPUT | DROP |
| FORWARD | DROP |
| OUTPUT | ACCEPT |

### Global Allowed Traffic

- Loopback traffic
- Established / related connections
- SSH (TCP/22)

---

### App Node (`noyan-app`) Rules

- Allow inbound HTTP:
  - TCP/80
- All other inbound traffic is blocked

---

### DB Node (`noyan-db`) Rules

- PostgreSQL (TCP/5432) **only from App node**
Source: 192.168.56.11/32

```text
- No external or lateral DB access allowed
```

This enforces **strict network segmentation** between tiers.

---

## 6. Nginx Hardening (App Node)

Applied via `roles/nginx_hardening`.

### Implemented Controls

- Default Nginx site removed
- Custom minimal `nginx.conf` deployed via template
- Controlled permissions (`0644`, owned by root)
- Configuration changes trigger **reload**, not restart

The configuration prioritizes:
- Minimal attack surface
- Explicit configuration ownership
- Predictable behavior

---

## 7. PostgreSQL Security Baseline (DB Node)

Applied via `roles/postgresql_baseline`.

### Network Binding

PostgreSQL is bound **only** to:
localhost

192.168.56.12

```text
No public or wildcard binding is allowed.
```

---

### Client Authentication

- Only the App node is allowed to connect:
192.168.56.11/32

```text
- Authentication method: `md5`
- Changes are safely reloaded
```

### Not Implemented (By Design)

- Database user creation
- Password / secret management
- TLS for PostgreSQL connections

These are intentionally excluded to keep secrets out of source code.

---

## 8. Package Management & Attack Surface Reduction

- Only required packages are installed per node role
- Control node installs Ansible-related tooling only
- App and DB nodes receive minimal required services

Unnecessary services are not introduced.

---

## 9. What This Lab Does NOT Cover

This lab intentionally excludes:

- Ansible Vault or secret management
- CIS benchmark compliance
- SELinux / AppArmor enforcement
- IDS / IPS (e.g., Fail2ban, Auditd)
- TLS certificates and PKI
- Centralized logging and SIEM integration

These exclusions are **explicit and intentional** for educational clarity.

---

## 10. Security Philosophy

This lab demonstrates:

- Infrastructure-as-Code security
- Predictable and auditable hardening
- Safe defaults over aggressive lockdown
- Clear separation between **what is secured** and **what is not**

It is designed as a **DevSecOps learning platform**, not a production-hardened system.

---
