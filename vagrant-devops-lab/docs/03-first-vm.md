# Step 3 – Creating the First VM with Vagrant

## Objective
This step demonstrates how to initialize a Vagrant project, boot a Linux virtual machine, and access it via SSH.

---

## Project Directory
All commands were executed inside the project root:

```bash
vagrant-devops-lab/
```

---

## Initialize Vagrant

```bash
vagrant init ubuntu/jammy64
```

**Result:**
- Creates a `Vagrantfile`
- Uses `ubuntu/jammy64` (Ubuntu 22.04 LTS) as the base box

---

## Start the Virtual Machine

```bash
vagrant up
vagrant up --provider=virtualbox
```

**Expected outcome:**
- The box is downloaded (first run only)
- A VirtualBox VM is created and started
- Process finishes with:

```text
Machine booted and ready!
```

---

## SSH into the VM

```bash
vagrant ssh
```

**Verification inside the VM:**

```bash
lsb_release -a
```

Expected OS:
```text
Ubuntu 22.04 LTS
```

---

## Stop the VM

```bash
vagrant halt
```

Stops the virtual machine without destroying it.

---

## Key Notes
- Infrastructure is defined as code via `Vagrantfile`
- The environment is fully reproducible across different host operating systems
- Vagrant manages the VM lifecycle using simple CLI commands
