# Rebuild guide

This repo describes a 3-node Proxmox cluster running Docker stacks in LXC containers.
Names, IPs and domain here are examples. Replace them with yours.

## 0. Replace before you start
- Domain: example.com
- Nodes: node-a, node-b, node-c (192.0.2.x examples)
- IDs marked REPLACE_ME or 00000000-... in the blueprint, HA and VM files

## 1. Proxmox cluster
1. Install Proxmox VE on 3 nodes and join them into one cluster. Keep quorum: never take 2 of 3 nodes down.
2. Storage: see host/cluster/storage.cfg (ZFS pools, NFS media, backup storage).
3. Network: host/<node>/interfaces.
4. HA: host/cluster/ha-resources.cfg, ha-rules.cfg, datacenter.cfg.
5. Backups and replication: host/cluster/jobs.cfg, replication-jobs.txt.
6. Per node: copy host/<node>/safe-reboot.*, reboot.target.d/timeout.conf, sanoid.conf, syncoid files.
   Enable with: systemctl daemon-reload && systemctl enable --now safe-reboot.service
7. Cloudflare tunnel: host/shared/cloudflared.service. Put your own token in /etc/cloudflared/token (mode 600).

## 2. Guests
Create each CT or VM from host/<node>/guests/<id>.conf (cores, memory, disk, mounts).
Unprivileged LXC with nesting and keyctl for Docker. Install Docker and the compose plugin in each.

| Guest | Folder | Notes |
|---|---|---|
| CT100 Pi-hole | host/pihole | native install plus Unbound |
| VM101 Home Assistant | vm101-homeassistant | HAOS VM |
| CT102 Jellyfin, ROMM | ct102-light-media, ct102-romm | |
| CT104 Vaultwarden | ct104-vaultwarden | |
| CT105 requests | ct105-requests | Arr apps, Seerr, Aurral |
| CT106 downloads | ct106-downloads | VPN + qBittorrent |
| CT107 Unmanic | ct107-unmanic | needs NVIDIA runtime |
| CT108 Actual | ct108-finance | |
| CT109 OpenCloud | ct109-files | upstream compose + custom files |
| CT110 Authentik | ct110-auth | |

## 3. Order
1. Pi-hole (DNS).
2. Authentik (CT110). Import ct110-auth/blueprint-export.yaml as a blueprint. Create your users, add them to groups, create new OAuth secrets.
3. Other stacks. For each: copy .env.example to the real env file name, fill it in, mode 600, then docker compose up -d.
4. Wire SSO: Jellyfin (ct102-light-media/SETUP.md), ROMM, Aurral, OpenCloud, Home Assistant.
5. Seerr, Arr apps and Aurral: connect them to each other in their web UIs.

## 4. Secrets you must create
Authentik secret key and DB password, SMTP login, OAuth client secrets, LDAP bind password, VPN WireGuard key, ROMM DB passwords and auth key, Actual and AI keys, Lidarr key, Cloudflare tunnel token, Pi-hole web password, Home Assistant secrets.yaml.
Never commit these. Keep a break-glass local admin in Jellyfin, Home Assistant, ROMM and Aurral.

## 5. Not included
Databases, media, user accounts, plugin configs with secrets, backups.

## 6. Deploy
scripts/deploy-ct*.sh copy a stack's compose file to its container and run docker compose up -d. Edit the IPs inside first.

## 7. Code editor (CT103)
- code-server runs in CT103 with its own login off (ct103-localai/compose.yml). It holds no Git token or SSH key.
- Login comes from Authentik: create a Proxy provider (Proxy mode, external host https://code.example.com, internal host http://192.0.2.65:8080), bind your admin group, and add it to the embedded outpost.
- Point a Cloudflare hostname at Authentik (port 9000), not at CT103.
- Firewall: host/cluster/cluster.fw turns the Proxmox firewall on with policy ACCEPT. host/cluster/103.fw drops everything to CT103 except Authentik on port 8080. Copy both into /etc/pve/firewall/. Test the block from another machine.

## 8. Editor workspace share (CT103)
- On the Mac, create a dedicated user and share the repo folder read/write and the public copy folder read-only (SMB). Give the user rights on existing files too, or edits fail.
- On every node: create /root/.mac-private.cred and /root/.mac-public.cred (username=, password=, mode 600). Add the lines in host/shared/fstab-mac.txt to /etc/fstab, then mount. Mount points are /mnt/mac/private and /mnt/mac/public.
- Bind them into CT103 with shared=1: pct set 103 -mp0 /mnt/mac/private,mp=/opt/code/workspace/repo,shared=1 -mp1 /mnt/mac/public,mp=/opt/code/workspace/repo-public,ro=1,shared=1
- Never delete and recreate the shared Mac folders. The mounts go stale. scripts/make-public.sh updates the public folder in place.
- CT103 has no replication. HA can move it only because its disk is on shared-name storage with the same pool on each node. Check this on your own cluster before relying on it.

Update: the public copy is no longer shared separately. make-public.sh builds it in _public inside the private repo folder (ignored by Git). Only one share and one mount (mp0) are needed. Ignore the public share lines above.
