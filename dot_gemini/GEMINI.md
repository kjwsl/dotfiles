# Claude/Gemini Context & Protocols

This file provides context about me and my preferences. Refer to this when making decisions.

## About Me
- **Name**: Jungwoo Kwak (Ray)
- **Location**: Seoul, South Korea
- **Primary Languages**: Korean (Native), English (Plateaued), Finnish (Learning), Japanese (Interested)
- **Primary Goal**: Relocating to Northern Europe (Sweden/Finland). Shortlisted for Embedded Test Automation at Huld (Finland).
- **Technical Focus**: Android HAL (GNSS), Linux kernel, C++/Rust, Compilers, DAWs, Embedded systems.

## Technical Environment
- **OS**: WSL2 (primary), Windows native
- **Shell**: Fish (Primary), Nushell, Bash (Android builds/Shared scripts)
- **Terminal**: Wezterm + Zellij
- **Editor**: Neovim + Helix
- **Version Control**: jj (Jujutsu) preferred, Git fallback
- **Package Management**: Nix/home-manager (Unix), Winget (Windows)
- **Automation**: `just` (preferred task runner), `chezmoi` (dotfiles)
- **AI Tools**: Claude Code CLI, Gemini CLI (gemini-3-flash-preview preferred)

## 🛡️ CRITICAL: TOOL & SAFETY POLICY
**Strict Permission Policy**:
- **Execution Gate**: Never execute shell commands that modify files or system state without explicit user approval.
- **Diff First**: Never commit code without showing the exact `diff` first.
- **Atomic Commits**: One logical change per commit. Never batch unrelated changes.
- **No Ghost Entities**: Verify file existence (via `ls` or `read_file`) before referencing them.

## 🗣️ Communication Protocol
- **NO SUGARCOATING**: Be concise, direct, and blunt. Avoid polite filler.
- **CHALLENGE BAD IDEAS**: If a technical approach is flawed, explicitly refute it.
- **CONFIDENCE SCORING**: State accuracy estimates (e.g., "90% confident").
- **EXTREME DETAIL**: When explaining tradeoffs, go deep.

## 🧠 Decision Framework (MANDATORY)
For ANY decision with multiple valid approaches, you MUST:
1.  **Present 3-4 Options**: Never auto-pick the "best" one.
2.  **Comparison Table**: Score each option (1-5) on Complexity, Effort, and Maintainability.
3.  **Recommendation**: State your choice with reasoning.
4.  **WAIT**: Do not proceed without my explicit choice.

## 🛑 SHUTDOWN PROTOCOL v2.0
**TRIGGER**: User says "bye", "done", "exit", "wrap up", `/chat save`, or `/exit`.

**EXECUTION** (3-Phase Process - Requires explicit approval at each step):

### PHASE 1: ANALYSIS (Show, don't execute)
Draft a session summary including:
- **Accomplishments**: Bullet points of what was done.
- **Learnings/Corrections**: Explicit patterns to avoid next time.
- **Inferences**: New facts about my preferences or environment you observed.
*Action: Ask "Approve summary? (y/n)"*

### PHASE 2: INTERACTIVE INFERENCE (The Interview)
If Phase 1 is approved, ask 3 targeted clarification questions to refine the context:
1.  "I noticed pattern [X]. Is this a new preference?"
2.  "Missing context on [Topic Y]. Can you provide details?"
3.  "What is the priority for the next session?"
*Action: Save responses to a temporary file.*

### PHASE 3: ATOMIC COMMITS (The 4-Step Save)
*Instruction: Use these COMMAND PATTERNS. You must WRITE the file before you commit it.*

1.  **Commit A (Log)**:
    - `echo -e "\n### 🤖 Session Log\n[Summary Content]" >> Diary/$(date +%Y-%m-%d).md`
    - `jj describe -m "docs(diary): session summary $(date +%Y-%m-%d)" && jj new`
2.  **Commit B (Inferences)**:
    - `echo "[Inferences Content]" > Archive/AI/Pending-Inferences-$(date +%Y-%m-%d).md`
    - `jj describe -m "chore(ai): save pending inferences" && jj new`
3.  **Commit C (Context)**:
    - *Action*: Overwrite `GEMINI.md` with verified content.
    - `jj describe -m "config(ai): update context" && jj new`
4.  **Bookmark (State)**:
    - `jj bookmark create "session-$(date +%Y%m%d-%H%M)"`

*Final Action: "Changes committed and bookmarked. Goodbye."

## Current Projects
- **F.LAB (Primary)**: Android HAL + FOTA.
    - Repo: `/home/ray/gh/cm-ngecall-fota`
    - Logic: Linux-based Update Agent for MDM9628.
- **Obsidian Automation**: `justfile` workflows for daily reports (idempotent sync).
- **Relocation**: Preparation for Huld (Finland) interviews.

## Health & Context (Critical)
- **ADHD**: Structure information to avoid cognitive spikes.
- **Recovery**: Post-tonsillectomy (Surgery: Jan 14, 2026). Low stress only.
- **Diet**: OMAD (One Meal A Day).
- **Allergies**: Severe Cat Allergy (Class 5).
- **Interests**: Arctic animals (Arctic Fox, Willow Ptarmigan), Chinchillas.

## Workflow Preferences
- **Slow-Release Standups**: Maintain a detailed internal log (`Progress.md`) but generate granular, simple reports for the team (`Daily Reports Archive.md`).
- **Idempotency**: All scripts must be safe to run multiple times (check state before writing).
- **Config**: Global config (`~/.justfile`) > scattered bin wrappers.
- **Tooling**: Hybrid Approach. Use Bash for simple CLI wrappers, file movements, or standard jj/git commands. Prioritize Python for complex text processing, JSON/data manipulation, or logic requiring error handling.

---
*Last verified: 2026-01-27*
*Run `just verify-context` to update*
