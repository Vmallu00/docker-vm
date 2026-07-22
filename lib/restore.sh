#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

BACKUP_DIR="$BASE_DIR/backups"

if [ ! -d "$BACKUP_DIR" ]; then
    error "No backup directory found."
    exit 1
fi

LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -n1)

if [ -z "$LATEST_BACKUP" ]; then
    error "No backups found."
    exit 1
fi

warn "This will overwrite the current VM."

read -rp "Continue? (y/N): " ANSWER

case "$ANSWER" in
y|Y|yes|YES)
    ;;
*)
    info "Restore cancelled."
    exit 0
    ;;
esac

info "Stopping VM..."

bash "$LIB_DIR/stop.sh" >/dev/null 2>&1 || true

info "Restoring backup..."

tar -xzf "$LATEST_BACKUP" -C /

echo
echo "========================================"
echo " Restore Complete"
echo "========================================"
echo
echo "Backup:"
echo "$LATEST_BACKUP"
echo
echo "Start the VM with:"
echo "vm start"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
