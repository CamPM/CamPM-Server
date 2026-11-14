# System facts (read this first)
Updated Nov 13 2026. No secrets here. Hardware: host/*/inventory.txt. Guest settings: host/*/guests/.

## Cluster
- Proxmox VE 9.2, 3 nodes, quorum needs 2 of 3. Never take 2 nodes down.
- HA policy: migrate on shutdown. Gateway .1. DNS: Pi-hole CT100 (Unbound behind it). Time zone America/Chicago.
- Nodes: node-a (.3, tank pool, NFS media server), node-b (.50, GTX 1660 Ti, backup pool), node-c (.70, most free disk).
- Others: Mac M2 Mini (.169) runs LM Studio and holds the repos. Pi 1B (DietPi) is a wake-on-LAN relay.
- Firewall: cluster firewall on, default ACCEPT. CT103 has its own rules: only the Authentik host may reach port 8080.

## Guests
- CT100 Pi-hole (native, no Docker). VM101 Home Assistant OS.
- CT102 Jellyfin and ROMM. CT104 Vaultwarden. CT105 Arr apps, Seerr, Aurral, LYD.
- CT106 VPN and qBittorrent (pinned to node-a). CT107 Unmanic (pinned to node-b).
- CT108 Actual. CT109 OpenCloud (pinned to node-a). CT110 Authentik.
- CT103 code-server. No replica (bind mount). HA can move it by a planned move only. A node crash would leave it down.
- All stacks use docker compose. Folder names are project names. Never rename them.

## Login design
- Authentik (CT110) is the identity provider. Embedded outpost serves the code editor proxy login.
- Jellyfin: LDAP outpost for passwords, SSO plugin for OIDC. ROMM, Aurral, OpenCloud, Home Assistant: OIDC.
- Break-glass local admin accounts exist in Jellyfin, Home Assistant, ROMM and Aurral. OpenCloud has none (rollback files on CT109). Vaultwarden is independent of Authentik.
- Public hostnames go through Cloudflare tunnels. The editor hostname points at Authentik, not at CT103.

## Backups and replication
- vzdump 02:00 daily to NFS for CT100,102,103,104,105,108,109,110. Weekly Sunday job for CT106 and CT107 (clashes with syncoid at 03:30, move pending).
- Replication every 2 hours or less for most guests. CT103, CT106, CT107, CT109 have none.
- sanoid snapshots on node-a. syncoid pulls to node-b at 03:30.

## Editor workflow
- Edit in code-server (CT103) in the folder Homelab, shared from the Mac over SMB. Cline runs in edit-only mode with LM Studio.
- Cline cannot push or reach servers. The Mac runs scripts/ship.sh.
- Public copy is built in _public (ignored by Git) with names, IPs and IDs masked.
- Keyboard patch: the live page has only a test marker. keyboard-fix.js is not applied yet.

## Pinned images
Jellyfin, ROMM, Seerr, Aurral, Vaultwarden, code-server are pinned by digest. Others use latest tags.

## Open items
- Real keyboard patch and a build script for the patched page.
- Ollama plan and CT103 resize (plan from Cline, resize lines reviewed first).
- Move the weekly backup off 03:30. Optional: second Pi-hole, Homarr dashboard, Bazzite VM, Immich.
- Lidarr has old failed items. Pi-hole finance DNS cleanup. Authentik is slow (about 1 s per request).
