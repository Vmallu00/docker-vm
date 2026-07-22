#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

info "Restarting Virtual Machine..."

bash "$LIB_DIR/stop.sh"

sleep 2

bash "$LIB_DIR/start.sh"
