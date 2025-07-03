export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:/home/koepalex/.cargo/bin


create_worktree() {
  eval "git worktree add -b $1 ./worktrees/$1"
}

delete_worktree() {
  eval "git worktree remove $1"
}

switch_branch() {
  eval "git switch $1"
}

add_tag() {
  eval "git tag $1"
}

delete_tag() {
  eval "git tag -d $1"
}

commit() {
  eval "git commit -m $1"
}

open_folder() { 
    z `(fd --hidden --type=d --strip-cwd-prefix -E .git -E bin -E obj | fzf --preview "eza --tree --all --color=always --icons=always {}")`
}

open_file() { 
    tmp=`(rg --hidden --color=always --line-number --no-heading --smart-case "$1" | fzf --ansi --delimiter : --preview "batcat {1} -H {2} --color=always --line-range {2}:+20")`
    nvim `echo $tmp | cut -d ":" -f 1` +`echo $tmp | cut -d ":" -f 2`
}

open_all_files() {
    nvim -p $(rg --files-with-matches $1)
}

alias z=zoxide
alias c=clear
alias ed=nvim
alias y=yazi
alias gpl="git pull"
alias gph="git push"
alias gd="git diff"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gs="git status -s"
alias gwl="git worktree list"
alias gwa=create_worktree
alias gwd=delete_worktree
alias gsb=switch_branch
alias ga="git add ."
alias gtl="git tag -l"
alias gta=add_tag
alias gtd=delete_tag
alias gc=commit
alias ll="eza --long --color=always --icons=always --no-user"
alias ofo=open_folder
alias ofi=open_file
alias oaf=open_all_files
alias bat=batcat
alias fd=fdfind
alias lg=lazygit

eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

export CARAPACE_BRIDGES='zsh'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

alias claude="/home/koepalex/.claude/local/claude"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
