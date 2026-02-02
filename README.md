# DevSecOps Lab – Vagrant & Ansible

This repository contains a **personal DevSecOps learning lab** built around
Infrastructure as Code (IaC), security automation, and multi-node architecture.

The project is designed to evolve over time and serve as a practical playground
for experimenting with DevOps and DevSecOps concepts using real tools and
realistic scenarios.

---

## Project Goals

The main objectives of this lab are:

- Practice **Infrastructure as Code** using Vagrant
- Automate configuration and security using Ansible
- Understand **network segmentation** and east-west traffic control
- Apply **baseline security hardening** at OS and service level
- Build a clear separation between control, application, and database layers
- Continuously improve the lab with more advanced DevSecOps concepts

This is not a production-ready environment — it is a **learning-focused,
code-driven lab**.

---

## High-Level Architecture

The environment consists of three virtual machines:

| Node | Role |
|----|----|
| Control Node | Ansible controller and orchestration |
| App Node | Application / Nginx web server |
| DB Node | PostgreSQL database |

All nodes are connected via a private network and secured using host-based
firewall rules and service hardening.

---

## Tools & Technologies

This lab currently uses:

- **Vagrant** – VM lifecycle and provisioning
- **VirtualBox** – Virtualization provider
- **Ansible** – Configuration management and security automation
- **Ubuntu 22.04 (Jammy)** – Base operating system
- **iptables** – Network-level access control
- **Nginx** – Application layer
- **PostgreSQL** – Database layer

More tools and improvements will be added over time.

---

## DevSecOps Focus

Security is treated as a **first-class citizen**, not an afterthought.

Implemented security concepts include:

- OS hardening
- SSH hardening
- Default-deny firewall policies
- Strict inter-node network access
- Service-level hardening (Nginx & PostgreSQL)

All security controls are applied using **Ansible roles**, making them auditable,
repeatable, and version-controlled.

---

## Documentation

Detailed documentation is available in the `docs/` directory:

- `overview.md` – Project overview
- `prerequisites.md` – Requirements and setup
- `vagrantfile.md` – Vagrant configuration explained
- `networking.md` – Network architecture and traffic rules
- `security.md` – Security model and hardening details
- *(more to be added)*

---

## Project Status

This project is **actively evolving**.

Future improvements may include:

- Secrets management (Ansible Vault)
- TLS and certificate management
- CI/CD integration
- Packer-based custom images
- Advanced security controls (CIS benchmarks, IDS, etc.)

---

## Disclaimer

This lab is intended for **educational and experimental purposes only**.

Do not use it as-is in production environments.

---

## Author

Personal DevSecOps lab created and maintained as a continuous learning project by Alireza Taghikhani.
