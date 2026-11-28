hostname; pveversion | head -n 1; uname -r
echo "== cpu"; lscpu | grep -E "Model name|^CPU\(s\)"
echo "== memory MB"; free -m | head -n 2
echo "== disks"; lsblk -d -o NAME,SIZE,TYPE,ROTA
echo "== zfs"; zpool list
echo "== storage"; pvesm status
echo "== guests"; qm list; pct list
echo "== gpu"; nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv 2>/dev/null || echo "no nvidia gpu"
echo "== usb"; lsusb | cut -d' ' -f6-
