#!/bin/bash
set -e
echo "[=] Starting package script"

echo "[*] Checking for nexus auth"
[[ -z "${nexus_auth_USR}" ]] && read -p "Nexus User: " nexus_auth_USR
[[ -z "${nexus_auth_PSW}" ]] && read -s -p "Nexus Pass: " nexus_auth_PSW

source ci-env.sh

echo "[*] Running environment check"
uname -s | grep -q -E "^CYGWIN" && function pwd () { cygpath.exe -a -m .; } \
    && echo "[+] Setting compatibility to cygwin"

echo "[*] Gathering the Release Version and Build Number for this Deployment"
release_version=$1
echo ${release_version}
[[ -z "${release_version}" ]] \
  && {
    echo "[!] Could not get the release version for this deployment. Exiting!"
    exit 1
  }
echo "[+] Release Version: ${release_version}"


build_number=$2
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
echo "[+] Git Short Commit: ${git_short_commit}"

echo "[*] Packaging: ${project}-${component}-${build_number}-${release_version}_${git_short_commit}.x86_64.rpm"
mkdir -p rpm
mkdir -p build/libs
docker run \
  --user="$(id -u)" \
  --rm \
  --volume $(pwd)/${component}:/fpm \
  --volume $(pwd)/rpm:/fpm/rpm \
  nexus3.dev.unico.com.au/unico-fpm \
    --input-type dir \
    --output-type rpm \
    --package rpm \
    --name ${project}-${component} \
    --vendor Unico \
    --architecture x86_64 \
    --maintainer Unico \
    --version "${build_number}" \
    --iteration "${release_version}_${git_short_commit}" \
    --rpm-user vodaphone \
    --rpm-group vodaphone \
    --rpm-defattrfile "0750" \
    --rpm-defattrdir "0640" \
      build/libs/="/opt/unico/${component}/" \
  || {
    echo "[!] Failed to Package: ${project}-${component}-${build_number}-${release_version}_${git_short_commit}.x86_64.rpm"
    exit 1
  }
echo "[+] Packaged: ${project}-${component}-${build_number}-${release_version}_${git_short_commit}"
echo "    ./rpm/${project}-${component}-${build_number}-${release_version}_${git_short_commit}.x86_64.rpm"

echo "[+] Finished package script"