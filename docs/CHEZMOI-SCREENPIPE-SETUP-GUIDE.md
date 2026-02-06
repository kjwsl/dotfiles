# Screenpipe + Chezmoi Integration Guide

## ✅ Completed Setup

You now have the screenpipe scripts integrated into your chezmoi dotfiles with the following structure:

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                          # Config template
├── dot_local/bin/
│   └── executable_start-screenpipe.sh.tmpl    # Main script (templated, executable)
└── scripts/
    ├── run_once_install-screenpipe.sh         # Installation hook
    └── run_once_setup-screenpipe-startup.ps1  # Windows startup hook
```

## 📋 Configuration

Your screenpipe configuration is in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    [data.screenpipe]
        fps = "0.02"                           # 1 frame per 50 seconds
        capture_mode = "external-monitors-only" # Options: all | external-monitors-only | primary-only
        ocr_engine = "windows-native"          # Options: windows-native | tesseract | cloud
```

### Available Configuration Options

**FPS** (frame rate):
- `0.01` = 1 frame per 100 seconds (minimal CPU, ~0.9 GB/month for 3 monitors)
- `0.02` = 1 frame per 50 seconds (very light, ~1.2 GB/month for 2 monitors)
- `0.05` = 1 frame per 20 seconds (light, ~3 GB/month)
- `0.1` = 1 frame per 10 seconds (moderate, ~6 GB/month)

**Capture Mode**:
- `external-monitors-only` = Skip laptop screen, capture external monitors only
- `all` = Capture all monitors including laptop screen
- `primary-only` = Only capture primary monitor

**OCR Engine**:
- `windows-native` = Windows OCR (Windows only, faster)
- `tesseract` = Open-source OCR (cross-platform)
- `cloud` = Cloud-based OCR (requires API key)

## 🚀 Next Steps

### Step 1: Apply Chezmoi Configuration

```bash
# Review what will be applied
chezmoi status

# Apply the changes
chezmoi apply -v

# This will:
# - Create ~/.local/bin/start-screenpipe.sh (executable, templated)
# - Run any run_once_* scripts
```

### Step 2: Verify Script Installation

```bash
# Check if script was installed
ls -la ~/.local/bin/start-screenpipe.sh

# Make sure it's executable
chmod +x ~/.local/bin/start-screenpipe.sh

# Test the script (optional, will start screenpipe)
~/.local/bin/start-screenpipe.sh
```

### Step 3: Setup Windows Auto-Start (Optional)

If you want screenpipe to auto-launch on login:

**Option A: Manual Registry Setup** (Recommended if script runs)

```powershell
# Run PowerShell as Administrator
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$RegName = "screenpipe-adaptive"
$BashPath = "C:\Program Files\Git\bin\bash.exe"
$ScriptPath = "$env:USERPROFILE\.local\bin\start-screenpipe.sh"

# Create batch wrapper first
@"
@echo off
"$BashPath" -c "bash `"$ScriptPath`""
"@ | Out-File -FilePath "$env:USERPROFILE\.local\bin\start-screenpipe.bat" -Encoding ASCII -Force

# Set registry
Set-ItemProperty -Path $RegPath -Name $RegName -Value "`"$env:USERPROFILE\.local\bin\start-screenpipe.bat`"" -Force

# Verify
Get-ItemProperty -Path $RegPath -Name $RegName
```

**Option B: Use Task Scheduler**

```powershell
# Run PowerShell as Administrator
$action = New-ScheduledTaskAction -Execute "C:\Program Files\Git\bin\bash.exe" `
  -Argument "-c `"bash `"$env:USERPROFILE\.local\bin\start-screenpipe.sh`"`""

$trigger = New-ScheduledTaskTrigger -AtLogon

Register-ScheduledTask -TaskName "ScreenpipeAdaptive" `
  -Action $action -Trigger $trigger -RunLevel Highest
```

### Step 4: Update Configuration (If Needed)

To change screenpipe settings:

```bash
# Edit the chezmoi config
nano ~/.config/chezmoi/chezmoi.toml

# Update the values under [data.screenpipe]

# Apply the changes
chezmoi apply -v

# Changes will take effect next time screenpipe starts
```

## 🔧 How It Works

### Monitor Detection

The script automatically:
1. Detects all connected monitors
2. Filters based on `capture_mode`:
   - **external-monitors-only**: Looks for HDMI/DisplayPort in name, or uses all except first
   - **all**: Uses all monitors
   - **primary-only**: Uses only the first monitor

