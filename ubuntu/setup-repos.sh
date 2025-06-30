#! /bin/bash

clone_repositories() {
    local repos=("$@")
    for repo in "${repos[@]}"; do
        echo "➡️Clone repository $repo"
        gh repo clone "$repo"
    done
}

# Source the repositories list
if [ ! -f "repos.conf" ]; then
  echo "Error: repos.conf not found!"
  exit 1
fi

source repos.conf

mkdir -p ~/repos

pushd  ~/repos
echo "➡️Authorize agains Github"
gh auth login

echo "➡️Clone repositories ..."
clone_repositories "${REPOS[@]}"
popd
