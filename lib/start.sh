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

QEMU_CMD+=(
-daemonize
-pidfile "$PID_FILE"

-D "$LOG_FILE"

-monitor unix:$RUNTIME_DIR/monitor.sock,server,nowait

-boot c

-rtc base=utc

-device virtio-rng-pci
-device virtio-balloon-pci

-no-reboot
)

"${QEMU_CMD[@]}"

sleep 5

if [ ! -f "$PID_FILE" ]; then
    error "Failed to start Virtual Machine."
    exit 1
fi

PID=$(cat "$PID_FILE")

if ! kill -0 "$PID" 2>/dev/null; then
    error "QEMU exited unexpectedly."
    exit 1
fi

info "Virtual Machine started successfully."

echo
echo "========================================"
echo " Docker VM Manager"
echo "========================================"
echo
echo "Status : RUNNING"
echo "PID    : $PID"
echo
echo "SSH"
echo "ssh -p ${SSH_PORT} root@127.0.0.1"
echo
echo "Run:"
echo "vm status"
echo "vm terminal"
echo "vm tmate"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
