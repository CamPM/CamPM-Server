#!/bin/bash
# Copy Proxmox guest, HA and network config from each node into host/. Read only on the servers.
set -euo pipefail
B=$HOME/Homelab/host
mkdir -p $B/cluster
pull() {
  mkdir -p $B/$1/guests
  ssh root@$2 "N=$1; cd /etc/pve; for f in lxc/*.conf qemu-server/*.conf; do [ -e \$f ] || continue; echo \"@@ \$N/guests/\$(basename \$f)\"; grep -vE '^(#|cipassword)' \$f | sed -E 's/=([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}/=MAC/g'; done; echo \"@@ \$N/interfaces\"; cat /etc/network/interfaces" | awk -v d=$B '/^@@ /{if(out)close(out); out=d"/"$2; next}{print > out}'
}
pull node-a 192.0.2.3
pull node-b 192.0.2.50
pull node-c 192.0.2.70
ssh root@192.0.2.3 'cd /etc/pve; echo "@@ cluster/ha-resources.cfg"; cat ha/resources.cfg; echo "@@ cluster/ha-rules.cfg"; cat ha/rules.cfg; echo "@@ cluster/datacenter.cfg"; cat datacenter.cfg' | awk -v d=$B '/^@@ /{if(out)close(out); out=d"/"$2; next}{print > out}'
echo "== files"; cd $B && ls cluster */guests
