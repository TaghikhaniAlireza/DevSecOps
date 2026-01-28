# Step 4 – Understanding and Structuring the Vagrantfile

## Objective
Learn the structure of a `Vagrantfile` and configure basic virtual machine properties such as hostname, CPU, memory, and provider-specific settings.

---

## Vagrantfile Structure

A `Vagrantfile` is a Ruby-based DSL evaluated by Vagrant.

```ruby
Vagrant.configure("2") do |config|
  # configuration goes here
end
```

- Configuration version `2` is mandatory
- `config` is the main configuration object

---

## Base Box Configuration

```ruby
config.vm.box = "ubuntu/jammy64"
```

Defines the operating system used for the virtual machine (Ubuntu 22.04 LTS).

---

## Hostname Configuration

```ruby
config.vm.hostname = "devops-lab"
```

Sets the internal hostname of the VM.

---

## Provider Configuration (VirtualBox)

```ruby
config.vm.provider "virtualbox" do |vb|
  vb.name   = "devops-lab-vm"
  vb.memory = 2048
  vb.cpus   = 2
end
```

Controls provider-specific settings such as VM name, memory, and CPU count.

---

## Complete Example

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "devops-lab"

  config.vm.provider "virtualbox" do |vb|
    vb.name   = "devops-lab-vm"
    vb.memory = 2048
    vb.cpus   = 2
  end
end
```

---

## Applying Configuration Changes

```bash
vagrant reload
```

Reloads the VM and applies updated configuration.

---

## Verification Inside the VM

```bash
hostname
nproc
free -m
```

---

## Key Notes
- `Vagrantfile` is executable infrastructure code
- Provider blocks are isolated and reusable
- Clean structure is essential for multi-VM environments
