#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

mkdir -p "$RUNTIME_DIR"
mkdir -p "$LOG_DIR"

if [ ! -f "$DISK_FILE" ]; then
    error "Virtual Machine not found."
    echo
    echo "Run:"
    echo "  vm create"
    exit 1
fi

if [ -f "$PID_FILE" ]; then

    PID=$(cat "$PID_FILE")

    if kill -0 "$PID" 2>/dev/null; then
        warn "Virtual Machine is already running."
        exit 0
    else
        rm -f "$PID_FILE"
    fi

fi

info "Starting Virtual Machine..."

QEMU_CMD=(
qemu-system-x86_64
-enable-kvm
-machine q35
-cpu max
-smp "$VM_CPU"
-m "$VM_RAM"

-drive file="$DISK_FILE",if=virtio

-drive file="$CLOUD_ISO",media=cdrom

-nographic

-netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22

-device virtio-net-pci,netdev=net0
)
