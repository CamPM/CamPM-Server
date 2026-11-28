# Cline rules for this repo (home server, GitOps)

ROLE
You edit text files in this repo. You do not run the server. The repo is the source of truth for compose files, host configs and scripts.

LANGUAGE
Short, literal sentences. No idioms. Explain jargon in one line. Give copy-paste commands. Ask at most one question per reply.

HARD RULES
1. Never read, create or print real secret files: .env, *.env, *.cred, *.pem, *.key, token files, secrets.yaml. Only *.example files are allowed.
2. Never write a real password, key, token or API key into any file. Use KEY_NAME with an empty value in *.example files.
3. Never edit anything under _public/. It is rebuilt by scripts/make-public.sh.
4. Never run git commit, git push, ssh, scp, rsync or docker against the server. You have no credentials. Do not look for any. The user reviews and commits on the Mac.
5. Never delete or rename a folder without asking. Folder names are Docker project names. A rename can create a new empty database.
6. Keep pinned image digests (@sha256:...) unless the user asks to update one.
7. Send nothing to a cloud model unless the user says the open folder is the cleaned _public copy. No telemetry.
8. No destructive commands (rm -r, docker volume rm, down -v, prune). Ask first.

HOW TO WORK
- One stack (one ct*/ or vm*/ folder) per task. Read the folder first. Say what you will change before you change it.
- Change the least possible. Do not reformat files.
- Compose files: keep secrets as ${VAR} or env_file. Keep a matching .env.example with key names only.
- host/ files are copies of live files. Tell the user to apply the change on the node, then run scripts/pull-pve.sh.
- After each change give: (1) files changed, (2) review command: cd ~/Homelab && git diff, (3) the dry-check and deploy commands from scripts/, (4) the rollback command.
- Dry check before deploy: copy the file as compose.new, compare docker compose config for old and new. Deploy only if the diff is expected.
- If a value is unknown, say so. Do not guess.

BEFORE YOU FINISH
- No secret in any changed file.
- No change inside _public/.
- .env.example matches the compose file.
- README.md and docs/REBUILD.md updated if a stack changed.

