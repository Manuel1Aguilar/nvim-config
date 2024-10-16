# dev_win.ps1

# Define the Neovim configuration path for Windows
$NvimConfigPath = "$env:LOCALAPPDATA\nvim"

# Check if the Neovim configuration directory exists and remove it
if (Test-Path -Path $NvimConfigPath) {
    Remove-Item -Recurse -Force $NvimConfigPath
}

# Create a symbolic link to the current directory
New-Item -ItemType SymbolicLink -Path $NvimConfigPath -Target (Get-Location)

Write-Output "Symlink created for Neovim configuration at $NvimConfigPath"

