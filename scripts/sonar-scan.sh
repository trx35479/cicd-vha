#!/bin/bash
set -e
source ci-env.sh

echo "[+] Creating the ${project}-${component} directory and copying the application code to this directory for the Sonar Scan"
mkdir -p ${project}-${component}
cp -pr ${component}/* ${project}-${component}

echo "[=] Starting sonar-scan script"
echo "[*] Running environment check"
uname -s | grep -q -E "^CYGWIN" && function pwd () { cygpath.exe -a -m .; } \
    && echo "[+] Setting compatibility to cygwin"

echo "[*] Retrieving the Build Number from the Jenkins Job"
build_number=$1
echo ${build_number}
[[ -z "${build_number}" ]] \
  && {
    echo "[!] Could not get the build number for this deployment. Exiting!"
    exit 1
  }
echo "[+] Build Number: ${build_number}"

echo "[*] Getting git short commit"
git_short_commit=$(git rev-parse --short HEAD) \
  || {
    echo "[!] Could not get git short commit. Exiting!"
    exit 1
  }

echo "[*] Checking for nexus auth"
[[ -z "${nexus_auth_USR}" ]] && read -p "Nexus User: " nexus_auth_USR
[[ -z "${nexus_auth_PSW}" ]] && read -s -p "Nexus Pass: " nexus_auth_PSW

echo "[*] Checking for sonar token"
[[ -z "${sonar_token}" ]] && read -p "Sonar Token: " sonar_token

echo "[*] Logging into nexus docker repo"
while true; do
  docker login \
    --username "${nexus_auth_USR}" \
    --password "${nexus_auth_PSW}" \
    nexus3.dev.unico.com.au && break
  sleep 5
done

echo "[*] Starting unico-sonar-scanner"
docker run \
  --rm \
  -v $(pwd):/workdir \
  nexus3.dev.unico.com.au/unico-sonar-scanner \
    sonar-scanner \
          --define sonar.host.url=https://sonarqube.dev.unico.com.au \
          --define sonar.login=${sonar_token} \
          --define sonar.projectVersion=${build_number}_${git_short_commit} \
          --define sonar.projectKey=${project}-${component} \
          --define sonar.projectBaseDir=/workdir \
          --define sonar.java.binaries=${sonar_java_binaries} \
          --define sonar.sources=${sonar_sources} \
  || {
    echo "[!] Failed to scan ${component} with sonar"
    exit 1
  }

echo "[=] Finished sonar-scan script"