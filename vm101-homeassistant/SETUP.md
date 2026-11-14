# Home Assistant OS (VM101)
Full VM, not a container. VM settings: host/node-b/guests/101.conf (UEFI, 32G disk).
Install: Proxmox community-scripts "Home Assistant OS VM", or the HAOS qcow2 image.

## Files here
configuration.yaml, automations.yaml, scripts.yaml, scenes.yaml go in /config.
The trusted_networks block uses example addresses (203.0.113.10). Replace them with yours, or remove the block.
The camera entry needs a USB camera passed to the VM.

## Custom components (install from HACS or GitHub)
auth_oidc (hass-oidc-auth), extended_openai_conversation, ha_behringer_mixer, home_assistant_notes, houseplan, lednetwf_ble, llama_conversation, memory, pawsync, remote_homeassistant, smartrent.

## SSO
auth_oidc with the Authentik app "Home Assistant" (ct110-auth/blueprint-export.yaml). Keep one local break-glass admin.

## Not stored (create your own)
secrets.yaml, .storage (tokens, SSO client secret), ip_bans.yaml, database, backups, HAOS encryption key.

## VM hardware
usb0 and usb1 in host/node-b/guests/101.conf pass USB devices from the node to the VM. Set your own with: qm set 101 -usb0 host=<vendor:product>. Find IDs with lsusb.
