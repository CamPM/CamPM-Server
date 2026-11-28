#!/bin/bash
# Deploy ct111-dashboard compose file. Finds the node that holds CT111. Shows a diff, asks first.
set -euo pipefail
N=""
for h in 192.0.2.3 192.0.2.50 192.0.2.70; do
  N=$(ssh -o ConnectTimeout=5 root@$h "ha-manager status" 2>/dev/null | sed -n 's/.*ct:111 (\([a-z]*\),.*/\1/p') && [ -n "$N" ] && break
done
case ${N:-node-a} in node-a) IP=192.0.2.3;; node-b) IP=192.0.2.50;; node-c) IP=192.0.2.70;; esac
echo "CT111 node: ${N:-node-a (default)}"
scp ~/Homelab/ct111-dashboard/compose.yml root@$IP:/tmp/ct111-compose.yml
ssh root@$IP 'pct push 111 /tmp/ct111-compose.yml /opt/homarr/compose.new && pct exec 111 -- bash -c "cd /opt/homarr && diff compose.yml compose.new && echo SAME"' || true
read -r -p "Replace live compose and run up -d? (y/N) " a
[ "$a" = y ] || exit 0
ssh root@$IP 'pct exec 111 -- bash -c "cd /opt/homarr && cp compose.yml compose.yml.bak-gitops && mv compose.new compose.yml && docker compose up -d && docker compose ps --format \"table {{.Name}}\t{{.Status}}\""'
