#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

SOCKET="$RUNTIME_DIR/monitor.sock"

if [ ! -f "$PID_FILE" ]; then
    error "Virtual Machine is not running."
    exit 1
fi

PID=$(cat "$PID_FILE")

if ! kill -0 "$PID" 2>/dev/null; then
    rm -f "$PID_FILE"
    error "Virtual Machine is not running."
    exit 1
fi

if [ ! -S "$SOCKET" ]; then
    error "Monitor socket not found."
    echo
    echo "Restart the VM:"
    echo "  vm restart"
    exit 1
fi

echo
echo "========================================"
echo " Docker VM Terminal"
echo "========================================"
echo
echo "Press Ctrl+] to exit."
echo

socat -,raw,echo=0 UNIX-CONNECT:"$SOCKET"
