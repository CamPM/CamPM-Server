#!/bin/bash
# Deploy ct107-unmanic compose file to CT107 on node-b.
set -euo pipefail
scp ~/Homelab/ct107-unmanic/compose.yml root@192.0.2.50:/tmp/ct107-compose.yml
ssh root@192.0.2.50 'pct push 107 /tmp/ct107-compose.yml /opt/unmanic/compose.yml && pct exec 107 -- bash -c "cd /opt/unmanic && docker compose up -d"'
