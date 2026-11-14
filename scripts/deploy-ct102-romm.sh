#!/bin/bash
# Deploy ct102-romm compose file to CT102 on node-b. Never copies .env.
set -euo pipefail
scp ~/Homelab/ct102-romm/compose.yml root@192.0.2.50:/tmp/ct102-romm-compose.yml
ssh root@192.0.2.50 'pct push 102 /tmp/ct102-romm-compose.yml /opt/romm/compose.yml && pct exec 102 -- bash -c "cd /opt/romm && docker compose up -d"'
