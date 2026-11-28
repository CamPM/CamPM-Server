# Plan: Dashboard (Homarr) in New LXC (CT111)

## Goal
Deploy **Homarr** in a new LXC container (`CT111`, name `dashboard`, IP `192.0.2.68` on `node-a` / Node A) running Docker Compose. Integrate it with Authentik (CT110) for single sign-on (OIDC), configure Authentik group-based visibility for boards/tiles, restrict Home Assistant controls to admins only, embed ROMM games via iframe with a new-tab fallback, and add widgets for Jellyfin (CT102) and Seerr (CT105).

---

## Files to Create / Edit
1. **`docs/plans/dashboard.md`** (This plan file)
2. **`ct111-dashboard/compose.yml`** (Docker Compose for Homarr)
3. **`ct111-dashboard/.env.example`** (Environment template with key names only)
4. **`ct111-dashboard/README.md`** (Setup instructions)
5. **`docs/SYSTEM.md`** & **`README.md`** (Guest table updates)

---

## Detailed Plan

### 1. LXC & Host Specification
- **Node**: `node-a` (Node A, IP `192.0.2.3`)
- **Container ID**: `CT111`
- **Hostname**: `dashboard`
- **IP Address**: `192.0.2.68`
- **Hardware Resources** (from `host/node-a/inventory.txt`):
  - Cores: `1 vCPU`
  - RAM: `512 MB`
  - Disk: `8 GB` (`tank` ZFS storage pool)
- **Backup**: Daily vzdump at 02:00 to NFS (`backup-nfs`).

### 2. Docker Compose (`ct111-dashboard/compose.yml`)
- **Image**: `ghcr.io/homarr-labs/homarr:latest`
- **Port**: `7575:7575`
- **Volumes**: `/opt/homarr/configs:/app/data/configs`, `/opt/homarr/data:/app/data`

### 3. Authentik Integration (CT110 OIDC)
- OIDC Provider created in Authentik with callback URL pointing to Homarr.
- Groups: `authentik-admins` (Admin board + Home Assistant controls), `authentik-users` (Standard user board).

### 4. Widgets & Features
- Jellyfin widget (CT102, port 8096)
- Seerr widget (CT105, port 5055)
- ROMM iframe with new-tab fallback
- Home Assistant controls for admins only

---

## Host Commands for the User (Node A: `node-a`)
1. Create CT111 on Proxmox Node A (`node-a`):
   ```bash
   pct create 111 local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst \
     --hostname dashboard \
     --cores 1 \
     --memory 512 \
     --swap 512 \
     --storage tank \
     --rootfs tank:8 \
     --net0 name=eth0,bridge=vmbr0,ip=192.0.2.68/24,gw=192.0.2.1 \
     --onboot 1 \
     --start 1
   ```
2. Install Docker inside CT111:
   ```bash
   pct exec 111 -- bash -c "apt-get update && apt-get install -y curl docker.io docker-compose-v2"
   ```
3. Deploy stack files:
   ```bash
   pct exec 111 -- mkdir -p /opt/homarr
   # (scp or push compose.yml and .env to CT111 /opt/homarr/)
   pct exec 111 -- bash -c "cd /opt/homarr && docker compose up -d"
   ```

---

## Check That It Works
- `curl -I http://192.0.2.68:7575`
- Verify OIDC login via Authentik and group-based board visibility.

---

## Rollback
- `pct stop 111 && pct destroy 111`

---

## What Stays the Same
- Authentik (CT110), Jellyfin (CT102), Seerr (CT105), ROMM (CT102), Home Assistant (VM101).

> Superseded: sizes, pool (ha-zfs, not tank), template and Homarr variable names in this plan were wrong. See ct111-dashboard/ for the real setup.
