# Screenpipe + Chezmoi Integration - What's Been Done

**Session Date:** 2025-02-04
**Status:** ✅ Ready for Application

## 📦 Files Created in Chezmoi

### Configuration
- **`~/.local/share/chezmoi/.chezmoi.toml.tmpl`**
  - Template for screenpipe data configuration
  - Merged into `~/.config/chezmoi/chezmoi.toml`
  - Contains FPS, capture_mode, and OCR engine settings

### Main Script
- **`~/.local/share/chezmoi/dot_local/bin/executable_start-screenpipe.sh.tmpl`**
  - Cross-platform bash script (Windows/Linux/macOS)
  - Auto-detects monitors at runtime
  - Filters based on capture_mode (external-only, all, primary)
  - Dynamically adjusts FPS based on monitor count
  - Will be installed to `~/.local/bin/start-screenpipe.sh` when chezmoi applies

### Startup Hooks
- **`~/.local/share/chezmoi/scripts/run_once_install-screenpipe.sh`**
  - Installation hook (prepares ~/.local/bin directory)
  - Runs once per system

- **`~/.local/share/chezmoi/scripts/run_once_setup-screenpipe-startup.ps1`**
  - Optional Windows startup hook
  - Sets up Registry entry for auto-launch on login
  - Creates batch wrapper for Git Bash

## 🔧 Configuration Applied

**File:** `~/.config/chezmoi/chezmoi.toml`

```toml
[data]
    [data.screenpipe]
        fps = "0.02"
        capture_mode = "external-monitors-only"
        ocr_engine = "windows-native"
```

This is automatically used when templating scripts.

## ✨ Key Features Implemented

### 1. **Adaptive Monitor Detection**
   - No hardcoded monitor IDs
   - Automatically identifies external vs. internal displays
   - Fallback logic: Looks for HDMI/DisplayPort names or IDs > 200000

### 2. **Dynamic FPS Adjustment**
   - 3+ monitors: 0.01 FPS (1 frame/100s) - ~0.9 GB/month
   - 2 monitors: 0.02 FPS (1 frame/50s) - ~1.2 GB/month
   - 1 monitor: Uses preferred FPS

### 3. **Cross-Platform**
   - Single bash script works on Windows (Git Bash), Linux, macOS
   - Automatic OS detection
   - Platform-specific paths for screenpipe and data directory

### 4. **Chezmoi Integration**
   - Scripts are templated with configuration variables
   - Changes to config automatically reflected in new instances
   - Can be version controlled in git
   - Single source of truth for all machines

## 📋 What Needs to Happen Next

### User Responsibilities
1. **Review** the configuration in `~/.config/chezmoi/chezmoi.toml`
2. **Run** `chezmoi apply -v` to install the script
3. **Test** the script: `~/.local/bin/start-screenpipe.sh`
4. **Verify** that screenpipe starts and monitors are detected correctly
5. **Setup** Windows auto-start (optional, see QUICKSTART.md)

### What Chezmoi Will Do (on `chezmoi apply`)
1. Template the bash script with your configuration values
2. Create `~/.local/bin/start-screenpipe.sh` (executable)
3. Run any `run_once_*` scripts (installation hooks)
4. Update git repository with status (if configured)

## 🔄 Design Decisions

### Why Bash Instead of PowerShell?
- ✅ Works across all platforms (Windows, Linux, macOS)
- ✅ Single source of truth
- ✅ Native chezmoi support
- ✅ Can call Windows tools from Git Bash

### Why Keep bootstrap.ps1?
- System-level tools (winget, chocolatey) are Windows-native
- Only needed once per system
- Ensures Git Bash is available before bash scripts run

### Why Chezmoi for Dotfiles?
- Version control for configuration
- Templating support (OS detection, conditional logic)
- Cross-platform consistency
- Easy to share across machines

## 🎯 Current System Status

From your context document:
- **Hardware Bottleneck:** Intel Iris Xe iGPU (2GB shared RAM) with 3 monitors
- **Screenpipe Optimization:** Completed with adaptive scripts
- **Chezmoi Integration:** ✅ Completed this session
- **Browser Lag:** Still unresolved (GPU limitation, not screenpipe)

## 📝 Documentation Provided

1. **`CHEZMOI-SCREENPIPE-QUICKSTART.md`**
   - TL;DR version
   - Essential commands only
   - Quick verification steps

2. **`CHEZMOI-SCREENPIPE-SETUP-GUIDE.md`**
   - Complete setup guide
   - All configuration options explained
   - Troubleshooting section
   - Resource usage estimates

3. **`CHEZMOI-SCREENPIPE-SUMMARY.md`** (this file)
   - What was done
   - Design decisions
   - Next steps

## 🚀 Testing Checklist

```bash
# After chezmoi apply:
[ ] ~/.local/bin/start-screenpipe.sh exists
[ ] File is executable (chmod +x)
[ ] Script starts without errors
[ ] Monitors are detected (shows list)
[ ] Screenpipe starts with correct FPS
[ ] Correct monitors selected
[ ] No high CPU usage (should be <1%)

# Optional:
[ ] Auto-start via registry is set up
[ ] Script launches on login
[ ] Monitor detection works after monitor disconnect/reconnect
```

## 💡 Customization Examples

### Reduce FPS for 3 Monitors
```toml
[data.screenpipe]
    fps = "0.01"  # Already auto-capped for 3+ monitors
```

### Capture All Monitors
```toml
[data.screenpipe]
    capture_mode = "all"
```

### Use Tesseract OCR
```toml
[data.screenpipe]
    ocr_engine = "tesseract"
```

Then: `chezmoi apply -v`

## 🔗 Related Files (From Previous Session)

- `start-screenpipe-adaptive.ps1` - PowerShell version (reference only)
- `start-screenpipe.bat` - Batch wrapper (can be auto-generated)
- `laptop_performance_context.md` - Your full session context

## ⚠️ Known Issues

1. **Cargo environment warning** in Git Bash profile (non-blocking)
2. **Chezmoi apply can be slow** on large repositories (expected)
3. **Browser lag** is GPU-related, not fixable by screenpipe optimization alone

## 📞 Support Resources

- Chezmoi docs: https://www.chezmoi.io/
- Screenpipe docs: https://github.com/mediar-ai/screenpipe
- Git Bash: https://git-scm.com/

## ✅ Completion Status

| Task | Status | Notes |
|------|--------|-------|
| Create adaptive bash script | ✅ Done | `executable_start-screenpipe.sh.tmpl` |
| Create configuration template | ✅ Done | `.chezmoi.toml.tmpl` |
| Add to chezmoi dotfiles | ✅ Done | Ready in `~/.local/share/chezmoi/` |
| Create startup hooks | ✅ Done | Installation and Windows startup |
| Update user config | ✅ Done | `~/.config/chezmoi/chezmoi.toml` |
| Documentation | ✅ Done | 3 guides created |
| **Testing** | ⏳ Next | User needs to run `chezmoi apply` |
| **Auto-start setup** | ⏳ Next | Optional, detailed instructions provided |
| **Monitor GPU improvement** | ⏳ Future | Requires hardware upgrade or extension cleanup |

---

**Next Session:** Focus on testing the setup and optimizing browser performance (GPU bottleneck).
