#!/bin/bash
# Runs at boot on battery-less laptop nodes (node-b, node-c).
# A full power loss resets firmware NVRAM, which re-enables Secure Boot
# and blocks unsigned kernel modules (e.g. the NVIDIA dkms module).
# This cannot be prevented in software; this script only detects and warns.
set -uo pipefail
SB_MOTD=/etc/update-motd.d/98-secureboot-warn
NV_MOTD=/etc/update-motd.d/99-nvidia-warn

STATE=$(mokutil --sb-state 2>&1)
if echo "$STATE" | grep -qi "SecureBoot enabled"; then
  cat > "$SB_MOTD" <<MOTD
#!/bin/bash
echo ""
echo "#####################################################################"
echo "# WARNING: Secure Boot is ENABLED on \$(hostname)."
echo "# This node has no internal battery. A full power loss resets"
echo "# firmware NVRAM and re-enables Secure Boot, blocking the NVIDIA"
echo "# driver and other unsigned kernel modules."
echo "# Fix: reboot, enter BIOS/UEFI setup, disable Secure Boot, save."
echo "# This banner clears itself once Secure Boot is confirmed disabled."
echo "#####################################################################"
echo ""
MOTD
  chmod +x "$SB_MOTD"
  logger -p daemon.err -t secureboot-check "Secure Boot is ENABLED on $(hostname). Likely firmware reset after power loss."
else
  rm -f "$SB_MOTD"
fi

if lspci 2>/dev/null | grep -qi nvidia; then
  ERRFILE=$(mktemp)
  if ! modprobe nvidia 2>"$ERRFILE"; then
    REASON=$(cat "$ERRFILE")
    logger -p daemon.err -t secureboot-check "nvidia module failed to load: $REASON"
    cat > "$NV_MOTD" <<MOTD
#!/bin/bash
echo "WARNING: NVIDIA module failed to load on \$(hostname)."
echo "Reason: $REASON"
echo "Check: mokutil --sb-state"
MOTD
    chmod +x "$NV_MOTD"
  else
    rm -f "$NV_MOTD"
  fi
  rm -f "$ERRFILE"
fi
