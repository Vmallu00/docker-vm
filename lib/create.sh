#!/usr/bin/env bash

set -e

source /opt/docker-vm/lib/config.sh

banner

mkdir -p \
"$IMAGE_DIR" \
"$VM_DIR" \
"$CLOUD_DIR" \
"$LOG_DIR" \
"$RUNTIME_DIR"

info "Preparing Virtual Machine..."

IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

if [ ! -f "$IMAGE_FILE" ]; then

    info "Downloading Ubuntu 24.04 Cloud Image..."

    wget -O "$IMAGE_FILE" "$IMAGE_URL"

    info "Download completed."

else

    info "Ubuntu image already exists."

fi

if [ ! -f "$DISK_FILE" ]; then

    info "Creating VM disk..."

    qemu-img create \
        -f qcow2 \
        -F qcow2 \
        -b "$IMAGE_FILE" \
        "$DISK_FILE" \
        "$VM_DISK"

    info "VM disk created."

else

    warn "VM disk already exists."

fi

cat >> lib/create.sh <<'EOF'

info "Generating Cloud-Init..."

cat > "$CLOUD_DIR/user-data" <<CLOUDCFG
#cloud-config

hostname: ubuntu-vm
manage_etc_hosts: true

disable_root: false
ssh_pwauth: true

chpasswd:
  list: |
    root:root
  expire: false

package_update: true
package_upgrade: true

packages:
  - qemu-guest-agent
  - openssh-server
  - curl
  - wget
  - git
  - unzip
  - tmate

runcmd:
  - systemctl enable ssh
  - systemctl restart ssh
  - systemctl enable qemu-guest-agent
  - systemctl restart qemu-guest-agent

final_message: "Docker VM Manager VM Ready"

CLOUDCFG

cat > "$CLOUD_DIR/meta-data" <<METADATA
instance-id: ubuntu-vm
local-hostname: ubuntu-vm
METADATA

cloud-localds \
    "$CLOUD_ISO" \
    "$CLOUD_DIR/user-data" \
    "$CLOUD_DIR/meta-data"

info "Cloud-Init ISO created."

EOF

info "=========================================="
info "Virtual Machine created successfully!"
info "=========================================="

echo
echo "VM Name      : $VM_NAME"
echo "RAM          : ${VM_RAM} MB"
echo "CPU          : $VM_CPU Core(s)"
echo "Disk         : $VM_DISK"
echo "SSH Port     : $SSH_PORT"
echo
echo "Commands:"
echo "  vm start"
echo "  vm status"
echo "  vm terminal"
echo "  vm tmate"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"
