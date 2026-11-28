#!/bin/bash
# Save hardware and resource facts per node into host/. Read only on the servers.
set -uo pipefail
B=$HOME/Homelab/host
for p in node-a:192.0.2.3 node-b:192.0.2.50 node-c:192.0.2.70; do
  ssh root@${p#*:} 'bash -s' < $HOME/Homelab/scripts/inv-remote.sh > $B/${p%%:*}/inventory.txt
done
{ echo "mac: $(sysctl -n machdep.cpu.brand_string) / $(( $(sysctl -n hw.memsize) / 1073741824 )) GB RAM"; } > $B/mac-inventory.txt
wc -l $B/*/inventory.txt $B/mac-inventory.txt
