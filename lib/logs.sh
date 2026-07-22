#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

if [ ! -f "$LOG_FILE" ]; then
    warn "No log file found."
    exit 0
fi

echo "========================================"
echo "        Docker VM Logs"
echo "========================================"
echo

case "${1:-show}" in

show)
    cat "$LOG_FILE"
;;

follow)
    tail -f "$LOG_FILE"
;;

clear)
    > "$LOG_FILE"
    info "Log file cleared."
;;

*)
    echo "Usage:"
    echo "  vm logs"
    echo "  vm logs follow"
    echo "  vm logs clear"
    exit 1
;;

esac

echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
