# Plan: moonlight-web on CT102 (browser access to the Bazzite VM)

Goal: stream VM 200 (Sunshine at 192.0.2.72) in a browser, from Homarr, for the home admins group only.

Where: CT102 light-media on node-b, as a new stack /opt/moonlight. CT102 has 8 cores and 6.75 GB RAM, about 0.5 GB used. node-a is full (VM locks 8 GB), so nothing new goes there. No new CT now. A frontend-access CT can come later with the notification server.

Software: mrcreativ3001/moonlight-web-stream v3.0.2, pinned by digest. Ignore 3.0.3 prereleases.

Flow:
- Page: browser, Cloudflare tunnel, Authentik embedded outpost (CT110), then 192.0.2.75:8085.
- Video: WebRTC over UDP 40000-40010 straight to 192.0.2.75, from the LAN or over the Tailscale subnet route.
- Through the tunnel alone, video falls back to WebSocket over TCP (works, more lag).

Safety: the app trusts the X-authentik-username header. Only CT110 (192.0.2.67) may reach port 8085, set in 102.fw. The firewall rule goes in BEFORE the container starts.

Steps (each server step needs an explicit go):
1. Apply 102.fw. Check Jellyfin and ROMM still answer.
2. Run scripts/deploy-ct102-moonlight.sh. Check logs and /opt/moonlight/server.
3. Authentik: proxy provider and application, embedded outpost, bound to home admins. Public name vm.example.com.
4. Cloudflare tunnel hostname to the outpost, like code.example.com.
5. First login is Cameron, so the first user (admin) is the right one.
6. Add host 192.0.2.72, pair with the PIN in the Sunshine web page.
7. Homarr tile: new-tab link first, then an iframe test.

Unverified, check while doing it:
- config.json layout and the /moonlight-web/server volume path for v3.0.2.
- Container user can write to /opt/moonlight/server.
- Iframe: frame headers, and allow= flags for fullscreen, gamepad and keyboard lock.
- Cloudflare terms for heavy video through the tunnel. Prefer Tailscale for remote play.

Rollback: docker compose down in /opt/moonlight, delete 102.fw, delete the Authentik app and tunnel hostname.
