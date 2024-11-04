# Assign variables
$GitHubProfile = "https://github.com/kjwsl"
$GitHubDestination = "$Home/Desktop/GitHub"
$Repo = "$GitHubProfile/pwsh_setup"
$FilesPath = "$Repo/raw/main/Files"


$Name = "Microsoft.PowerShell_profile.ps1"
$ProfileItem = @{
    Name = $Name
    Path = "$FilesPath/$Name"
    Dest = "$HOME/Documents/PowerShell/$Name"
}

$Name = ".wezterm.lua"
$WeztermItem = @{
    Name = $Name
    Path = "$FilesPath/$Name"
    Dest = "$HOME"
}

$RepoToGet = "obsidian-vault", @{Name = "nvim-config"; Path = "$env:LOCALAPPDATA/nvim"}

$ProgramgsToGet = "brave", "obsidian", "powershell-core", "neovim", "flow-launcher", "files", "obs-studio", "wezterm", "oh-my-posh", "mingw", "nerd-fonts-agave", "nerd-fonts-CascadiaCode", "ripgrep", "lazygit"
function Install-Chocolatey
{
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Programs
{
    # Install Programs using Chocolatey
    Write-Output "Installing Chocolatey..."
    Install-Chocolatey
    Write-Output "Successfully Installed Chocolatey!"
    Write-Output "Installing programs using Chocolatey..."
    choco install -y @ProgramgsToGet
    Write-Output "Successfully Installed programs using Chocolatey!"

}

function Setup-Git
{
    # if git is not installed, install git using chocolatey
    if (-not(Get-Command "git" -ErrorAction SilentlyContinue))
    {
        Write-Error "git is not installed."
        Write-Output "Installing git..."
        try
        {
            choco install -y git
        } catch
        {
            write-error "Failed to install git."
            exit 1
        }
    }
    Write-Output "Setting up Git..."

    # git config
    git config --global user.name "larpios"
    git config --global user.email "larpios@protonmail.com"

    # git clone 
    New-Item -ItemType Directory -Path $GitHubDestination | Out-Null
    foreach ($elem in $RepoToGet)
    {
        if ($elem.GetType().Name -eq "Hashtable")
        {
            git clone "$GitHubProfile/$( $elem.Name )" $elem.Path
        } else
        {
            git clone "$GitHubProfile/$elem" "$GitHubDestination/$elem"
        }
    }
    Write-Output "Successfully set up Git!"

}

# Make PowerShell Profile
New-Item $ProfileItem.Dest -Force
Invoke-WebRequest $ProfileItem.Path -OutFile $HOME/Desktop/$ProfileItem.Name | Copy-Item -Destination $ProfileItem.Dest -Force

Install-Programs

Setup-Git

# Wezterm Config
Invoke-WebRequest $WeztermItem.Path -OutFile $HOME/Desktop/$WeztermItem.Name | Copy-Item -Destination $WeztermItem.Dest -Force
Write-Output "Wezterm Config file is made"


Write-Output "Done!"









