#Requires -RunAsAdministrator

# Exit on error
$ErrorActionPreference = "Stop"

# Colors for output
$RED = [System.ConsoleColor]::Red
$GREEN = [System.ConsoleColor]::Green
$YELLOW = [System.ConsoleColor]::Yellow

# Logging functions
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [System.ConsoleColor]$Color = $GREEN
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage -ForegroundColor $Color
}

# Check if running on Windows
function Test-IsWindows {
    return $env:OS -eq "Windows_NT"
}

# Check if a command exists
function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

# Install Chocolatey if not present
function Install-Chocolatey {
    if (-not (Test-CommandExists "choco")) {
        Write-Log "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    } else {
        Write-Log "Chocolatey already installed"
        Write-Log "Updating Chocolatey..."
        choco upgrade chocolatey -y
    }
}

# Install Fish shell
function Install-Fish {
    if (-not (Test-CommandExists "fish")) {
        Write-Log "Installing Fish shell..."
        choco install fish -y
    } else {
        Write-Log "Fish shell already installed"
        Write-Log "Updating Fish shell..."
        choco upgrade fish -y
    }
}

# Install Ansible
function Install-Ansible {
    if (-not (Test-CommandExists "ansible")) {
        Write-Log "Installing Ansible..."
        choco install ansible -y
    } else {
        Write-Log "Ansible already installed"
        Write-Log "Updating Ansible..."
        choco upgrade ansible -y
    }
}

# Install Fisher and plugins
function Setup-Fish {
    Write-Log "Setting up Fish shell..."
    
    # Create Fish config directory if it doesn't exist
    $fishConfigDir = "$env:APPDATA\fish"
    if (-not (Test-Path $fishConfigDir)) {
        New-Item -ItemType Directory -Path $fishConfigDir -Force | Out-Null
    }

    # Install Fisher
    $fisherPath = "$fishConfigDir\functions\fisher.fish"
    if (-not (Test-Path $fisherPath)) {
        Write-Log "Installing Fisher..."
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" -OutFile $fisherPath
    } else {
        Write-Log "Fisher already installed"
    }

    # Install plugins
    Write-Log "Installing/updating Fish plugins..."
    $plugins = @(
        "jorgebucaran/fisher",
        "jethrokuan/z",
        "patrickf1/fzf.fish",
        "jorgebucaran/autopair.fish"
    )
    
    foreach ($plugin in $plugins) {
        $installedPlugins = fish -c "fisher list" 2>$null
        if ($installedPlugins -notcontains $plugin) {
            Write-Log "Installing plugin: $plugin"
            fish -c "fisher install $plugin"
        } else {
            Write-Log "Plugin already installed: $plugin"
        }
    }
}

# Run Ansible playbook
function Run-Ansible {
    Write-Log "Running Ansible playbook..."
    if (Test-Path "ansible") {
        Push-Location ansible
        ansible-playbook playbooks/dotfiles.yml
        Pop-Location
    } else {
        Write-Log "Ansible directory not found. Skipping Ansible setup." -Color $YELLOW
    }
}

# Main installation process
try {
    Write-Log "Starting installation process..."

    if (Test-IsWindows) {
        Install-Chocolatey
    }

    Install-Fish
    Install-Ansible
    Setup-Fish
    Run-Ansible

    Write-Log "Installation completed successfully!"
    Write-Log "Please restart your shell to apply all changes"
}
catch {
    Write-Log "An error occurred during installation:" -Color $RED
    Write-Log $_.Exception.Message -Color $RED
    Write-Log "Stack trace:" -Color $RED
    Write-Log $_.ScriptStackTrace -Color $RED
    exit 1
}