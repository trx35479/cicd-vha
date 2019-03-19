#!/bin/bash
set -e
source ci-env.sh

echo "[=] Starting build script"

echo "[*] Running environment check"
uname -s | grep -q -E "^CYGWIN" && function pwd () { cygpath.exe -a -m .; } \
    && echo "[+] Setting compatibility to cygwin"
echo "[*] Getting git short commit"
git_short_commit=$(git rev-parse --short HEAD) \
  || {
    echo "[!] Could not get git short commit. Exiting!"
    exit 1
  }
echo "[+] Git short commit ${git_short_commit}"
mkdir -p build

echo "[*] Building ${component}"
docker run \
  --rm \
  --user="$(id -u)" \
  -v $(pwd):/workdir \
  ${client}-${project}-${component}-gradle5:${git_short_commit} \
    bash -c "cd ${component} && gradle clean assemble test ${artefact_type} --stacktrace" \
  || {
    echo "[!] Failed to build ${component}"
    exit 1
  }

echo "[=] Finished build script"
