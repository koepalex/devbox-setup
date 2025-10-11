#!/bin/bash

# Clear screen
clear
echo "=== koepalex/devbox-setup for Ubuntu ==="

# Exit on any error
set -e

# Source utility functions
source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

# Update the system first
echo "➡️ Updating system..."
sudo apt update
sudo apt upgrade -y

echo "➡️ Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"
  
echo "➡️ Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

echo "➡️ Updating submodules"
pushd ..
git submodule update --recursive --remote
popd

echo "➡️ Installing font..."
install_font

echo "➡️ Installing neovim ..."
install_neovim

echo "➡️ Installing rust ..."
install_rust

echo "➡️ Installing rust based packages ..."
install_rust_packages "${RUST_BASED[@]}"

echo "➡️ Installing starship Theme ..."
install_starship

echo "➡️ Installing carapace ..."
install_carapace

echo "➡️ Installing GitHub CLI ..."
install_gh_cli

echo "➡️ Installing Go lang ..."
install_go

echo "➡️ Installing dotnet ..."
install_dotnet

echo "➡️ Installing NodeJS ..."
install_node

echo "➡️ Installing fastfetch ..."
install_fastfetch

echo "➡️ Installing operations tooling ..."
install_packages "${OPERATIONS_UTILS[@]}"

echo "➡️ Installing kubectl ..."
install_kubectl

echo "➡️ Installing kubectx and kubens ..."
install_kubectx

echo "➡️ Installing helm ..."
install_helm

echo "➡️ Installing kubernetes CLI client ..."
install_k9s

echo "➡️ Installing lazygit ..."
install_lazygit

echo "➡️ Installing lazydocker ..."
install_lazydocker

echo "➡️ Setting Default shell to zsh"
chsh -s /bin/zsh
sudo chsh -s /bin/zsh

echo "➡️ Installing Docker"
install_docker

echo "➡️ Installing KeepassXC"
install_keepassxc

echo "➡️ Generating SSH key is necessary"
generate_ssh_key

echo "➡️ Changing SSH port to 42069"
sudo sed -i 's/#Port 22/Port 42069/' /etc/ssh/sshd_config

echo "➡️ Disable root login via SSH"
sudo sed -i 's/#PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

source dotfiles-setup.sh

source setup-repos.sh

echo "➡️ Clean up unused packages ..."
sudo apt auto-remove -y

# Enable services
echo "➡️ Configuring services..."
for service in "${SERVICES[@]}"; do
if ! systemctl is-enabled "$service" &> /dev/null; then
  echo "➡️ Start and Enabling $service..."
  sudo systemctl start "$service"
  sudo systemctl enable "$service"
else
  echo "➡️ $service is already enabled"
fi
done

echo "➡️ Dry run of unattended upgrades, to verify everything is working as expected"
sudo unattended-upgrades --dry-run --debug

echo "➡️ Setup complete! You may want to reboot your system."
