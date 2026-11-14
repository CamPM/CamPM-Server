#!/bin/bash
# Deploy ct105-requests compose file to CT105 on node-c. Never copies .env.
set -euo pipefail
scp ~/Homelab/ct105-requests/compose.yml root@192.0.2.70:/tmp/ct105-compose.yml
ssh root@192.0.2.70 'pct push 105 /tmp/ct105-compose.yml /opt/stack/compose.yml && pct exec 105 -- bash -c "cd /opt/stack && docker compose up -d"'
