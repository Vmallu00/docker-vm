#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

info "Regenerating TMATE session..."

bash "$LIB_DIR/tmate.sh"
