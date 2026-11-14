#!/bin/bash
# Deploy ct103-localai compose file. Finds the node that holds CT103 (HA). Shows a diff, asks first.
set -euo pipefail
N=""
for h in 192.0.2.70 192.0.2.50 192.0.2.3; do
  N=$(ssh -o ConnectTimeout=5 root@$h "ha-manager status" 2>/dev/null | sed -n 's/.*ct:103 (\([a-z]*\),.*/\1/p') && [ -n "$N" ] && break
done
case $N in node-a) IP=192.0.2.3;; node-b) IP=192.0.2.50;; node-c) IP=192.0.2.70;; *) echo "CT103 node not found (is it in HA?)"; exit 1;; esac
echo "CT103 is on $N ($IP)"
scp ~/Homelab/ct103-localai/compose.yml root@$IP:/tmp/ct103-compose.yml
ssh root@$IP 'pct push 103 /tmp/ct103-compose.yml /opt/code/compose.new && pct exec 103 -- bash -c "cd /opt/code && diff compose.yml compose.new && echo SAME"' || true
read -r -p "Replace live compose and run up -d? (y/N) " a
[ "$a" = y ] || exit 0
ssh root@$IP 'pct exec 103 -- bash -c "cd /opt/code && cp compose.yml compose.yml.bak-gitops && mv compose.new compose.yml && docker compose up -d && docker compose ps --format \"table {{.Name}}\t{{.Status}}\""'
