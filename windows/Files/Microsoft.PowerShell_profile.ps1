$moduleDir = Join-Path -Path $PSScriptRoot -ChildPath "modules"

# Check if the directory exists and is actually a container (folder)
if (Test-Path -Path $moduleDir -PathType Container) {
    Get-ChildItem -Path $moduleDir -File | ForEach-Object {
        . $_.FullName
    }
}

# Initialize mise (suppress chpwd warning on PS 5.1 - used by WSL done.fish plugin)
$env:MISE_PWSH_CHPWD_WARNING = "0"
if (Get-Command mise.exe -ErrorAction SilentlyContinue) {
    mise activate pwsh | Out-String | Invoke-Expression
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

$nvim = Get-Command nvim -ErrorAction SilentlyContinue

if ($nvim) {
    # $nvim.Source gives the absolute path to the executable found by gcm
    Set-Alias -Name v -Value $nvim.Source

    # Define the function dynamically using the found path
    function Open-NvimCurrentDir {
        & $nvim.Source .
    }
    Set-Alias -Name v. -Value Open-NvimCurrentDir
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    Set-Alias -Name g -Value git
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (zoxide init powershell | Out-String)
}

if (Test-Path ~/local.ps1) {
    . ~/local.ps1
}

if (Test-Path ~/work.ps1)
{
    . ~/work.ps1
}

