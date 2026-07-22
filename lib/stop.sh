#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

if [ ! -f "$PID_FILE" ]; then
    warn "Virtual Machine is not running."
    exit 0
fi

PID=$(cat "$PID_FILE")

if ! kill -0 "$PID" 2>/dev/null; then
    warn "Stale PID file found."

    rm -f "$PID_FILE"

    exit 0
fi

info "Stopping Virtual Machine..."

kill "$PID"

for i in {1..15}; do

    if ! kill -0 "$PID" 2>/dev/null; then
        rm -f "$PID_FILE"
        info "Virtual Machine stopped successfully."
        exit 0
    fi

    sleep 1

done

warn "Force stopping Virtual Machine..."

kill -9 "$PID" 2>/dev/null || true

rm -f "$PID_FILE"

info "Virtual Machine stopped."

echo
echo "========================================"
echo " Docker VM Manager"
echo "========================================"
echo
echo "Status : STOPPED"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
