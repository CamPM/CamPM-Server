#!/bin/bash
# Deploy ct110-auth compose file to CT110 on node-c. Never copies .env.
set -euo pipefail
scp ~/Homelab/ct110-auth/compose.yml root@192.0.2.70:/tmp/ct110-compose.yml
ssh root@192.0.2.70 'pct push 110 /tmp/ct110-compose.yml /root/authentik/compose.yml && pct exec 110 -- bash -c "cd /root/authentik && docker compose up -d"'
