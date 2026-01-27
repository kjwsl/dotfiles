# Global Justfile - General purpose commands
# Vault-specific commands are in ~/obsidian-vault/justfile

# ============== AI Configuration ==============
# Set your preferred AI: claude, gemini, ollama, or a custom command
# Override with: AI=gemini just ask "question"
export AI := env_var_or_default("AI", "claude")

# AI command wrapper - routes to configured AI
[private]
ai prompt:
    #!/usr/bin/env bash
    case "{{AI}}" in
        claude)
            claude -p "{{prompt}}"
            ;;
        gemini)
            gemini "{{prompt}}"
            ;;
        ollama)
            ollama run llama3.2 "{{prompt}}"
            ;;
        *)
            # Custom command
            {{AI}} "{{prompt}}"
            ;;
    esac

# List available recipes
default:
    @just --list

# ============== Quick AI ==============

# Ask a single quick question
ask question:
    @just ai "{{question}}"

# Ask about a specific file
ask-about file question:
    #!/usr/bin/env bash
    content=$(cat "{{file}}")
    just ai "Given this file content, {{question}}

$content"

# ============== Study Guide Generation ==============

# Generate a study guide on a topic (outputs Typst → PDF)
study topic output="study-guide":
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Generating study guide for: {{topic}}..."

    typst_file="{{output}}.typ"
    pdf_file="{{output}}.pdf"

    just ai "Create a comprehensive study guide about: {{topic}}

Output in Typst format. Structure:
1. Title page with topic name
2. Table of contents
3. Introduction/Overview
4. Main concepts (with clear headings)
5. Key terms and definitions
6. Examples and practice problems
7. Summary/Quick reference
8. Further reading suggestions

Use Typst formatting:
- #heading for sections
- #text for emphasis
- #table for data
- #list for bullet points
- #block for callouts/tips
- Use #pagebreak() between major sections

Make it visually appealing and easy to read. Include diagrams described in text where helpful." > "$typst_file"

    echo "Created: $typst_file"

    if command -v typst &>/dev/null; then
        typst compile "$typst_file" "$pdf_file"
        echo "Compiled: $pdf_file"
    else
        echo "Typst not installed. Run: cargo install typst-cli"
        echo "Then: typst compile $typst_file"
    fi

# Generate study guide from a file/document
study-from file output="study-guide":
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Generating study guide from: {{file}}..."

    content=$(cat "{{file}}")
    typst_file="{{output}}.typ"
    pdf_file="{{output}}.pdf"

    just ai "Create a comprehensive study guide based on this content:

$content

Output in Typst format. Structure:
1. Title page
2. Table of contents
3. Key concepts explained simply
4. Important terms defined
5. Examples and applications
6. Practice questions with answers
7. Quick reference summary

Use proper Typst formatting for a professional look." > "$typst_file"

    echo "Created: $typst_file"

    if command -v typst &>/dev/null; then
        typst compile "$typst_file" "$pdf_file"
        echo "Compiled: $pdf_file"
    else
        echo "Typst not installed. Install with: cargo install typst-cli"
    fi

# Generate flashcards from a topic
flashcards topic output="flashcards":
    #!/usr/bin/env bash
    set -euo pipefail

    just ai "Create flashcards for studying: {{topic}}

Format as a markdown table:
| Front | Back |
|-------|------|
| Question/Term | Answer/Definition |

Include 20-30 cards covering key concepts, terms, and applications." > "{{output}}.md"

    echo "Created: {{output}}.md"

# ============== Commit Message Generation ==============

# Generate commit message options (uses jj if available)
commit:
    #!/usr/bin/env bash
    set -euo pipefail

    if command -v jj &>/dev/null && jj status &>/dev/null 2>&1; then
        VCS="jj"
        DIFF=$(jj diff)
        LOG=$(jj log --limit 10 --no-graph -T 'description ++ "\n"' 2>/dev/null | head -20)
        STATUS=$(jj status)
    else
        VCS="git"
        DIFF=$(git diff --cached)
        if [ -z "$DIFF" ]; then
            DIFF=$(git diff)
        fi
        LOG=$(git log --oneline -10)
        STATUS=$(git status --short)
    fi

    if [ -z "$DIFF" ] && [ "$VCS" = "git" ]; then
        echo "No changes to commit. Stage changes first with 'git add'."
        exit 1
    fi

    echo "Generating commit message using $VCS..."

    just ai "Generate commit messages for these changes.

