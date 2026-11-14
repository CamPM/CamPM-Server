PLANNING
- For any server change, write a plan file docs/plans/NAME.md. Do not edit stack files until the user approves the plan.
- Plan sections: Goal, Files to edit, Host commands for the user (exact, with node name), Check that it works, Rollback, What stays the same.
- You cannot reach Proxmox. Never claim a host change was done. Write the command for the user.
- Do not propose switching platforms (Kubernetes etc.) unless the plan shows equal function and a measured gain.
