$scriptDirectory = $PSScriptRoot
$dotfilesDirectory = Split-Path -Parent $scriptDirectory

$symlinkFiles = ".config"

$ProgramgsToGet = "brave", "obsidian", "powershell-core", "neovim", "flow-launcher", "wezterm", "oh-my-posh", "mingw", "nerd-fonts-agave", "nerd-fonts-CascadiaCode", "ripgrep", "lazygit", "python", "zoxide"

function Create-Symlink {
    param(
        [Parameter(Mandatory)]
        [string]$src,
        [Parameter(Mandatory)]
        [string]$dest,

        [Alias('T')]
        [string]$Type = "SymbolicLink",
        [Alias('F')]
        [switch]$Force
    )
    $params = @{
        Type = $Type
        Value = "$dotfilesDirectory/$src"
        Path = "$dest"
    }

    if ($Force) {
        $params.Add("Force", $true)
    }

    try {
        New-Item @params
    } catch {
        if (-not $Force) {
            Write-Error "Faile to create symbolic link. Use -Force to overwrite existing items."
        } else {
            throw
        }
    }
}

function Install-Chocolatey
{
    if (Get-Command "choco" -ErrorAction SilentlyContinue) {
        Write-Host "Chocolatey is already installed."
        return
    }
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Output "Successfully Installed Chocolatey!"
}

function Install-Programs
{
    # Install Programs using Chocolatey
    Install-Chocolatey
    Write-Output "Installing programs using Chocolatey..."
    choco install -y @ProgramgsToGet
    Write-Output "Successfully Installed programs using Chocolatey!"
}

function Setup-Env
{
    [System.Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$HOME\.config", "User")
}

# Make PowerShell Profile
# New-Item $PROFILE -Force
# Invoke-WebRequest $ProfileItem.Path -OutFile $HOME/Desktop/$ProfileItem.Name | Copy-Item -Destination $ProfileItem.Dest -Force

Setup-Env

Create-Symlink -src ".config" -dest "$HOME/.config"
Create-Symlink -src "windows/Files/.wslconfig" -dest "$HOME/.wslconfig" -Type HardLink -Force
Create-Symlink -src "windows/Files/Microsoft.PowerShell_profile.ps1" -dest $PROFILE -Force
Create-Symlink -src "notes" -dest "$HOME/notes" -Force
Create-Symlink -src ".gitconfig" -dest "$HOME/.gitconfig" -Force

Install-Programs


Write-Output "Done!"


