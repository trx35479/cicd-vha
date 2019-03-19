#!/usr/bin/env bash
set -e
source ci-env.sh

echo "[=] Starting scm-build-status script"

echo "[*] Checking for nexus auth"
[[ -z "${stash_auth_USR}" ]] && read -p "Stash User: " stash_auth_USR
[[ -z "${stash_auth_PSW}" ]] && read -s -p "Stash Pass: " stash_auth_PSW

echo "[*] Getting stage"
case $1 in
  BUILD)
    stage=${1}
    ;;
  SONAR)
    stage=${1}
    ;;
  IQ)
    stage=${1}
    ;;
  DOCKER)
    stage=${1}
    ;;
  ROBOT)
    stage=${1}
    ;;
  *)
    echo "[!] Error not a valid stage ${1}"
    exit 1
    ;;
esac
echo "[+] Stage: ${stage}"


echo "[*] Getting stage status for: ${stage}"
case $2 in
  INPROGRESS)
    status=$2
    ;;
  SUCCESSFUL)
    status=$2
    ;;
  FAILED)
    status=$2
    ;;
  *)
    echo "[!] Error not a valid status ${2}"
    exit 1
    ;;
esac
echo "[+] Status for stage ${stage}: ${status}"

echo "[*] Notifying stash" 
curl \
  -u "${stash_auth_USR}:${stash_auth_PSW}" \
  -H "Content-Type: application/json" \
  -X POST "https://stash.dev.unico.com.au/rest/build-status/1.0/commits/${GIT_COMMIT}" \
  --data "{
    \"state\": \"${status}\",
    \"name\": \"BUILD: ${BRANCH_NAME}-${BUILD_NUMBER}, Stage: ${stage}\",
    \"key\": \"${project}-${component}-${BRANCH_NAME}-${stage}\",
    \"url\": \"${BUILD_URL}\"
  }" \
  || {
    echo "[!] Failed to notify stash"
    exit 1
  }

echo "[=] Finished scm-build-status script"
