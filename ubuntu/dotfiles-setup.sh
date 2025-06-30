#! /bin/bash
stow_dotfile() {
    local dotfiles=("$@")
    for dotfile in "${dotfiles[@]}"; do
        echo "creating symbolic link for config file $dotfile"
        stow --target=/home/$USER "$dotfile"
    done
}

# Source the dotfiles list
if [ ! -f "dotfiles.conf" ]; then
  echo "Error: dotfiles.conf not found!"
  exit 1
fi

source packages.conf

pushd ../dotfiles 
echo "Installing dotfiles"
stow_dotfile "${DOTFILES[@]}"
popd
