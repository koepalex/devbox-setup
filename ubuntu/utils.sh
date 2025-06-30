#!/bin/bash

# Function to check if a package is installed
is_installed() {
    PACKAGE="$1"
    if dpkg-query -W -f='${Status}' $PACKAGE 2>/dev/null | grep -q "ok installed"; then
        echo "➡️$PACKAGE is installed"
        return 0
    else
        echo "➡️$PACKAGE is not installed"
        return 1
    fi
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "➡️Installing: ${to_install[*]}"
    sudo apt install -y "${to_install[@]}"
  fi
}

# Function to install RUST based packages
install_rust_packages() {
  local packages=("$@")
  
  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "➡️Installing rust based package: ${to_install[*]}"
    cargo install "${to_install[@]}"
  fi
}

# Function to install Jet Brains Mono Font
install_font() {
    if [ -d /usr/share/fonts/truetype/jetbrains-mono ]; then
        sudo rm -rf /usr/share/fonts/truetype/jetbrains-mono
    fi

    FONT_VERSION=$(curl -s "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
    curl -sSLo jetbrains-mono.zip https://download.jetbrains.com/fonts/JetBrainsMono-$FONT_VERSION.zip
    unzip -qq jetbrains-mono.zip -d jetbrains-mono
    sudo mkdir /usr/share/fonts/truetype/jetbrains-mono
    sudo mv jetbrains-mono/fonts/ttf/*.ttf /usr/share/fonts/truetype/jetbrains-mono
    rm -rf jetbrains-mono.zip jetbrains-mono
}

# GO lang
install_go() {
    if [ -d /usr/local/go ]; then
        sudo rm -rf /usr/local/go
    fi

    VERSION="1.24.4" 
    ARCH="amd64" 
    curl -O -L "https://golang.org/dl/go${VERSION}.linux-${ARCH}.tar.gz"
    tar -xf "go${VERSION}.linux-${ARCH}.tar.gz"
    sudo chown -R $USER:users ./go
    sudo mv -v go /usr/local
    rm "go${VERSION}.linux-${ARCH}.tar.gz"
}

# Node.JS
install_node() {
    NVM_VERSION="v0.40.3"
    VERSION="24"
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    # Download and install Node.js:
    nvm install $VERSION
    corepack enable pnpm
}

# Terminal theme
install_starship() {
    curl -sS https://starship.rs/install.sh | sh 
}

# Suggestions for terminal commands
install_carapace() {
    echo "deb [trusted=yes] https://apt.fury.io/rsteube/ /" | sudo tee /etc/apt/sources.list.d/fury.list
    sudo apt update && sudo apt install carapace-bin
}

# Function to install neovim
install_neovim() {
    git clone --depth 1 --branch master --single-branch https://github.com/neovim/neovim
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd ..
    rm -rf neovim
}

# Function to install rust
install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . "$HOME/.cargo/env"
    rustup default stable
}

# Function to install GitHub CLI
install_gh_cli() {
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	    && sudo mkdir -p -m 755 /etc/apt/keyrings \
            && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
    	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    	&& sudo apt update \
        && sudo apt install gh -y
}

# Function to install FastFetch
install_fastfetch() {
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo apt install -y fastfetch
}

# Function to install CLI Kubernetes client
install_k9s() {
    wget https://github.com/derailed/k9s/releases/latest/download/k9s_linux_amd64.deb && sudo apt install ./k9s_linux_amd64.deb && sudo rm k9s_linux_amd64.deb
}

# Function to install Kubernetes CLI
install_kubectl() {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
}

# Function to install HELM
install_helm() {
    https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh
}

#Function to install Lazy Git
install_lazygit() {
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit.tar.gz
}

# Function to install Lazy Docker
install_lazydocker() {
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazydocker.tar.gz lazydocker
    sudo install lazydocker -D -t /usr/local/bin/
    rm lazydocker.tar.gz
}

# Function to install dotnet9-sdk
install_dotnet() {
    sudo add-apt-repository ppa:dotnet/backports
    sudo apt update && sudo apt install -y dotnet-sdk-9.0
}

# Function to install kubectx/kubens
install_kubectx() {
    VERSION=$(curl -s "https://api.github.com/repos/ahmetb/kubectx/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo kubectx.tar.gz "https://github.com/ahmetb/kubectx/releases/download/v${VERSION}/kubectx_v${VERSION}_linux_x86_64.tar.gz"
    tar xf kubectx.tar.gz kubectx
    sudo install kubectx -D -t /usr/local/bin
    rm kubectx.tar.gz
}
