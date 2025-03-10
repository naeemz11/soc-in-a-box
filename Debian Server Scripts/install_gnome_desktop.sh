SSH_USER="debian"
VM_IP="10.13.99.2"

ssh ${SSH_USER}@${VM_IP} << EOF
  sudo apt-get install task-gnome-desktop -y
  sudo apt install flatpak -y
  sudo apt install gnome-software-plugin-flatpak -y
  sudo apt install plasma-discover-backend-flatpak -y
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo reboot
EOF

