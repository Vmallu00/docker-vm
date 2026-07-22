#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

mkdir -p "$RUNTIME_DIR"
mkdir -p "$LOG_DIR"

if [ ! -f "$DISK_FILE" ]; then
    error "VM does not exist."
    echo
    echo "Run:"
    echo "  vm create"
    exit 1
fi

if [ ! -f "$CLOUD_ISO" ]; then
    error "Cloud-Init ISO not found."
    echo
    echo "Run:"
    echo "  vm create"
    exit 1
fi

if [ -f "$PID_FILE" ]; then

    PID=$(cat "$PID_FILE")

    if kill -0 "$PID" 2>/dev/null; then
        warn "VM is already running."
        exit 0
    fi

    rm -f "$PID_FILE"

fi

info "Starting Virtual Machine..."

QEMU_CMD=(
qemu-system-x86_64

-accel tcg
-machine q35
-cpu max

-smp "$VM_CPU"
-m "$VM_RAM"

-name "$VM_NAME"

-drive file="$DISK_FILE",if=virtio,format=qcow2

-drive file="$CLOUD_ISO",media=cdrom

-netdev user,id=net0,hostfwd=tcp::${SSH_PORT}-:22
-device virtio-net-pci,netdev=net0

-nographic
)
