
oh-my-posh init pwsh --config "C:\Program Files (x86)\oh-my-posh\themes\kushal.omp.json" | Invoke-Expression

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

Invoke-Expression (& { (zoxide init powershell | Out-String) })


if (Test-Path ~/work.ps1)
{
    . ~/work.ps1
}


# Initialize mise
if (Get-Command mise.exe -ErrorAction SilentlyContinue) {
    mise activate pwsh | Out-String | Invoke-Expression
}
