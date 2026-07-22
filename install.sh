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
