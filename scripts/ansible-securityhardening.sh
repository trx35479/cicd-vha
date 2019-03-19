#!/bin/bash
set -e
source ../ci-env.sh
source ../cicd-git_short_commit.txt
environment=$1
echo "[*] Running environment check"
uname -s | grep -q -E "^CYGWIN" && function pwd () { cygpath.exe -a -m .; } \
    && echo "[+] Setting compatibility to cygwin"

echo "[+] Giving the ec2.py file in the Ansible Directory executable permissions for Dynamic Inventory"
chmod +x inventory/dyn/ec2.py

echo "[*] Performing Ansibles Playbook to Perform Security Hardening for ${component}"

sed -i.bak '/spacewalk-join/d' playbooks/base.yml

for i in 1 2 3 4 5; do
python inventory/dyn/ec2.py --list --refresh-cache > /dev/null
ansible -i inventory/dyn -u jenkins --private-key=jenkins.key --limit "tag_Name_MigrationTool:&tag_Environment_${environment}:&tag_Project_VHA" -m ping all && break || sleep 10;
done

ansible-playbook -v -i inventory/dyn  playbooks/configure_ldap_client.yml -u jenkins --private-key=jenkins.key --limit "tag_Name_MigrationTool:&tag_Environment_${environment}:&tag_Project_VHA"
ansible-playbook -v -i inventory/dyn  playbooks/base.yml  -u jenkins --private-key=jenkins.key  --limit "tag_Name_MigrationTool:&tag_Environment_${environment}:&tag_Project_VHA"

echo "[=] Finished Executing Ansible Playbook"

