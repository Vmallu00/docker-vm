#!/usr/bin/env bash

set -e

VERSION="1.0.0"
AUTHOR="slayer_999_13432"

BASE_DIR="/opt/docker-vm"

LIB_DIR="$BASE_DIR/lib"
QEMU_DIR="$BASE_DIR/qemu"
IMAGE_DIR="$BASE_DIR/images"
VM_DIR="$BASE_DIR/vms"
CLOUD_DIR="$BASE_DIR/cloud-init"
RUNTIME_DIR="$BASE_DIR/runtime"
LOG_DIR="$BASE_DIR/logs"
SYSTEMD_DIR="$BASE_DIR/systemd"

VM_NAME="ubuntu-vm"
VM_RAM="4096"
VM_CPU="2"
VM_DISK="20G"
VM_SSH_PORT="2222"

GREEN="\e[1;32m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
PURPLE="\e[38;5;129m"
WHITE="\e[1;37m"
RESET="\e[0m"

banner() {
clear

echo -e "${PURPLE}"
cat << "EOF"

                     𓆰𓆪

██████╗  ██╗   ██╗███╗   ███╗
██╔══██╗ ██║   ██║████╗ ████║
██║  ██║ ██║   ██║██╔████╔██║
██║  ██║ ╚██╗ ██╔╝██║╚██╔╝██║
██████╔╝  ╚████╔╝ ██║ ╚═╝ ██║
╚═════╝    ╚═══╝  ╚═╝     ╚═╝

          Docker VM Manager

                     𓆰𓆪

EOF

echo -e "${CYAN}Version : ${VERSION}${RESET}"
echo -e "${WHITE}Powered by : ${AUTHOR}${RESET}"
echo
}

info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

create_dirs() {

mkdir -p \
"$LIB_DIR" \
"$QEMU_DIR" \
"$IMAGE_DIR" \
"$VM_DIR" \
"$CLOUD_DIR" \
"$RUNTIME_DIR" \
"$LOG_DIR" \
"$SYSTEMD_DIR"

}

install_packages() {

info "Installing required packages..."

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y \
wget \
curl \
git \
tmate \
screen \
qemu-system-x86 \
qemu-utils \
cloud-image-utils \
genisoimage \
openssh-client

info "Packages installed."

}

download_image() {

info "Checking Ubuntu image..."

IMAGE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
IMAGE_FILE="$IMAGE_DIR/noble-server-cloudimg-amd64.img"

if [ -f "$IMAGE_FILE" ]; then
    info "Ubuntu image already exists."
    return
fi

info "Downloading Ubuntu 24.04 Cloud Image..."

wget -O "$IMAGE_FILE" "$IMAGE_URL"

info "Download completed."

}

create_disk() {

DISK="$VM_DIR/$VM_NAME.qcow2"

if [ -f "$DISK" ]; then
    warn "VM disk already exists."
    return
fi

info "Creating VM disk..."

qemu-img create \
-f qcow2 \
-F qcow2 \
-b "$IMAGE_FILE" \
"$DISK" \
"$VM_DISK"

info "Disk created."

}

create_cloudinit() {

info "Generating Cloud-Init..."

mkdir -p "$CLOUD_DIR"

cat > "$CLOUD_DIR/user-data" <<EOF
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
 - curl
 - wget
 - git
 - unzip
 - openssh-server
 - tmate
 - qemu-guest-agent

runcmd:
 - systemctl enable ssh
 - systemctl restart ssh
 - systemctl enable qemu-guest-agent
 - systemctl restart qemu-guest-agent

final_message: "Docker VM Manager Ready."

EOF

cat > "$CLOUD_DIR/meta-data" <<EOF
instance-id: ubuntu-vm
local-hostname: ubuntu-vm
EOF

cloud-localds \
"$CLOUD_DIR/cloud-init.iso" \
"$CLOUD_DIR/user-data" \
"$CLOUD_DIR/meta-data"

info "Cloud-Init created."

}

install_vm_command() {

info "Installing vm command..."

cp "$BASE_DIR/vm" /usr/local/bin/vm

chmod +x /usr/local/bin/vm

info "vm command installed."

}


check_dependencies() {

command -v qemu-system-x86_64 >/dev/null || {
    error "QEMU is not installed."
    exit 1
}

command -v cloud-localds >/dev/null || {
    error "cloud-image-utils is not installed."
    exit 1
}

}


finish_install() {

banner

echo
echo "========================================"
echo " Docker VM Manager Installed"
echo "========================================"
echo
echo "Commands:"
echo
echo " vm create"
echo " vm start"
echo " vm stop"
echo " vm restart"
echo " vm status"
echo " vm terminal"
echo " vm ssh"
echo " vm tmate"
echo " vm regen"
echo
echo "Powered by $AUTHOR"
echo "𓆰𓆪"

}


main() {

banner

info "Starting installation..."

create_dirs

install_packages

check_dependencies

install_vm_command

finish_install

}


main
