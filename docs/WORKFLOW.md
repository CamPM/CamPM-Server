# Workflow: code editor, Cline, repo, server

Cline edits files. You review and commit on the Mac. Scripts deploy. A rebuild updates the public repo.
Cline has no Git token and no SSH key. This is on purpose.

## Where things live
- Private repo: ~/Homelab on the Mac. Real values. Shared by SMB to CT103.
- Editor: code-server in CT103, behind the Authentik login. Folder: Homelab.
- Public copy: ~/Homelab/_public (ignored by the private repo). Built by scripts/make-public.sh.
- LLM: LM Studio on the Mac (OpenAI-compatible API). Keep it the only provider.

## Steps
1. Edit. Open the editor, open Homelab, edit by hand or ask Cline. Do not edit _public.
2. Review (Mac): git status --short, then git diff. Check for secrets.
3. Commit and push private (Mac): run the secret scan, then git commit and git push.
4. Deploy (Mac): scripts/deploy-ct<N>.sh copies the compose file and runs docker compose up -d. It never copies .env. For risky changes do the dry check first.
5. Host files: they are copies. Change the live file on the node, then run scripts/pull-pve.sh.
6. Public repo (Mac): run scripts/make-public.sh. Check the scans print only the known pi-hole line. Then push from _public with git push --force -u origin main. A public push cannot be undone.

## Cline setup
- Provider: OpenAI Compatible. Base URL: the LM Studio address, ending in /v1. Token from LM Studio. Type it only in the editor.
- Rules: .clinerules in the repo root is the starter prompt. If it does not load, paste it into Cline custom instructions.
- Turn off auto-approve for commands. Cline runs commands inside CT103 only, which has no keys.
- Keep Cline auto update off. Update by choice.

## Cautions
- The Mac must stay awake. The share and LM Studio need it.
- Never delete and recreate ~/Homelab. The mount goes stale.
- Dry check: copy the file as compose.new, run docker compose -f compose.new config and compare with the live file.
- Rollback: each deploy leaves compose.yml.bak-gitops on the CT.
