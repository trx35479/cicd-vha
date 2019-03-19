#!/bin/bash
set -e
source ci-env.sh

echo "[=] Starting xpath script"

echo "[*] Running environment check"
uname -s | grep -q -E "^CYGWIN" && function pwd () { cygpath.exe -a -m .; } \
    && echo "[+] Setting compatibility to cygwin"
echo "[*] Getting git short commit"
git_short_commit=$(git rev-parse --short HEAD) \
  || {
    echo "[!] Could not get git short commit. Exiting!"
    exit 1
  }
echo "[+] Git short commit: ${git_short_commit}"
mkdir -p build

echo "[*] Generating description"
docker run \
  --rm \
  --user="$(id -u)" \
  -v $(pwd):/workdir \
  ${client}-${project}-${component}-xpath:${git_short_commit} \
    bash scripts/generate_description.sh \
  || {
    echo "[!] Failed to generating description"
    exit 1
  }
echo "[=] Finished xpath script"
