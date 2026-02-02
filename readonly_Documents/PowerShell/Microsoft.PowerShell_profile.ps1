


if (Test-path "C:\Program Files\Neovim\bin\nvim.exe")
{
    $nvimPath = "C:\Program Files\Neovim\bin\nvim.exe"
} else
{
    $nvimPath = "C:\tools\neovim\nvim-win64\bin\nvim.exe"
}

function Open-NvimCurrentDir {
    & $nvimPath .
}

Set-Alias -Name v -Value $nvimPath
Set-Alias -Name v. -Value Open-NvimCurrentDir
Set-Alias -Name g -Value git


if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}


if (Test-Path ~/work.ps1)
{
    . ~/work.ps1
}


# Initialize mise
if (Get-Command mise.exe -ErrorAction SilentlyContinue) {
    mise activate pwsh | Out-String | Invoke-Expression
}


# Initialize starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
