#!/bin/bash
# Deploy ct102-light-media compose file to CT102 on node-b. Never copies .env.
set -euo pipefail
scp ~/Homelab/ct102-light-media/compose.yml root@192.0.2.50:/tmp/ct102-compose.yml
ssh root@192.0.2.50 'pct push 102 /tmp/ct102-compose.yml /opt/light-media/compose.yml && pct exec 102 -- bash -c "cd /opt/light-media && docker compose up -d"'
