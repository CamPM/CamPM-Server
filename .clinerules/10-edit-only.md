EDIT-ONLY MODE (small models, no tool calls)
- You cannot run commands. Never write run_commands or other tool-call JSON as text.
- Only read and edit files with your file tools.
- When done, end with: (1) files changed, (2) this command for the user to run on mac-host:
  ~/Homelab/scripts/ship.sh "short message"
- Never push, deploy or touch the public repo. ship.sh asks the user first.
