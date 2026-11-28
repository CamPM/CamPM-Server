#!/bin/bash
# Deploy ct102-moonlight to CT102 on node-b. Creates /opt/moonlight first.
# The container runs as uid 999, so /opt/moonlight/server must be owned by 999.
set -euo pipefail
scp ~/Homelab/ct102-moonlight/compose.yml root@192.0.2.50:/tmp/ct102-moonlight-compose.yml
scp ~/Homelab/ct102-moonlight/config.json root@192.0.2.50:/tmp/ct102-moonlight-config.json
ssh root@192.0.2.50 'pct exec 102 -- mkdir -p /opt/moonlight/server && pct push 102 /tmp/ct102-moonlight-compose.yml /opt/moonlight/compose.yml && pct push 102 /tmp/ct102-moonlight-config.json /opt/moonlight/server/config.json && pct exec 102 -- bash -c "chown -R 999:999 /opt/moonlight/server && cd /opt/moonlight && docker compose up -d"'
