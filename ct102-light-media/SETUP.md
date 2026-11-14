# Jellyfin setup notes (CT102)
Plugin configs are NOT stored here. They hold secrets and user IDs. Set them in Jellyfin: Dashboard > Plugins.

## Plugins folders seen
Custom Tabs, DLNA, File Transformation, LDAP Authentication, Media Bar, MindTheGaps, Moonbase, Open Subtitles, Playback Reporting, Plugin Pages, ReplayGain, Reports, SSO-Auth (MaxRink fork), SeerrFin, Session Cleaner, Subtitle Extract.
Config files also exist for JellyEmu, JellyFrame, SkinManager, HomeScreenSections, Moonfin, ListenBrainz and others. I did not check that these are installed.

## Login design
- Password login: LDAP Authentication plugin against the Authentik LDAP outpost.
- SSO login: SSO-Auth plugin, provider name "authentik", OIDC client from the Authentik blueprint (ct110-auth/blueprint-export.yaml).
- One local break-glass admin user keeps the Default provider. Store its password in your password manager.

## LDAP plugin settings (no secrets)
- Server: Authentik LDAP outpost host, port 636, SSL on, skip SSL verify on.
- Bind user: cn=ldapservice,ou=users,DC=ldap,DC=goauthentik,DC=io (create the user, give it the ldap-search role).
- Base DN: ou=users,DC=ldap,DC=goauthentik,DC=io
- Search filter: (memberOf=cn=jellyfin,ou=groups,DC=ldap,DC=goauthentik,DC=io)
- Admin base DN: ou=users,DC=ldap,DC=goauthentik,DC=io
- Admin filter: (memberOf=cn=jellyfin-admin,ou=groups,DC=ldap,DC=goauthentik,DC=io)
- Create users from LDAP: off. Case-insensitive username: on.
- After any LDAP policy change in Authentik, restart the LDAP outpost (it caches binds).

## Secrets you must create yourself
Authentik OIDC client secret, LDAP bind password, Jellyseerr/Seerr key, Lidarr key, OpenSubtitles login, Moonfin webhook secret.
