#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

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

info "Connecting to VM..."

SSH="ssh -o StrictHostKeyChecking=no \
-o UserKnownHostsFile=/dev/null \
-p ${SSH_PORT} root@127.0.0.1"

info "Stopping old TMATE session..."

$SSH "pkill -9 tmate >/dev/null 2>&1 || true"

info "Removing old socket..."

$SSH "rm -f /tmp/tmate.sock"

info "Starting TMATE..."

$SSH "tmate -S /tmp/tmate.sock new-session -d"
