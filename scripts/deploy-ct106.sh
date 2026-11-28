#!/bin/bash
# Deploy ct106-downloads compose file to CT106 on node-a. Never copies gluetun.env.
set -euo pipefail
scp ~/Homelab/ct106-downloads/compose.yml root@192.0.2.3:/tmp/ct106-compose.yml
ssh root@192.0.2.3 'pct push 106 /tmp/ct106-compose.yml /opt/stack/compose.yml && pct exec 106 -- bash -c "cd /opt/stack && docker compose up -d"'
