#!/bin/bash
echo "Ubuntu Setup"

echo ">>> zsh installing"
sudo apt -y install zsh
chsh -s /bin/zsh
sudo chsh -s /bin/zsh

sudo apt -y install btop cmake gcc make wget curl tree strace mc

echo ">>> Jetbrains mono font installing ..."
sudo apt install -y fonts-jetbrains-mono 

echo ">>> oh my zsh installing ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
p10k configure

echo ">>> tmux installing..."
sudo dnf install tmux
echo "set -g default-shell /bin/zsh" > ~/tmux.conf

echo ">>> neovim installing"
sudo apt -y install ninja-build unzip gettext
mkdir src && cd src
git clone --depth=1 https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ~/.config
git clone --depth=1 https://github.com/koepalex/NVChad nvim

echo ">>> rust installing..."
wget -qO - https://sh.rustup.rs | sudo RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/rust sh -s -- --no-modify-path -y
source "/opt/rust/env"
rustup default stable

echo ">>> dotnet installing..."
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
# Download Microsoft signing key and repository
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
# Install Microsoft signing key and repository
sudo dpkg -i packages-microsoft-prod.deb
# Clean up
rm packages-microsoft-prod.deb
# Update packages
sudo apt update
sudo apt install -y dotnet-sdk-7.0

