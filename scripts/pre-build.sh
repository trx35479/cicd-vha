#!/bin/bash
set -e
source ci-env.sh
echo "[=] Starting pre-build script"

echo "[*] Checking for nexus auth"
[[ -z "${nexus_auth_USR}" ]] && read -p "Nexus User: " nexus_auth_USR
[[ -z "${nexus_auth_PSW}" ]] && read -s -p "Nexus Pass: " nexus_auth_PSW

echo "[*] Logging into nexus docker repo"
while true; do
  docker login \
    --username "${nexus_auth_USR}" \
    --password "${nexus_auth_PSW}" \
    nexus3.dev.unico.com.au && break
  sleep 5
done

echo "[*] Getting git short commit"
git_short_commit=$(git rev-parse --short HEAD) \
  || {
    echo "[!] Could not get git short commit. Exiting!"
    exit 1
  }
echo "[+] Git short commit: ${git_short_commit}"

echo "[+] Storing the Git short commit ID to the 'cicd-git_short_commit.txt' file for later"

echo "git_short_commit=$git_short_commit" > "cicd-git_short_commit.txt"

echo "[+] Building all of the Docker Images in the Docker Directory"

for dockerfile in docker/*; do 
  image_name=$(basename ${dockerfile} | sed 's/_dockerfile$//g')
  image_long_name="${client}-${project}-${component}-${image_name}"
  tag="${git_short_commit}"

  echo "[*] Building Image: ${image_name}"
  docker build \
    --tag ${image_long_name}:${tag} \
    -f ${dockerfile} \
    --label ${client}-${project} . \
  || {
    echo "[!] Failed to Build Image: ${image_name}"
    exit 1
  }
  echo "[+] Built Image: ${image_name}"
  echo "      Tagged as: ${image_long_name}:${tag}"
done

echo "[=] Finished pre-build script"