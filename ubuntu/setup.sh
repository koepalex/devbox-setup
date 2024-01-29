#!/bin/bash
echo "Ubuntu Setup"

echo ">>> zsh installing"
sudo apt -y install zsh
chsh -s /bin/zsh
sudo chsh -s /bin/zsh

sudo apt -y install btop cmake gcc make wget curl tree strace mc

echo ">>> Jetbrains mono font installing ..."
sudo apt install -y fonts-jetbrains-mono 
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
mkdir ~/.local/share/fonts/
mv JetBrainsMono/*.ttf ~/,local/share/fonts

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
# Delete PMC repository
sudo rm /etc/apt/sources.list.d/microsoft-prod.list
# Update packages
sudo apt update
sudo apt install -y dotnet-sdk-7.0

echo "GitHub CLI installing..."
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

echo "dotnet tools installing..."
sudo mkdir /opt/tools
sudo chown $USER:users 
dotnet tool install dotnet-symbol --tool-path /opt/tools
dotnet tool install dotnet-counters --tool-path /opt/tools
dotnet tool install dotnet-dump --tool-path /opt/tools

echo "Loading dotnet symbols"
/opt/tools/dotnet-symbol /usr/lib/dotnet/shared/Microsoft.NETCore.App/7.0.??/*

echo "Loading debug symbols"
# Adding repositories with debug information
sudo apt install -y software-properties-common
echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse
deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse | \
deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" | \
sudo tee -a /etc/apt/sources.list.d/ddebs.list
sudo apt install -y ubuntu-dbgsym-keyring
sudo apt update
sudo apt install -y libc6-dbg libssl3-dbgsym openssl-dbgsym libicu70-dbgsym libstdc++6-dbgsym 
