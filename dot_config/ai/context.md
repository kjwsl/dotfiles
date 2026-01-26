# Claude Code Context

This file provides context about me and my preferences. Refer to this when making decisions.

## About Me

- **Name**: Ray
- **Location**: (update as needed)
- **Primary Languages**: (update: e.g., Korean, English)
- **Learning**: (update: languages, skills you're learning)

## Technical Environment

- **OS**: WSL2 on Windows, also use Windows directly
- **Shell**: Nushell, Bash
- **Terminal**: Wezterm + Zellij
- **Editor**: Neovim
- **Version Control**: jj (Jujutsu) preferred, Git as fallback
- **Package Management**: Nix/home-manager (Unix), Winget (Windows)

## Preferences

### Communication Style
- Be concise and direct
- Show multiple options with comparisons when decisions are needed
- Ask clarifying questions before making assumptions
- Don't over-explain obvious things

### Code Style
- Prefer simple, readable code over clever code
- Use type hints in Python
- Follow existing project conventions
- Write meaningful commit messages

### Decision Making
When I ask for something that has multiple approaches:
1. Present 2-4 options (always show options, never just pick one)
2. For each option, provide a detailed comparison:
   - Pros and cons
   - When to use it
   - Trade-offs
   - Complexity/effort level
3. Give a recommendation with reasoning
4. Let me choose - don't proceed without my input on decisions

### Commit Style
- Prefer jj (Jujutsu) if available, fall back to git
- Split changes into logical, atomic commits
- Each commit should be self-contained and reviewable
- Write meaningful messages explaining WHY, not just WHAT

### Tools I Use
- AI: Claude Code CLI, Gemini
- Dotfiles: chezmoi
- Notes: Obsidian (this vault)
- Tasks: Obsidian Tasks + Microsoft To Do
- Notifications: ntfy.sh
- Search: ripgrep, fzf

## Current Projects/Focus

<!-- Update this section regularly -->
-

## Things to Remember
- Lesson: Prefer global configuration files (like ~/.justfile) over multiple bin wrappers.
- Meta: When I learn a user preference or correction, I must record it in context.md to avoid repeating the mistake.
- If you can infer something about my info, preferences, or environment, add it to `~/.config/ai/pending.md` for me to review later. Do not add it directly to this file.

<!-- Add persistent context here -->
-

---

*Last verified: 2026-01-26*
*Run `just verify-context` to be prompted about outdated info*

## Gemini Added Memories
- I prefer Rust-style documentation comments (///) for all C and C++ code.
- I prefer to use jj (Jujutsu) version control system over git when jj is available in the environment.
- I prefer you to explicitly state when you are unsure about an answer or if a piece of information might be hallucinated, rather than guessing.
- I prefer you to ask clarifying questions if a request is ambiguous or if you need more context, rather than making assumptions.
- When asked to write in a "more human" way, avoid using em-dashes.
- I use chezmoi to manage my dotfiles.
