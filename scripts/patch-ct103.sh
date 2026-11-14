#!/bin/bash
# Build the keyboard-patched page in CT103 from the repo files. Asks before restarting.
set -euo pipefail
N=""
for h in 192.0.2.70 192.0.2.50 192.0.2.3; do
  N=$(ssh -o ConnectTimeout=5 root@$h "ha-manager status" 2>/dev/null | sed -n 's/.*ct:103 (\([a-z]*\),.*/\1/p') && [ -n "$N" ] && break
done
case $N in node-a) IP=192.0.2.3;; node-b) IP=192.0.2.50;; node-c) IP=192.0.2.70;; *) echo "CT103 node not found"; exit 1;; esac
echo "CT103 is on $N"
D=~/Homelab/ct103-localai
scp $D/keyboard-fix.js $D/build-patch.py root@$IP:/tmp/
ssh root@$IP 'pct push 103 /tmp/keyboard-fix.js /opt/code/patch/keyboard-fix.js && pct push 103 /tmp/build-patch.py /opt/code/patch/build-patch.py && pct exec 103 -- bash -c "ls /opt/code/patch/workbench.html.orig && python3 /opt/code/patch/build-patch.py && grep -c patchMarker /opt/code/patch/workbench.html; grep -c visualViewport /opt/code/patch/workbench.html"'
read -r -p "Restart code-server now? (y/N) " a
[ "$a" = y ] || exit 0
ssh root@$IP 'pct exec 103 -- bash -c "cd /opt/code && docker compose restart && sleep 10 && curl -s -L http://192.0.2.65:8080/ | grep -c visualViewport"'
