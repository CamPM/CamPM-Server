#!/bin/bash
# Usage: add-repo.sh REPONAME. Adds a node_modules mount for a repo in _repos, then deploys.
set -euo pipefail
R=${1:?usage: add-repo.sh REPONAME}
[ -d ~/Homelab/_repos/$R ] || { echo "clone it into ~/Homelab/_repos first"; exit 1; }
F=~/Homelab/ct103-localai/compose.yml
grep -q "/opt/code/nm/$R:" $F || perl -pi -e "s|^(      - /opt/code/nm:/nm)\$|      - /opt/code/nm/$R:/workspace/Homelab/_repos/$R/node_modules\n\$1|" $F
grep -q "^node_modules" ~/Homelab/_repos/$R/.gitignore 2>/dev/null || echo "node_modules" >> ~/Homelab/_repos/$R/.gitignore
for h in 192.0.2.70 192.0.2.50 192.0.2.3; do
  N=$(ssh -o ConnectTimeout=5 root@$h "ha-manager status" 2>/dev/null | sed -n 's/.*ct:103 (\([a-z]*\),.*/\1/p') && [ -n "$N" ] && break
done
case $N in node-a) IP=192.0.2.3;; node-b) IP=192.0.2.50;; node-c) IP=192.0.2.70;; *) echo "CT103 node not found"; exit 1;; esac
ssh root@$IP "pct exec 103 -- bash -c 'mkdir -p /opt/code/nm/$R && chown 1000:1000 /opt/code/nm/$R'"
~/Homelab/scripts/deploy-ct103.sh
