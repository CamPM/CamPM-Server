#!/bin/bash
# Live path: /usr/local/sbin/safe-reboot.sh (node-b). Mode 755.
PINNED="ct:107"
MARK=/var/lib/safe-reboot.marker
LOG=/var/log/safe-reboot.log
log() { echo "$(date '+%F %T') $*" >> $LOG; }
case "$1" in
down)
  if ! systemctl list-jobs --no-legend | grep -qE 'reboot.target|poweroff.target|halt.target|shutdown.target'; then
    log "down: not a shutdown, skipped"; exit 0
  fi
  : > $MARK
  for g in $PINNED; do
    if ha-manager status | grep -q "service $g (.*, started)"; then
      echo $g >> $MARK
      ha-manager set $g --state stopped
      log "down: requested stop for $g"
    fi
  done
  for i in $(seq 1 20); do
    ok=1
    for g in $(cat $MARK); do
      ha-manager status | grep -q "service $g (.*, stopped)" || ok=0
    done
    [ $ok = 1 ] && break
    sleep 5
  done
  log "down: done after $i checks, marker: $(cat $MARK | tr '\n' ' ')"
  ;;
up)
  [ -s $MARK ] || { log "up: marker empty, nothing to start"; exit 0; }
  for i in $(seq 1 60); do
    if pvecm status 2>/dev/null | grep -q "Quorate:.*Yes" && ha-manager status 2>/dev/null | grep -q "lrm $(hostname) (active"; then break; fi
    sleep 5
  done
  for g in $(cat $MARK); do
    ha-manager set $g --state started
    log "up: requested start for $g"
  done
  : > $MARK
  ;;
esac
