#!/bin/bash
# Deploy ct108-finance compose file to CT108 on node-c. Never copies env files.
set -euo pipefail
scp ~/Homelab/ct108-finance/compose.yml root@192.0.2.70:/tmp/ct108-compose.yml
ssh root@192.0.2.70 'pct push 108 /tmp/ct108-compose.yml /opt/actual/compose.yml && pct exec 108 -- bash -c "cd /opt/actual && docker compose up -d"'
