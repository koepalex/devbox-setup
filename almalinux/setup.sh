#!/bin/bash
echo "Linux Almalinux"

echo ">>> zsh installing"
sudo dnf install zsh util-linux-user
chsh -s /bin/zsh
sudo chsh -s /bin/zsh

## General packages
sudo dnf -y install git epel-release
sudo dnf -y install btop cmake gcc make wget tree yum-utils strace mc

echo ">>> oh my zsh installing ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
p10k configure

echo ">>> tmux installing..."
sudo dnf install tmux
echo "set -g default-shell /bin/zsh" > ~/tmux.conf

echo ">>> dotnet installing ..."
sudo dnf -y install dotnet-sdk-7.0
dotnet tool install --global dotnet-counters
cat << \EOF >> ~/.bash_profile
# Add .NET Core SDK tools
export PATH="$PATH:/home/koepalex/.dotnet/tools"
EOF
dotnet tool install --global dotnet-dump
dotnet tool install --global dotnet-symbol

echo ">>> rust installing"
wget -qO - https://sh.rustup.rs | sudo RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/rust sh -s -- --no-modify-path -y
source "/opt/rust/env"
rustup default stable

echo ">>> nodejs installing"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm ls-remote
nvm install v20.9.0
npm install -g yarn

echo ">>> neovim installing"
sudo dnf config-manager --set-enabled crb
sudo dnf -y install ninja-build unzip gettext curl
mkdir src && cd src
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ~/.config
git clone https://github.com/koepalex/neovim-config.git nvim
git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
nvim :PaqInstall
"${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/coc.nvim
yarn install

