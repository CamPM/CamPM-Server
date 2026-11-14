# Homelab

Single source of truth for the home server. Homelab is the whole system. Cluster is the Proxmox cluster inside it.

## Rules
- Secrets never go in Git. Each stack has a real .env on its machine and a .env.example here.
- Image versions stay pinned. Some use a sha256 digest.
- One stack per folder. Folder name = CT number + purpose.

## Machines
| Name | IP | Role |
|---|---|---|
| node-a | 192.0.2.3 | Proxmox node. Ryzen 9 3900X. ZFS tank. NFS server for media. |
| node-b | 192.0.2.50 | Proxmox node. i5-10300H. Backup pool. |
| node-c | 192.0.2.70 | Proxmox node. i5-1335U. Storage ha-zfs. |
| mac-host | 192.0.2.169 | Mac M2 Mini. LM Studio. Git working copy. |
| pi-host | n/a | Pi 1B. DietPi. Wake-on-LAN relay. |

## Cluster
- Proxmox VE 9.2, 3 nodes, 3 votes. Never take 2 of 3 nodes down.
- HA shutdown policy: migrate. Gateway 192.0.2.1. DNS: Pi-hole 192.0.2.14.
- Time zone: America/Chicago.

## Guests
| ID | Name | IP | Home node | Notes |
|---|---|---|---|---|
| CT100 | pihole | 192.0.2.14 | node-a | DNS |
| VM101 | haos | 192.0.2.17 | node-b | Home Assistant |
| CT102 | light-media | 192.0.2.75 | node-b | Jellyfin, ROMM |
| CT103 | localai | 192.0.2.65 | node-c | Code editor behind Authentik |
| CT104 | vaultwarden | 192.0.2.61 | node-c | |
| CT105 | requests | 192.0.2.60 | node-c | Seerr, Aurral, Arr apps |
| CT106 | downloads | 192.0.2.62 | node-a (pinned) | |
| CT107 | unmanic | 192.0.2.63 | node-b (pinned) | |
| CT108 | finance | 192.0.2.64 | node-c | |
| CT109 | files | 192.0.2.66 | node-a (pinned) | OpenCloud |
| CT110 | auth | 192.0.2.67 | node-c | Authentik |

## Stacks in this repo
| Folder | Guest | What it holds |
|---|---|---|
| ct102-light-media | CT102 | Jellyfin compose, SETUP.md (login and plugin notes) |
| ct102-romm | CT102 | ROMM and its database |
| ct103-localai | CT103 | code-server editor, keyboard-fix.js, settings.json |
| ct104-vaultwarden | CT104 | Vaultwarden (image pinned) |
| ct105-requests | CT105 | Arr apps, Seerr, Aurral, LYD |
| ct106-downloads | CT106 | VPN container and qBittorrent |
| ct107-unmanic | CT107 | Unmanic (NVIDIA runtime) |
| ct108-finance | CT108 | Actual, actual-ai, actual-mcp |
| ct109-files | CT109 | OpenCloud custom SSO files only (base compose is upstream) |
| ct110-auth | CT110 | Authentik compose and cleaned blueprint export |
| vm101-homeassistant | VM101 | Home Assistant config files and notes |
| host | nodes | cluster files, per-node files, Pi-hole, inventory, firewall |
| docs | n/a | REBUILD.md, WORKFLOW.md, SYSTEM.md, plans/ |
| scripts | n/a | tools listed below |

## Scripts
| Script | Use |
|---|---|
| ship.sh | one command: check, commit, push, deploy prompts, public prompts |
| check-edit.sh | flags risky words in changed files (private only) |
| commit-push.sh | secret scan, commit, push (private only) |
| deploy-ct*.sh | copy one stack compose file to its CT, then docker compose up -d |
| make-public.sh | builds the masked public copy (private only) |
| pull-pve.sh | copies guest, HA and network files from the nodes |
| pull-inventory.sh | saves hardware facts per node |

## Deploy
Edit, then run scripts/ship.sh "message". Answer y or n to each prompt. See docs/WORKFLOW.md. Current facts are in docs/SYSTEM.md.
