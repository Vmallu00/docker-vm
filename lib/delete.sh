#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

warn "This will permanently delete the VM."

echo
echo "VM Name:"
echo "$VM_NAME"
echo
echo "Disk:"
echo "$DISK_FILE"
echo

read -rp "Are you sure? Type DELETE: " CONFIRM

if [ "$CONFIRM" != "DELETE" ]; then
    info "Delete cancelled."
    exit 0
fi

info "Stopping VM..."

bash "$LIB_DIR/stop.sh" >/dev/null 2>&1 || true

info "Removing VM files..."

rm -f "$DISK_FILE"
rm -f "$PID_FILE"
rm -f "$LOG_FILE"

rm -rf "$CLOUD_DIR"

echo
echo "========================================"
echo " VM Deleted"
echo "========================================"
echo
echo "To create again:"
echo "vm create"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
