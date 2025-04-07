Import-Module -Name Terminal-Icons

Invoke-Expression (&starship init powershell)

Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

Set-Alias code "code-insiders"
Set-Alias c "clear"
Set-Alias e "exit"
Set-Alias y "yazi"
Set-Alias ed "nvim"

function Invoke-Eza { eza --long --color=always --icons=always --no-user }
Set-Alias ll Invoke-Eza
function Invoke-GitStatus { git status -s }
Set-Alias gs Invoke-GitStatus
function Invoke-GitAdd { git add . }
Set-Alias ga Invoke-GitAdd
function Invoke-GitLog { git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit }
Set-Alias glog Invoke-GitLog
function Invoke-GitDiff { git diff }
Set-Alias gd Invoke-GitDiff
function Invoke-GitPush { git push }
Set-Alias gph Invoke-GitPush
function Invoke-GitPull { git pull }
Set-Alias gpl Invoke-GitPull
function Invoke-GitCommit { git commit -m  }
Set-Alias gct Invoke-GitCommit
function Open-Folder-With-Fzf { z (fd --hidden --type=d --strip-cwd-prefix -E .git -E bin -E obj | fzf --preview 'eza --tree --icons=always --color=always {}') }
Set-Alias ofo Open-Folder-With-Fzf
function Open-File-With-Fzf ($pattern) { 
    $tmp = (rg --hidden --color=always --line-number --no-heading --smart-case ($pattern) | fzf --ansi --delimiter : --preview 'bat --color=always {1} --highlight-line {2} --line-range {2}:+20')
    $parts = $tmp -split ":"
    ed $($parts[0]) +$($parts[1])
}
Set-Alias ofi Open-File-With-Fzf

Invoke-Expression (& { (zoxide init powershell | Out-String) })