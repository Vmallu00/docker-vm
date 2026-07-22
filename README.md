# 𓆰𓆪 Docker VM Manager (DVM) 𓆰𓆪

A lightweight Virtual Machine Manager for Docker VPS environments that do not support KVM.

---

## Features

- Ubuntu 24.04 Virtual Machine
- QEMU TCG (No /dev/kvm Required)
- Persistent VM Storage
- Auto Start
- Interactive CLI
- SSH Access
- Background TMATE
- VM Logs
- Backup & Restore
- VM Update
- VM Delete

---

## Commands

```bash
vm
vm create
vm start
vm stop
vm restart
vm status
vm terminal
vm ssh
vm tmate
vm regen
vm logs
vm backup
vm restore
vm update
vm delete
```

---

## Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/docker-vm/main/install.sh)
```

---

## Default VM

| Setting | Value |
|---------|-------|
| OS | Ubuntu 24.04 LTS |
| CPU | 2 Cores |
| RAM | 4 GB |
| Disk | 20 GB |
| SSH Port | 2222 |

---

## Project Structure

```
docker-vm/
├── install.sh
├── update.sh
├── uninstall.sh
├── vm
├── lib/
├── cloud-init/
├── qemu/
├── runtime/
├── systemd/
├── images/
├── vms/
└── logs/
```

---

## License

MIT License

---

# 𓆰𓆪

**Powered by**

## slayer_999_13432

𓆰𓆪