IMPORTANT:
- Look at the previous commit messages and match their style/convention
- Provide 3 different options (concise, detailed, conventional-commits style)
- Each message should explain WHY, not just WHAT

Previous commits for style reference:
$LOG

Current changes:
$STATUS

Diff:
$DIFF

Format:
## Option 1 (Concise)
<message>

## Option 2 (Detailed)
<message>

## Option 3 (Conventional Commits)
<type>(<scope>): <message>

<body>

Recommend which option fits best based on the existing commit style."

# Auto-commit with AI-generated message (non-interactive)
auto-commit:
    #!/usr/bin/env bash
    set -euo pipefail

    if command -v jj &>/dev/null && jj status &>/dev/null 2>&1; then
        VCS="jj"
        DIFF=$(jj diff)
        LOG=$(jj log --limit 5 --no-graph -T 'description ++ "\n"' 2>/dev/null)
    else
        VCS="git"
        DIFF=$(git diff --cached)
        [ -z "$DIFF" ] && DIFF=$(git diff)
        LOG=$(git log --oneline -5)
    fi

    if [ -z "$DIFF" ]; then
        echo "No changes to commit."
        exit 0
    fi

    MSG=$(just ai "Generate a single concise commit message for these changes. Match the style of previous commits. Output ONLY the commit message, nothing else.

Previous commits:
$LOG

Changes:
$DIFF")

    echo "Generated message: $MSG"
    echo ""

    if [ "$VCS" = "jj" ]; then
        jj describe -m "$MSG"
        echo "Described current commit with message."
    else
        git add -A
        git commit -m "$MSG"
        echo "Committed."
    fi

# ============== Language Learning ==============

# Interactive language learning session
learn lang:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Starting {{lang}} learning session..."
    echo ""

    just ai "You are a {{lang}} language tutor. Start an interactive learning session:

1. First, ask about my current level (beginner/intermediate/advanced)
2. Then provide a short lesson appropriate for that level
3. Include:
   - 3-5 new vocabulary words with pronunciation
   - 1-2 grammar points
   - A practice exercise
   - Common mistakes to avoid

Make it conversational and engaging. Use the target language with translations."

# Generate vocabulary list
vocab lang topic:
    @just ai "Create a vocabulary list for {{lang}} on the topic '{{topic}}'. Include: word, pronunciation, meaning, example sentence. Format as a markdown table. Include 10-15 words."

# Translate with explanation
translate lang text:
    @just ai "Translate to {{lang}}: '{{text}}'. Provide: 1) The translation, 2) Literal breakdown, 3) Cultural notes if relevant, 4) Alternative ways to say it."

# ============== Autonomous AI Work ==============

# Run AI autonomously on a task in a new branch, then create PR
auto-pr task:
    #!/usr/bin/env bash
    set -euo pipefail

    BRANCH_NAME="ai/$(echo '{{task}}' | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-40)"
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    LOG_FILE="/tmp/auto-pr-${TIMESTAMP}.log"

    echo "Starting autonomous AI task..."
    echo "Branch: $BRANCH_NAME"
    echo "Log: $LOG_FILE"
    echo ""

    if command -v jj &>/dev/null && jj status &>/dev/null 2>&1; then
        jj new main -m "AI task: {{task}}"
        jj bookmark create "$BRANCH_NAME"
    else
        git checkout -b "$BRANCH_NAME"
    fi

    claude "Complete this task autonomously: {{task}}

IMPORTANT GUIDELINES:
1. Make changes in logical, small commits
2. After each significant change, describe what you did and why
3. Consider alternative approaches and explain why you chose this one
4. Note any potential issues or things the reviewer should check
5. When done, summarize:
   - What was done
   - Why this approach was chosen over alternatives
   - What to look out for during review
   - Any follow-up tasks

Work through this step by step." 2>&1 | tee "$LOG_FILE"

    echo ""
    echo "Task complete. Creating PR..."

    PR_BODY=$(just ai "Based on this work log, create a PR description:

$(cat "$LOG_FILE")

Format:
## Summary
<what was done>

## Approach
<why this approach, what alternatives were considered>

## Review Notes
<what reviewers should pay attention to>

## Testing
<how to test these changes>")

    if command -v gh &>/dev/null; then
        if command -v jj &>/dev/null && jj status &>/dev/null 2>&1; then
            jj git push --bookmark "$BRANCH_NAME"
        else
            git push -u origin "$BRANCH_NAME"
        fi

        gh pr create --title "AI: {{task}}" --body "$PR_BODY"
        echo "PR created!"
    else
        echo "gh CLI not found. Push manually and create PR."
        echo ""
        echo "PR Description:"
        echo "$PR_BODY"
    fi

# ============== Utilities ==============

# Show notification
notify title message="":
    @printf '\e]777;notify;{{title}};{{message}}\e\\'

# Summarize a file
summarize file:
    #!/usr/bin/env bash
    content=$(cat "{{file}}")
    just ai "Summarize this content concisely:

$content"

# Explain code
explain file:
    #!/usr/bin/env bash
    content=$(cat "{{file}}")
    just ai "Explain this code clearly:

$content

Include:
1. What it does (high-level)
2. How it works (step by step)
3. Key concepts used
4. Potential issues or improvements"

# Review code
review file:
    #!/usr/bin/env bash
    content=$(cat "{{file}}")
    just ai "Review this code for:
1. Bugs or logical errors
2. Security issues
3. Performance problems
4. Style/readability improvements

Code:
$content"

# Show current AI backend
which-ai:
    @echo "Current AI: {{AI}}"
    @echo "Available: claude, gemini, ollama"
    @echo "Override with: AI=gemini just ask 'question'"

# ============== Obsidian Vault Recipes (Imported) ==============
    @just --list

# ============== Questions & Research ==============

# Answer pending questions from the inbox
answer:
    #!/usr/bin/env bash
    set -euo pipefail

    questions=$(sed -n '/^## Pending/,/^## Answered/p' "{{questions_file}}" | grep -E '^\- \[ \]' | sed 's/^- \[ \] //' || true)

    if [ -z "$questions" ]; then
        echo "No pending questions found."
        exit 0
    fi

    echo "Found questions:"
    echo "$questions"
    echo ""
    echo "Processing with Claude..."

    response_file=$(mktemp)
    claude -p "Answer these questions concisely. Format each answer with the question as a header (##) followed by the answer:

$questions" > "$response_file"

    echo "" >> "{{questions_file}}"
    echo "### $(date +%Y-%m-%d)" >> "{{questions_file}}"
    cat "$response_file" >> "{{questions_file}}"

    sed -i '/^## Pending/,/^## Answered/{s/^- \[ \]/- [x]/}' "{{questions_file}}"

    echo ""
    echo "Done! Answers added to Questions Inbox.md"
    rm "$response_file"

# Research a topic and create a note
research topic:
    #!/usr/bin/env bash
    set -euo pipefail
    output_file="/home/ray/obsidian-vault/Fleeting Notes/{{topic}}.md"
    claude -p "Research and summarize: {{topic}}

    Format as markdown with:
    - Overview section
    - Key points as bullet lists
    - Links/references if relevant" > "$output_file"
    echo "Created: $output_file"

# ============== Info Dump & Organization ==============

# Sort and organize the info dump using AI
sort-dump:
    #!/usr/bin/env bash
    set -euo pipefail

    dump_content=$(cat "{{dump_file}}")

    if ! grep -q '[^[:space:]]' <<< "$(sed -n '/<!-- Add anything below this line -->/,$p' "{{dump_file}}" | tail -n +2)"; then
        echo "Info dump is empty. Add some content first."
        exit 0
    fi

    echo "Analyzing and organizing info dump..."

    claude -p "I have random pieces of information dumped in one place. Please:
1. Categorize each piece of information
2. Suggest which existing note in my vault it might belong to, or suggest a new note name
3. Format each item with: Category | Suggested Location | The Information

Here's the dump:

$dump_content

Format your response as a markdown table."

# ============== Personal Context ==============

# Verify and update personal context file
verify-context:
    #!/usr/bin/env bash
    echo "Reviewing your context file for potentially outdated information..."
    echo ""

    claude -p "Review this personal context file and:
1. Identify any fields that are empty or say '(update...)'
2. Ask me specific questions to fill in missing information
3. For any dated information, ask if it's still current
4. Suggest any additional context that might be useful

Context file:
$(cat "{{context_file}}")

Format as a numbered list of questions/prompts for me to answer."

# ============== AI History Export ==============

# Export Claude Code sessions to vault (all or specific date)
export-claude date="":
    #!/usr/bin/env bash
    python3 "/home/ray/obsidian-vault/scripts/export-claude-history.py" "{{date}}"

# Export today's Claude session
export-claude-today:
    @just export-claude "$(date +%Y-%m-%d)"

# ============== Daily Work Reports ==============

# Export AI history and generate daily report
daily-report-full:
    @just export-claude-today
    @just daily-report

# Generate formatted daily report for team standup
daily-report:
    #!/usr/bin/env bash
    set -euo pipefail

    today=$(date +%Y-%m-%d)
    file="{{progress_file}}"

    today_content=$(sed -n "/## $today/,/^## [0-9]/p" "$file" | head -n -1)

    if [ -z "$today_content" ]; then
        echo "No progress logged for today. Use 'just progress \"your update\"' first."
        exit 1
    fi

    claude -p "Convert this progress log into the team daily standup format.

Progress log:
$today_content

Output format (copy-paste ready):

F.LAB - Ray:
Yesterday's progress:
<bullet points of what was done>

Today's plan:
<bullet points of planned work>

Blocker:
<blockers or 'No'>

Be concise and professional. Use the actual content from the log."

# Log progress during the day
progress entry:
    #!/usr/bin/env bash
    set -euo pipefail

    today=$(date +%Y-%m-%d)
    day_name=$(date +%a)
    file="{{progress_file}}"

    if ! grep -q "## $today" "$file"; then
        sed -i "/^---$/,/^---$/!b; /^---$/a\\
\\
## $today ($day_name)\\
\\
### Progress\\
\\
### Tomorrow's Plan\\
\\
### Blockers\\
- None\\
" "$file"
    fi

    sed -i "/## $today/,/### Tomorrow/{ /### Progress/a\\
- {{entry}}
}" "$file"

    echo "Added: {{entry}}"

# Add to today's plan
plan entry:
    #!/usr/bin/env bash
    set -euo pipefail

    today=$(date +%Y-%m-%d)
    file="{{progress_file}}"

    if ! grep -q "## $today" "$file"; then
        just progress "Started day"
    fi

    sed -i "/## $today/,/### Blockers/{ /### Tomorrow's Plan/a\\
- {{entry}}
}" "$file"

    echo "Added to plan: {{entry}}"

