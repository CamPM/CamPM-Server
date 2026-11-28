#!/bin/bash
# Runs as root at every code-server start. Installs Node 22 if Node is missing or older than 20.
v=$(node -v 2>/dev/null | sed 's/v\([0-9]*\).*/\1/')
if [ "${v:-0}" -lt 20 ]; then
  apt-get update -qq
  apt-get install -y -qq curl ca-certificates
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get install -y -qq nodejs
fi
mkdir -p /config/.npm /nm
chown -R 1000:1000 /config/.npm
exit 0
