#!/bin/bash
set -e

source ci-env.sh

echo "[*] Validating inputs"
if echo "${1}" | grep -q -E '([0-9]{1,3}\.){2}[0-9]{1,3}-[0-9]{1,3}_[a-z0-9]{7}'; then
  echo "[+] Publishing build RPM"
  rpm_file=${1}
elif echo "${1}" | grep -q -E '([0-9]{1,3}\.){2}[0-9]{1,3}-RELEASE'; then
  echo "[+] Publishing release RPM"
  rpm_file=${1}
elif [[ -z "${1}" ]]; then
  echo "[+] No RPM passed. Automaticaly selecting newest RPM"
  rpm_file=rpm/$(ls -At rpm/ | head -n1)
else
  echo "[!] RPM does not conform to regex"
  echo "    '([0-9]{1,3}\.){2}[0-9]{1,3}-[0-9]{1,3}_[a-z0-9]{7}'"
  echo "    '([0-9]{1,3}\.){2}[0-9]{1,3}-RELEASE'"
  exit 1
fi
echo "[+] Finding RPM"
[[ -f "${rpm_file}" ]] \
  || {
    echo "[-] Failed to find RPM"
    exit 1
  }

[[ -z "${nexus_auth_USR}" ]] && read -p "Nexus User: " nexus_auth_USR
[[ -z "${nexus_auth_PSW}" ]] && read -s -p "Nexus Pass: " nexus_auth_PSW
echo ""

echo "[+] Uploading RPM built during this Release to Nexus"
echo "[+] Starting upload for '${rpm_file}'"

rpm=$(basename ${rpm_file})
curl -f -S --user "${nexus_auth_USR}:${nexus_auth_PSW}" --upload-file "${rpm_file}" "https://nexus3.dev.unico.com.au/repository/${client}-${project}/${component}/${rpm}" \
  || {
    echo "[-] Failed to upload ${rpm_file}"
    exit 1
  }

echo "[+] RPM upload successfull"
echo "    https://nexus3.dev.unico.com.au/repository/${client}-${project}/${component}/${rpm}"