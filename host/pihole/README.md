# Pi-hole (CT100, Pi-hole v6 + Unbound)
Native install (no Docker). Debian LXC, 1 core, 512 MB, 2 GB disk. See host/*/guests/100.conf.
Install: Proxmox community-scripts "Pihole LXC", then install Unbound.

Files and where they go in the CT:
- adlists.list -> /etc/pihole/adlists.list
- 99-edns.conf -> /etc/dnsmasq.d/99-edns.conf
- unbound/*.conf -> /etc/unbound/unbound.conf.d/

Settings changed in /etc/pihole/pihole.toml (set in the web UI or with pihole-FTL --config):
- dns.upstreams = ["127.0.0.1#5335", "192.0.2.1", "100.100.100.100"]  (Unbound, router, Tailscale DNS)
- dns.hosts = ["192.0.2.14 pihole"]
- dns.domainNeeded = true
- dns.expandHosts = true
- dns.dnssec = false
- dns.interface = "eth0"
- dns.listeningMode = "ALL"
- dns.queryLogging = true
- misc.dnsmasq_lines: edns-packet-max=1232 via the 99-edns.conf file
Not stored: web password, gravity.db, TLS files, cli_pw.
After copying: systemctl restart unbound && pihole -g
