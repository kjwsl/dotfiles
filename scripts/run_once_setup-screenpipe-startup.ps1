# ===========================================================================
# Windows Startup Configuration for Screenpipe
# ===========================================================================
# This script runs once to set up Windows startup for screenpipe
# Run via chezmoi with: scripts/run_once_setup-screenpipe-startup.ps1
# ===========================================================================

$ScriptPath = "$env:USERPROFILE\.local\bin\start-screenpipe.sh"
$BatWrapper = "$env:USERPROFILE\.local\bin\start-screenpipe.bat"

# Verify the bash script exists
if (-not (Test-Path $ScriptPath)) {
    Write-Host "ERROR: $ScriptPath not found" -ForegroundColor Red
    exit 1
}

Write-Host "[setup-screenpipe] Found screenpipe bash script at: $ScriptPath" -ForegroundColor Green

# Find Git Bash
$GitBashPaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe"
)

$BashPath = $null
foreach ($path in $GitBashPaths) {
    if (Test-Path $path) {
        $BashPath = $path
        break
    }
}

if (-not $BashPath) {
    Write-Host "ERROR: Git Bash not found. Please install Git for Windows." -ForegroundColor Red
    exit 1
}

Write-Host "[setup-screenpipe] Found Git Bash at: $BashPath" -ForegroundColor Green

# Create batch wrapper if it doesn't exist
if (-not (Test-Path $BatWrapper)) {
    Write-Host "[setup-screenpipe] Creating batch wrapper..." -ForegroundColor Cyan

    $BatContent = @"
@echo off
REM Wrapper to call bash script from Windows startup
"$BashPath" -c "bash `"$ScriptPath`""
"@

    $BatContent | Out-File -FilePath $BatWrapper -Encoding ASCII -Force
    Write-Host "[setup-screenpipe] Batch wrapper created at: $BatWrapper" -ForegroundColor Green
}

# Setup Windows Registry for auto-start
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$RegName = "screenpipe-adaptive"
$RegValue = "`"$BatWrapper`""

Write-Host "[setup-screenpipe] Setting up Windows startup registry..." -ForegroundColor Cyan

try {
    # Check if key already exists
    $existing = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "[setup-screenpipe] Updating existing registry entry..." -ForegroundColor Yellow
    } else {
        Write-Host "[setup-screenpipe] Creating new registry entry..." -ForegroundColor Yellow
    }

    # Set registry value
    Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Force

    # Verify it was set
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
Write-Host "To manually start now, run: & `"$ScriptPath`"" -ForegroundColor Cyan
