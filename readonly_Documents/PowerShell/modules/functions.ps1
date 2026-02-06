function which($name) {
    Get-Command $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path
}

function dirname($path) {
    Split-Path -Path $path -Parent
}
