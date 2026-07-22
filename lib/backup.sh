#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

BACKUP_DIR="$BASE_DIR/backups"

mkdir -p "$BACKUP_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

BACKUP_FILE="$BACKUP_DIR/${VM_NAME}_${DATE}.tar.gz"

if [ ! -f "$DISK_FILE" ]; then
    error "Virtual Machine not found."
    exit 1
fi

info "Creating backup..."

tar -czf "$BACKUP_FILE" \
    "$DISK_FILE" \
    "$CLOUD_DIR"

echo
echo "========================================"
echo " Backup Complete"
echo "========================================"
echo
echo "File:"
echo "$BACKUP_FILE"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