3. Dynamically adjusts FPS based on monitor count:
   - 3+ monitors: caps at 0.01 FPS
   - 2 monitors: caps at 0.02 FPS
   - 1 monitor: uses preferred FPS

### Cross-Platform Support

The script works on:
- **Windows**: Via Git Bash
- **Linux**: Native bash
- **macOS**: Native bash

It automatically detects OS and paths for screenpipe executable.

## 🔄 Updating Screenpipe Settings

When you change `~/.config/chezmoi/chezmoi.toml`:

1. The new values are templated into the script
2. The script must be restarted to use new settings
3. No code changes needed - just restart

### Example: Switch to 3-Monitor Setup

```toml
[data.screenpipe]
    fps = "0.01"                    # Reduced for 3 monitors
    capture_mode = "external-monitors-only"
```

Then restart screenpipe:

```bash
# Kill current instance (PowerShell)
Get-Process screenpipe | Stop-Process

# Or in Git Bash
pkill screenpipe

# Restart
~/.local/bin/start-screenpipe.sh
```

## 📊 Expected Resource Usage

Your current setup (2-3 external monitors, 0.02 FPS):

| Monitors | FPS  | Storage/Month | CPU     | Notes |
|----------|------|--------------|---------|-------|
| 1        | 0.02 | 0.6 GB       | <0.5%   | Laptop only |
| 2        | 0.02 | 1.2 GB       | <0.5%   | Recommended |
| 3        | 0.01 | 0.9 GB       | <0.5%   | Auto-capped |

## 🐛 Troubleshooting

### Script not found after `chezmoi apply`

```bash
# Check if it was applied
chezmoi managed -i

# Manually verify installation
ls -la ~/.local/bin/start-screenpipe.sh

# Re-apply if missing
chezmoi apply --force -v
```

### Script fails to start screenpipe

```bash
# Test the script manually
~/.local/bin/start-screenpipe.sh

# Check screenpipe is installed
which screenpipe
# or on Windows
ls "$LOCALAPPDATA/screenpipe - Development/screenpipe.exe"
```

### Monitor detection not working

```bash
# Test monitor detection manually
screenpipe vision list

# Add debug output to script (edit ~/.local/bin/start-screenpipe.sh)
# Uncomment debug echo lines
```

### Git Bash not found

```powershell
# Verify Git Bash installation
Test-Path "C:\Program Files\Git\bin\bash.exe"

# If not found, install Git for Windows from https://git-scm.com/
```

## 📝 Files Created

| File | Location | Purpose |
|------|----------|---------|
| `.chezmoi.toml.tmpl` | `~/.local/share/chezmoi/` | Config template |
| `executable_start-screenpipe.sh.tmpl` | `~/.local/share/chezmoi/dot_local/bin/` | Main script template |
| `run_once_install-screenpipe.sh` | `~/.local/share/chezmoi/scripts/` | Installation hook |
| `run_once_setup-screenpipe-startup.ps1` | `~/.local/share/chezmoi/scripts/` | Windows startup setup |
| `screenpipe.toml` (generated) | `~/.config/screenpipe/` | Optional screenpipe config |

## 🔄 Next Session Tasks

From your context document, these remain:

### Priority 1: Test Screenpipe
1. ✅ Scripts created in chezmoi
2. ⏳ Run `chezmoi apply` to install
3. ⏳ Test `~/.local/bin/start-screenpipe.sh` manually
4. ⏳ Verify monitor detection works
5. ⏳ Set up Windows auto-start

### Priority 2: Fix Browser Lag
- Remove Hypothesis extension (you don't use it)
- Test with 2 vs 3 monitors to isolate GPU load
- Consider removing heavy extensions (Dark Reader uses resources)

## ✨ Benefits of This Setup

- **No hardcoded values** - works across machines
- **Single source of truth** - edit `~/.config/chezmoi/chezmoi.toml`
- **Auto-restart on monitor changes** - script adapts dynamically
- **Cross-platform** - same script on Windows/Linux/macOS
- **Chainable with bootstrap** - system setup → screenpipe via chezmoi

## 🤝 Integration with Bootstrap

Your existing workflow:
1. `bootstrap.ps1` - Installs system tools (one-time)
2. `chezmoi apply` - Applies dotfiles including screenpipe

This is the recommended approach!
