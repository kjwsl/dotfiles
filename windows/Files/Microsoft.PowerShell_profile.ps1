# oh-my-posh init pwsh --config "C:\Program Files (x86)\oh-my-posh\themes\kushal.omp.json" | Invoke-Expression
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

if (Test-Path "C:\Program Files\Neovim\bin\nvim.exe") {
    $nvimPath = "C:\Program Files\Neovim\bin\nvim.exe"
} elseif (Test-Path "C:\tools\neovim\nvim-win64\bin\nvim.exe") {
    $nvimPath = "C:\tools\neovim\nvim-win64\bin\nvim.exe"
}

if ($nvimPath) {
    function Open-NvimCurrentDir {
        & $nvimPath .
    }
    Set-Alias -Name v -Value $nvimPath
    Set-Alias -Name v. -Value Open-NvimCurrentDir
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    Set-Alias -Name g -Value git
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Invoke-Expression
}
