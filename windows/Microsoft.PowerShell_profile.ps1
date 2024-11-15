Import-Module -Name Terminal-Icons
Set-Alias code code-insiders
Set-Alias rdev launch_cargo_watch

Function launch_cargo_watch { cargo watch -c -w src -x test }

oh-my-posh --init --shell pwsh --config ".\nu4a.omp.json" | Invoke-Expression

