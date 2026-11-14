#!/bin/bash
# Deploy ct104-vaultwarden compose file to CT104 on node-c. Touches only the compose file.
set -euo pipefail
scp ~/Homelab/ct104-vaultwarden/compose.yml root@192.0.2.70:/tmp/ct104-compose.yml
ssh root@192.0.2.70 'pct push 104 /tmp/ct104-compose.yml /mnt/vault_data/docker-compose.yml && pct exec 104 -- bash -c "cd /mnt/vault_data && docker compose up -d"'
