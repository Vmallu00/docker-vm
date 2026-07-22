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

for i in {1..20}; do

SESSION=$($SSH "tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' 2>/dev/null || true")

if [ -n "$SESSION" ]; then
    break
fi

sleep 1

done

if [ -z "$SESSION" ]; then

    error "Failed to create TMATE session."

    exit 1

fi

echo
echo "========================================"
echo "        Docker VM Manager"
echo "========================================"
echo
echo "TMATE SESSION"
echo
echo "$SESSION"
echo
echo "Copy the command above and connect."
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
