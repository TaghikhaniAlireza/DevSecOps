# Name
$ProjectName = "vagrant-devops-lab"

# Primary Folder
New-Item -ItemType Directory -Name $ProjectName
Set-Location $ProjectName

# Primary Files
New-Item Vagrantfile -ItemType File
New-Item README.md -ItemType File
New-Item .gitignore -ItemType File

#  docs
New-Item -ItemType Directory docs
New-Item docs/architecture.md -ItemType File
New-Item docs/networking.md   -ItemType File
New-Item docs/security.md     -ItemType File

#  provisioning
New-Item -ItemType Directory provisioning
New-Item -ItemType Directory provisioning/shell
New-Item provisioning/shell/common.sh    -ItemType File
New-Item provisioning/shell/hardening.sh -ItemType File

New-Item -ItemType Directory provisioning/ansible
New-Item provisioning/ansible/playbook.yml -ItemType File
New-Item -ItemType Directory provisioning/ansible/roles

#  security
New-Item -ItemType Directory security
New-Item -ItemType Directory security/fail2ban
New-Item -ItemType Directory security/auditd

Write-Host "✅ Project structure created successfully!"
