#!/bin/bash
set -e
source ci-env.sh

echo "[*] Running environment check"
uname -s | grep -q -E "^CYGWIN" && function pwd () { cygpath.exe -a -m .; } \
    && echo "[+] Setting compatibility to cygwin"
git_short_commit=$(git rev-parse --short HEAD) \
  || {
    echo "[!] Could not get git short commit. Exiting!"
    exit 1
  }
password="${git_short_commit}+"
environment=$1
echo "[+] Giving the ec2.py file in the Ansible Directory executable permissions for Dynamic Inventory"
chmod +x cd/ansible-deploy/ec2.py

echo "[+] Copying the Artefacts from the 'build.sh' script to the build_artefacts directory in the Ansible Directory"

mkdir -p cd/ansible-deploy/build_artefacts
cp -pr filter-api/build/libs/* cd/ansible-deploy/build_artefacts

echo "[*] Performing Ansible Playbook for ${component}"
docker run \
  --rm \
  -v $(pwd)/cd/ansible-deploy:/workdir \
  ${client}-${project}-${component}-ansible:${git_short_commit} \
    bash -c "ansible-playbook aws-cli-setup.yml --connection=local --inventory 127.0.0.1 --extra-vars "environment_name=${environment}" --vault-password-file=vault.txt -vv --private-key=~/.ssh/jenkins.key && ansible-playbook ${component}.yml -i ec2.py --extra-vars "component=${component}" --extra-vars "environment_name=${environment}" --vault-password-file=vault.txt -vv --private-key=~/.ssh/jenkins.key" \
  || {
    echo "[!] Ansible Playbook Failed "
    exit 1
  }
echo "[=] Finished Executing Ansible Playbook"