# Add a blocker
blocker entry:
    #!/usr/bin/env bash
    set -euo pipefail

    today=$(date +%Y-%m-%d)
    file="{{progress_file}}"

    sed -i "/## $today/,/^## [0-9]/{ /### Blockers/,/^###/{ s/- None//; /### Blockers/a\\
- {{entry}}
}}" "$file"

    echo "Added blocker: {{entry}}"

# ============== Inference Management ==============

pending_file := vault_dir / "CLAUDE.pending.md"

# Review pending inferences and confirm which to save permanently
confirm-inferences:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Pending inferences about you:"
    echo ""
    cat "{{pending_file}}"
    echo ""
    echo "---"
    echo "Opening file for you to review. Check the boxes [x] for items to keep."
    echo "Then run 'just save-inferences' to move confirmed items to CLAUDE.md"

# Save confirmed inferences to CLAUDE.md
save-inferences:
    #!/usr/bin/env bash
    set -euo pipefail

    pending="{{pending_file}}"
    context="{{context_file}}"

    # Extract checked items
    confirmed=$(grep -E '^\- \[x\]' "$pending" | sed 's/- \[x\] /- /' || true)

    if [ -z "$confirmed" ]; then
        echo "No confirmed inferences. Check items with [x] first."
        exit 0
    fi

    echo "Confirmed items:"
    echo "$confirmed"
    echo ""

    # Append to CLAUDE.md under "Things to Remember"
    echo "" >> "$context"
    echo "## Inferences confirmed $(date +%Y-%m-%d)" >> "$context"
    echo "$confirmed" >> "$context"

    # Clear confirmed items from pending
    sed -i 's/- \[x\]/- [saved]/g' "$pending"

    echo "Saved to CLAUDE.md"

# Add a new inference (for AI to call)
infer category note:
    #!/usr/bin/env bash
    echo "- [ ] {{note}}" >> "{{pending_file}}"
    echo "Added inference: {{note}}"

# ============== Prompts Archive ==============

# List all archived AI prompts
prompts:
    @echo "=== AI Prompts ===" && ls -1 "/home/ray/obsidian-vault/Archive/AI/Prompts/" 2>/dev/null || echo "No prompts yet"
    @echo ""
    @echo "=== System Prompts ===" && ls -1 "/home/ray/obsidian-vault/Archive/AI/System_Prompts/" 2>/dev/null || echo "No system prompts yet"
