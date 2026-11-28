#!/bin/bash
# Preview any Vite repo. Run from the repo folder, or: dev.sh REPONAME
PORT=${PORT:-3000}
[ -n "$1" ] && cd /workspace/Homelab/_repos/$1
[ -f package.json ] || { echo "No package.json in $PWD"; exit 1; }
name=$(basename "$PWD")
pkill -f "vite --host" 2>/dev/null
if ! mountpoint -q node_modules 2>/dev/null; then
  echo "No node_modules mount for $name. Ask for it to be added to ct103-localai/compose.yml:"
  echo "  - /opt/code/nm/$name:/workspace/Homelab/_repos/$name/node_modules"
  exit 1
fi
[ -d node_modules/vite ] || npm install
echo "Open: https://code.example.com/absproxy/$PORT/"
exec npx vite --host 0.0.0.0 --port $PORT --base /absproxy/$PORT/
