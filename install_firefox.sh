#!/bin/bash

# REQUIRES FLATPAK

SSH_USER="debian"
VM_IP="10.13.99.2"

ssh ${SSH_USER}@${VM_IP} << EOF
  sudo flatpak install flathub org.mozilla.firefox -y
EOF
