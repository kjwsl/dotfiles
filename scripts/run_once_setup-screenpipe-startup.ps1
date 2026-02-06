# ===========================================================================
# Windows Startup Configuration for Screenpipe (PowerShell Native)
# ===========================================================================
# This script runs once to set up Windows startup for screenpipe
# ===========================================================================

$ScriptPath = "$env:USERPROFILE\.local\bin\start-screenpipe.ps1"

# Verify the script exists
if (-not (Test-Path $ScriptPath)) {
    Write-Host "ERROR: $ScriptPath not found" -ForegroundColor Red
    exit 1
}

Write-Host "[setup-screenpipe] Found screenpipe script at: $ScriptPath" -ForegroundColor Green

# Setup Windows Registry for auto-start
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$RegName = "screenpipe-adaptive"
$RegValue = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""

Write-Host "[setup-screenpipe] Setting up Windows startup registry..." -ForegroundColor Cyan

try {
    $existing = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "[setup-screenpipe] Updating existing registry entry..." -ForegroundColor Yellow
    } else {
        Write-Host "[setup-screenpipe] Creating new registry entry..." -ForegroundColor Yellow
    }

    Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Force

    $verify = Get-ItemProperty -Path $RegPath -Name $RegName
    Write-Host "[setup-screenpipe] Registry entry set successfully:" -ForegroundColor Green
    Write-Host "  Path: $RegPath" -ForegroundColor Green
    Write-Host "  Name: $RegName" -ForegroundColor Green
    Write-Host "  Value: $($verify.$RegName)" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to set registry value: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n[setup-screenpipe] Setup complete!" -ForegroundColor Green
Write-Host "Screenpipe will auto-start on next login." -ForegroundColor Green
Write-Host "To manually start now, run:" -ForegroundColor Cyan
Write-Host "  & `"$ScriptPath`"" -ForegroundColor White
