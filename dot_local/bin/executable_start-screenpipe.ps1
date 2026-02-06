# ===========================================================================
# SCREENPIPE EVENT-DRIVEN CONFIGURATION (Windows PowerShell)
# ===========================================================================
# Automatically detects and selects monitors based on your preferences
# Restarts screenpipe when monitors change (sleep/wake, hot-plug)
# ===========================================================================

$ErrorActionPreference = "Stop"

# ==================== CONFIGURATION ====================
$PreferredFPS = 0.02
$CaptureMode = "external-monitors-only"  # all | external-monitors-only | primary-only

# ==================== FIND SCREENPIPE ====================
$ScreenpipePath = "$env:LOCALAPPDATA\screenpipe - Development\screenpipe.exe"

if (-not (Test-Path $ScreenpipePath)) {
    Write-Host "[screenpipe] ERROR: screenpipe not found at $ScreenpipePath" -ForegroundColor Red
    exit 1
}

# ==================== STATE ====================
$script:ScreenpipeProcess = $null
$script:LastMonitorIds = @()

# ==================== FUNCTIONS ====================

function Get-ExternalMonitors {
    $MonitorOutput = & $ScreenpipePath vision list 2>&1
    $Monitors = $MonitorOutput | Where-Object { $_ -match '^\s*\d+\.' }

    if (-not $Monitors -or $Monitors.Count -eq 0) {
        return @()
    }

    $SelectedMonitors = @()

    switch ($CaptureMode) {
        "all" {
            $SelectedMonitors = $Monitors
        }
        "external-monitors-only" {
            # Filter for HDMI/DisplayPort/etc in name
            $SelectedMonitors = $Monitors | Where-Object { $_ -match '(HDMI|DisplayPort|DP|DVI)' }

            # Fallback: skip first monitor (usually laptop screen)
            if (-not $SelectedMonitors -and $Monitors.Count -gt 1) {
                $SelectedMonitors = $Monitors | Select-Object -Skip 1
            }
        }
        "primary-only" {
            $SelectedMonitors = @($Monitors | Select-Object -First 1)
        }
    }

    # Fallback to all if no matches
    if (-not $SelectedMonitors -or $SelectedMonitors.Count -eq 0) {
        $SelectedMonitors = $Monitors
    }

    return $SelectedMonitors
}

function Get-MonitorIds {
    param([array]$Monitors)

    $Ids = @()
    foreach ($line in $Monitors) {
        if ($line -match '^\s*(\d+)\.') {
            $Ids += $Matches[1]
        }
    }
    return $Ids
}

function Start-ScreenpipeWithMonitors {
    Write-Host ""
    Write-Host "[screenpipe] ========================================" -ForegroundColor Cyan
    Write-Host "[screenpipe] Starting monitor detection..." -ForegroundColor Cyan

    # Stop existing process if running
    if ($script:ScreenpipeProcess -and -not $script:ScreenpipeProcess.HasExited) {
        Write-Host "[screenpipe] Stopping existing screenpipe process (PID: $($script:ScreenpipeProcess.Id))..." -ForegroundColor Yellow
        try {
            Stop-Process -Id $script:ScreenpipeProcess.Id -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
        } catch {
            Write-Host "[screenpipe] Process already stopped" -ForegroundColor DarkGray
        }
    }

    # Detect monitors
    $Monitors = Get-ExternalMonitors

    if (-not $Monitors -or $Monitors.Count -eq 0) {
        Write-Host "[screenpipe] WARNING: No monitors detected, will retry on next event" -ForegroundColor Yellow
        return
    }

    Write-Host "[screenpipe] Selected monitors:" -ForegroundColor Cyan
    $Monitors | ForEach-Object { Write-Host "  $_" }

    # Extract IDs
    $MonitorIds = Get-MonitorIds -Monitors $Monitors
    $script:LastMonitorIds = $MonitorIds

    # Build monitor args
    $MonitorArgs = @()
    foreach ($id in $MonitorIds) {
        $MonitorArgs += "--monitor-id"
        $MonitorArgs += $id
    }

    # Calculate FPS
    $MonitorCount = $MonitorIds.Count
    $AdjustedFPS = $PreferredFPS

    if ($MonitorCount -ge 3) {
        $AdjustedFPS = 0.01
    } elseif ($MonitorCount -eq 2) {
        $AdjustedFPS = 0.02
    }

    Write-Host "[screenpipe] Monitor count: $MonitorCount, FPS: $AdjustedFPS" -ForegroundColor Cyan

    # Setup data directory
    $DataDir = "$env:LOCALAPPDATA\.screenpipe"
    if (-not (Test-Path $DataDir)) {
        New-Item -ItemType Directory -Path $DataDir -Force | Out-Null
    }

    # Build full arguments
    $AllArgs = @(
        "--fps", $AdjustedFPS,
        "--disable-audio",
        "--video-chunk-duration", "300",
        "--ocr-engine", "windows-native",
        "--disable-telemetry",
        "--data-dir", $DataDir
    ) + $MonitorArgs

    Write-Host "[screenpipe] Command: $ScreenpipePath $($AllArgs -join ' ')" -ForegroundColor DarkGray
    Write-Host "[screenpipe] Starting screenpipe..." -ForegroundColor Green

    # Start as background process
    $script:ScreenpipeProcess = Start-Process -FilePath $ScreenpipePath -ArgumentList $AllArgs -PassThru -WindowStyle Hidden

    Write-Host "[screenpipe] Started with PID: $($script:ScreenpipeProcess.Id)" -ForegroundColor Green
    Write-Host "[screenpipe] ========================================" -ForegroundColor Cyan
}

