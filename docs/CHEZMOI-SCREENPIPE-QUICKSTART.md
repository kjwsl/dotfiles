# Screenpipe + Chezmoi - Quick Start

## ⚡ TL;DR - Get It Running

### 1. Apply Chezmoi (Installs the Script)
```bash
chezmoi apply -v
```

### 2. Test the Script
```bash
~/.local/bin/start-screenpipe.sh
```

If it starts screenpipe and detects monitors, you're done! Press Ctrl+C to stop.

### 3. Setup Auto-Start (Optional)
```powershell
# PowerShell (Admin)
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $RegPath -Name "screenpipe-adaptive" `
  -Value "`"$env:USERPROFILE\.local\bin\start-screenpipe.bat`"" -Force
```

Or just run this .bat file once (then auto-start is set):
```batch
"%USERPROFILE%\.local\bin\start-screenpipe.bat"
```

## 🎛️ Customize Settings

Edit: `~/.config/chezmoi/chezmoi.toml`

```toml
[data.screenpipe]
    fps = "0.02"                            # 1 frame per 50 seconds
    capture_mode = "external-monitors-only" # all | external-monitors-only | primary-only
    ocr_engine = "windows-native"           # windows-native | tesseract
```

Then re-apply:
```bash
chezmoi apply -v
```

## 📁 Files in Chezmoi

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                          # Template
├── dot_local/bin/
│   └── executable_start-screenpipe.sh.tmpl    # Main script
└── scripts/
    ├── run_once_install-screenpipe.sh
    └── run_once_setup-screenpipe-startup.ps1
```

## 🔄 Common Commands

```bash
# Check what chezmoi will do
chezmoi status

# See all changes
chezmoi diff

# Install/update everything
chezmoi apply -v

# Just the screenpipe script
chezmoi apply -v dot_local/bin/executable_start-screenpipe.sh.tmpl

# View rendered script before applying
chezmoi cat dot_local/bin/executable_start-screenpipe.sh.tmpl | head -20
```

## ✅ Verification

```bash
# Script should exist and be executable
ls -la ~/.local/bin/start-screenpipe.sh
# Output: -rwxr-xr-x  1 ray  197121  ...

# Should show config values
chezmoi execute-template "{{ .screenpipe.fps }}"
# Output: 0.02
```

## 🐛 If It Doesn't Work

```bash
# 1. Check chezmoi status
chezmoi status

# 2. View what would be applied
chezmoi diff | head -50

# 3. Force re-apply
chezmoi apply --force -v dot_local/bin/executable_start-screenpipe.sh.tmpl

# 4. Test script directly
bash ~/.local/bin/start-screenpipe.sh -x  # -x for debug output
```

## 📊 Expected Behavior

1. Script auto-detects monitors
2. Shows list of available monitors
3. Filters based on capture_mode
4. Starts screenpipe with selected monitors
5. Adjusts FPS based on monitor count

Example output:
```
[screenpipe] Detected OS: windows
[screenpipe] Found screenpipe.exe
[screenpipe] Available monitors:
  0. "Unknown Monitor" (ID: 131073)
  1. "HDMI1" (ID: 920540)
  2. "DP1" (ID: 167774447)
[screenpipe] Mode: EXTERNAL monitors only
[screenpipe] Selected monitors:
  1. "HDMI1"
  2. "DP1"
[screenpipe] Monitor count: 2
[screenpipe] FPS: 0.02
[screenpipe] Starting screenpipe...
```

## 🎯 Next Session

- [ ] Run `chezmoi apply -v`
- [ ] Test `~/.local/bin/start-screenpipe.sh`
- [ ] Set up auto-start
- [ ] Monitor GPU/CPU usage
- [ ] Consider browser optimization if still lagging

See `CHEZMOI-SCREENPIPE-SETUP-GUIDE.md` for full details.
