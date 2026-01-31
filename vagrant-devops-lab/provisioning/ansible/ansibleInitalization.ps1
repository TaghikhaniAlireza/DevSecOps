# ansible path
cd provisioning\ansible

# making directories
mkdir inventory
mkdir playbooks
mkdir roles
mkdir roles\system_hardening
mkdir roles\system_hardening\tasks
mkdir roles\system_hardening\handlers
mkdir roles\system_hardening\defaults

# making files
New-Item ansible.cfg -ItemType File
New-Item inventory\hosts.ini -ItemType File
New-Item playbooks\site.yml -ItemType File
New-Item roles\system_hardening\tasks\main.yml -ItemType File
New-Item roles\system_hardening\handlers\main.yml -ItemType File
New-Item roles\system_hardening\defaults\main.yml -ItemType File

Write-Host "Ansible skeleton created successfully"
