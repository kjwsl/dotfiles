# Dotfiles Documentation

This directory contains guides and reference documentation for managing your dotfiles with chezmoi.

## 📚 Documentation Structure

### Screenpipe Integration

- **[CHEZMOI-SCREENPIPE-QUICKSTART.md](./CHEZMOI-SCREENPIPE-QUICKSTART.md)** - Quick start guide
  - TL;DR version with essential commands
  - Quick verification steps
  - Start here if you just want to get it running

- **[CHEZMOI-SCREENPIPE-SETUP-GUIDE.md](./CHEZMOI-SCREENPIPE-SETUP-GUIDE.md)** - Complete setup guide
  - Full configuration options explained
  - Multiple auto-start methods
  - Resource usage estimates
  - Troubleshooting section

- **[CHEZMOI-SCREENPIPE-SUMMARY.md](./CHEZMOI-SCREENPIPE-SUMMARY.md)** - What was implemented
  - Design decisions and rationale
  - Feature overview
  - Completion status checklist

### General Dotfiles

- **[SECRET_MANAGEMENT.md](./SECRET_MANAGEMENT.md)** - Managing secrets with chezmoi
  - How to encrypt/decrypt sensitive files
  - Age key setup
  - SOPS configuration

## 🎯 Quick Links

### Get Started
```bash
# View the quickstart guide
cat ~/.local/share/chezmoi/docs/CHEZMOI-SCREENPIPE-QUICKSTART.md

# Or navigate to the directory
cd ~/.local/share/chezmoi/docs/
ls -la
```

### Common Tasks

```bash
# Apply dotfiles with screenpipe
chezmoi apply -v

# Test screenpipe script
~/.local/bin/start-screenpipe.sh

# View all available documentation
ls -la ~/.local/share/chezmoi/docs/
```

## 📝 Notes

- This `docs/` directory is **not synced** to your home directory
- Documentation is stored in the chezmoi source repository for reference
- Guides are for humans, not processed by chezmoi

## 🔄 Adding New Guides

When adding new documentation:

1. Create the `.md` file in this directory
2. Add a section above under the relevant category
3. Update this README with a brief description
4. No need to add to `.chezmoiignore` - it's already there

## 📖 Viewing Guides

From anywhere on your system:
```bash
# Open in your editor
nano ~/.local/share/chezmoi/docs/CHEZMOI-SCREENPIPE-QUICKSTART.md

# Or view in terminal
cat ~/.local/share/chezmoi/docs/CHEZMOI-SCREENPIPE-SETUP-GUIDE.md | less

# Or just browse the directory
cd ~/.local/share/chezmoi && ls -la docs/
```

---

Last updated: 2025-02-04
