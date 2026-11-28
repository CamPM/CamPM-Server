#!/bin/bash
# Deploy ct109-files custom config to CT109 on node-a. Never copies .env.
# The base docker-compose.yml is upstream (see ct109-files/UPSTREAM.txt).
set -euo pipefail
D=$HOME/Homelab/ct109-files
scp $D/custom/authentik-sso.yml $D/config/opencloud/proxy-sso.yaml root@192.0.2.3:/tmp/
ssh root@192.0.2.3 'pct push 109 /tmp/authentik-sso.yml /root/opencloud-compose/custom/authentik-sso.yml && pct push 109 /tmp/proxy-sso.yaml /root/opencloud-compose/config/opencloud/proxy-sso.yaml && pct exec 109 -- bash -c "cd /root/opencloud-compose && docker compose up -d"'
