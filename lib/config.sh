#!/usr/bin/env bash

VERSION="1.0.0"
AUTHOR="slayer_999_13432"

BASE_DIR="/opt/docker-vm"

LIB_DIR="$BASE_DIR/lib"
IMAGE_DIR="$BASE_DIR/images"
VM_DIR="$BASE_DIR/vms"
CLOUD_DIR="$BASE_DIR/cloud-init"
LOG_DIR="$BASE_DIR/logs"
RUNTIME_DIR="$BASE_DIR/runtime"
SYSTEMD_DIR="$BASE_DIR/systemd"

VM_NAME="ubuntu-vm"

VM_RAM="4096"
VM_CPU="2"
VM_DISK="20G"

SSH_PORT="2222"
TMATE_PORT="2223"

IMAGE_FILE="$IMAGE_DIR/noble-server-cloudimg-amd64.img"
DISK_FILE="$VM_DIR/$VM_NAME.qcow2"
CLOUD_ISO="$CLOUD_DIR/cloud-init.iso"

PID_FILE="$RUNTIME_DIR/$VM_NAME.pid"
LOG_FILE="$LOG_DIR/$VM_NAME.log"

GREEN="\e[1;32m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
PURPLE="\e[38;5;129m"
WHITE="\e[1;37m"
RESET="\e[0m"

info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

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