# ==================== EVENT REGISTRATION ====================

Write-Host "[screenpipe] Registering event listeners..." -ForegroundColor Cyan

# Clean up any existing subscriptions from previous runs
Get-EventSubscriber -SourceIdentifier "ScreenpipeSystemWake" -ErrorAction SilentlyContinue | Unregister-Event -ErrorAction SilentlyContinue
Get-EventSubscriber -SourceIdentifier "ScreenpipeDeviceChange" -ErrorAction SilentlyContinue | Unregister-Event -ErrorAction SilentlyContinue

# Define action scriptblocks (must be defined separately to avoid parsing issues)
$WakeAction = {
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host ""
    Write-Host "[$timestamp] Display change detected (source: power) (system wake)" -ForegroundColor Yellow
    Write-Host "[screenpipe] Waiting 3 seconds for display drivers..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 3
    Start-ScreenpipeWithMonitors
}

$DeviceAction = {
    $eventType = if ($Event.SourceEventArgs.NewEvent.EventType -eq 2) { "connected" } else { "disconnected" }
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host ""
    Write-Host "[$timestamp] Display change detected (source: device) (device $eventType)" -ForegroundColor Yellow
    Write-Host "[screenpipe] Waiting 3 seconds for display drivers..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 3
    Start-ScreenpipeWithMonitors
}

# Detect PowerShell version and use appropriate event registration
$useCim = $PSVersionTable.PSVersion.Major -ge 6

# System resume from sleep (EventType 7 = Resume)
try {
    if ($useCim) {
        Register-CimIndicationEvent -Query "SELECT * FROM Win32_PowerManagementEvent WHERE EventType = 7" -SourceIdentifier "ScreenpipeSystemWake" -Action $WakeAction | Out-Null
    } else {
        Register-WmiEvent -Query "SELECT * FROM Win32_PowerManagementEvent WHERE EventType = 7" -SourceIdentifier "ScreenpipeSystemWake" -Action $WakeAction | Out-Null
    }
    Write-Host "[screenpipe] + Registered: System wake event listener" -ForegroundColor Green
} catch {
    Write-Host "[screenpipe] WARNING: Could not register power event: $_" -ForegroundColor Yellow
}

# Device connect/disconnect (EventType 2 = arrival, 3 = removal)
try {
    if ($useCim) {
        Register-CimIndicationEvent -Query "SELECT * FROM Win32_DeviceChangeEvent WHERE EventType = 2 OR EventType = 3" -SourceIdentifier "ScreenpipeDeviceChange" -Action $DeviceAction | Out-Null
    } else {
        Register-WmiEvent -Query "SELECT * FROM Win32_DeviceChangeEvent WHERE EventType = 2 OR EventType = 3" -SourceIdentifier "ScreenpipeDeviceChange" -Action $DeviceAction | Out-Null
    }
    Write-Host "[screenpipe] + Registered: Device change event listener" -ForegroundColor Green
} catch {
    Write-Host "[screenpipe] WARNING: Could not register device event: $_" -ForegroundColor Yellow
}

# ==================== INITIAL START ====================

Write-Host "[screenpipe] Found: $ScreenpipePath" -ForegroundColor Green
Start-ScreenpipeWithMonitors

# ==================== KEEP ALIVE ====================

Write-Host ""
Write-Host "[screenpipe] Event listener active. Monitoring for display changes..." -ForegroundColor Cyan
Write-Host "[screenpipe] Press Ctrl+C to stop." -ForegroundColor DarkGray
Write-Host ""

# Keep script running to receive events
try {
    while ($true) {
        # Check if screenpipe is still running, restart if crashed
        if ($script:ScreenpipeProcess -and $script:ScreenpipeProcess.HasExited) {
            Write-Host "[screenpipe] Process exited unexpectedly, restarting..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            Start-ScreenpipeWithMonitors
        }
        Start-Sleep -Seconds 30
    }
} finally {
    # Cleanup on exit
    Write-Host "[screenpipe] Shutting down..." -ForegroundColor Yellow

    Get-EventSubscriber -SourceIdentifier "ScreenpipeSystemWake" -ErrorAction SilentlyContinue | Unregister-Event
    Get-EventSubscriber -SourceIdentifier "ScreenpipeDeviceChange" -ErrorAction SilentlyContinue | Unregister-Event

    if ($script:ScreenpipeProcess -and -not $script:ScreenpipeProcess.HasExited) {
        Stop-Process -Id $script:ScreenpipeProcess.Id -Force -ErrorAction SilentlyContinue
    }

    Write-Host "[screenpipe] Stopped." -ForegroundColor Green
}
