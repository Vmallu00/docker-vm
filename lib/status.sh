#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

echo "========================================"
echo "        Docker VM Manager"
echo "========================================"

if [ ! -f "$PID_FILE" ]; then
    echo "Status : STOPPED"
    exit 0
fi

PID=$(cat "$PID_FILE")

if ! kill -0 "$PID" 2>/dev/null; then
    echo "Status : STOPPED"
    rm -f "$PID_FILE"
    exit 0
fi

echo "Status   : RUNNING"
echo "PID      : $PID"
echo "VM Name  : $VM_NAME"
echo "RAM      : ${VM_RAM} MB"
echo "CPU      : $VM_CPU Core(s)"
echo "Disk     : $VM_DISK"
echo "SSH Port : $SSH_PORT"

echo
echo "SSH Command:"
echo "ssh -p ${SSH_PORT} root@127.0.0.1"

echo
echo "Disk Image:"
echo "$DISK_FILE"

echo
echo "Log File:"
echo "$LOG_FILE"

echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
