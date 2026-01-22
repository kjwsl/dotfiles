# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;; 
esac

# -----------------------------------------------------------------------------
# Environment Variables & Path
# -----------------------------------------------------------------------------

# Add local bin to PATH
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# Source External Configs
# -----------------------------------------------------------------------------

if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi

if [[ -f "$HOME/.aliasrc" ]]; then
    source "$HOME/.aliasrc"
fi

if [[ -f "$HOME/.envrc" ]]; then
    source "$HOME/.envrc"
fi

if [ -d "$HOME/modules" ]; then
    for f in "$HOME/modules/"*.sh; do
        source "$f"
    done
fi

if [ -f .bash_eww ]; then
    . .bash_eww
fi

# -----------------------------------------------------------------------------
# Tool Initialization
# -----------------------------------------------------------------------------

# Homebrew
if command -v brew > /dev/null; then
    eval "$(brew shellenv)"
fi

# fnm
FNM_PATH="/home/ray/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# Cargo
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Zoxide (smarter cd)
if command -v zoxide > /dev/null; then
    eval "$(zoxide init bash)"
fi

# FZF
[ -f ~/.fzf.bash ] && source "$HOME/.fzf.bash"

# -----------------------------------------------------------------------------
# Functions & Completions
# -----------------------------------------------------------------------------

smartdd() {
    local source="$1"
    local dest="$2"
    local bs_size="4M"
    local count_bytes=0
    local mode=""

    # 1. Input Validation
    if [[ -z "$source" || -z "$dest" ]]; then
        echo "Usage: smartdd <input_file_or_dev_zero> <destination_device>"
        return 1
    fi

    if [[ ! -e "$dest" ]]; then
        echo "Error: Destination $dest does not exist."
        return 1
    fi

    # 2. Determine Mode & Calculate Size
    if [[ "$source" == "/dev/zero" ]]; then
        # --- MODE: ZERO WIPE ---
        mode="WIPE"
        
        # Method A: Try lsblk (Standard Linux)
        if command -v lsblk &> /dev/null; then
             count_bytes=$(lsblk -b -n -o SIZE "$dest" | head -n 1)
        fi

        # Method B: Fallback for Git Bash / MSYS (if Method A failed or returned nothing)
        # This parses /proc/partitions, gets the 1K-block count, and multiplies by 1024
        if [[ -z "$count_bytes" ]]; then
            local base_dest=$(basename "$dest")
            local blocks=$(cat /proc/partitions | grep "${base_dest}$" | awk '{print $3}')
            
            if [[ -n "$blocks" ]]; then
                count_bytes=$((blocks * 1024))
            fi
        fi

    else
        # --- MODE: FLASH IMAGE ---
        mode="FLASH"
        
        if [[ ! -e "$source" ]]; then
            echo "Error: Source file $source not found."
            return 1
        fi

        # Get file size using stat
        # Check if GNU stat (Linux/GitBash) or BSD stat (Mac)
        if stat --version &> /dev/null; then
            count_bytes=$(stat -c %s "$source") # GNU
        else
            count_bytes=$(stat -f %z "$source") # BSD/Mac
        fi
    fi

    # 3. Safety Check
    if [[ -z "$count_bytes" || "$count_bytes" -eq 0 ]]; then
        echo "Error: Could not determine size automatically. Aborting."
        return 1
    fi

    # Calculate MB for display (Integer math)
    local size_mb=$((count_bytes / 1024 / 1024))

    # 4. Confirmation Prompt
    echo "---------------------------------------------------"
    echo "Mode:      $mode"
    echo "Source:    $source"
    echo "Target:    $dest"
    echo "Data Size: $count_bytes bytes (~$size_mb MB)"
    echo "---------------------------------------------------"
    echo "Press [Enter] to start or [Ctrl+C] to cancel..."
    read -r

    # 5. Execution
    # iflag=count_bytes ensures we stop exactly at the limit
    dd if="$source" of="$dest" bs="$bs_size" count="$count_bytes" iflag=count_bytes status=progress
    
    # 6. Final Sync
    echo "Syncing cache..."
    sync
    echo "Done."
}

# bash completion V2 for darkman                              -*- shell-script -*-

__darkman_debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE-} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

# Macs have bash3 for which the bash-completion package doesn't include
# _init_completion. This is a minimal version of that function.
__darkman_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

# This function calls the darkman program to obtain the completion
# results and the directive.  It fills the 'out' and 'directive' vars.
__darkman_get_completion_results() {
    local requestComp lastParam lastChar args

    # Prepare the command to request completions for the program.
    # Calling ${words[0]} instead of directly darkman allows to handle aliases
    args=("${words[@]:1}")
    requestComp="${words[0]} __complete ${args[*]}"

    lastParam=${words[$((${#words[@]}-1))]}
    lastChar=${lastParam:$((${#lastParam}-1)):1}
    __darkman_debug "lastParam ${lastParam}, lastChar ${lastChar}"

    if [[ -z ${cur} && ${lastChar} != = ]]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __darkman_debug "Adding extra empty parameter"
        requestComp="${requestComp} ''"
    fi

    # When completing a flag with an = (e.g., darkman -n=<TAB>)
    # bash focuses on the part after the =, so we need to remove
    # the flag part from $cur
    if [[ ${cur} == -*=* ]]; then
        cur="${cur#*=}"
    fi

    __darkman_debug "Calling ${requestComp}"
    # Use eval to handle any environment variables and such
    out=$(eval "${requestComp}" 2>/dev/null)

    # Extract the directive integer at the very end of the output following a colon (:) 
    directive=${out##*:}
    # Remove the directive
    out=${out%:*} 
    if [[ ${directive} == "${out}" ]]; then
        # There is not directive specified
        directive=0
    fi
    __darkman_debug "The completion directive is: ${directive}"
    __darkman_debug "The completions are: ${out}"
}

__darkman_process_completion_results() {
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    if (((directive & shellCompDirectiveError) != 0)); then
        # Error code.  No completion.
        __darkman_debug "Received error from custom completion go code"
        return
    else
        if (((directive & shellCompDirectiveNoSpace) != 0)); then
            if [[ $(type -t compopt) == builtin ]]; then
                __darkman_debug "Activating no space"
                compopt -o nospace
            else
                __darkman_debug "No space directive not supported in this version of bash"
            fi
        fi
        if (((directive & shellCompDirectiveKeepOrder) != 0)); then
            if [[ $(type -t compopt) == builtin ]]; then
                # no sort isn't supported for bash less than < 4.4
                if [[ ${BASH_VERSINFO[0]} -lt 4 || ( ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -lt 4 ) ]]; then
                    __darkman_debug "No sort directive not supported in this version of bash"
                else
                    __darkman_debug "Activating keep order"
                    compopt -o nosort
                fi
            else
                __darkman_debug "No sort directive not supported in this version of bash"
            fi
        fi
        if (((directive & shellCompDirectiveNoFileComp) != 0)); then
            if [[ $(type -t compopt) == builtin ]]; then
                __darkman_debug "Activating no file completion"
                compopt +o default
            else
                __darkman_debug "No file completion directive not supported in this version of bash"
            fi
        fi
    fi

    # Separate activeHelp from normal completions
    local completions=()
    local activeHelp=()
    __darkman_extract_activeHelp

    if (((directive & shellCompDirectiveFilterFileExt) != 0)); then
        # File extension filtering
        local fullFilter filter filteringCmd

        # Do not use quotes around the $completions variable or else newline
        # characters will be kept.
        for filter in ${completions[*]}; do
            fullFilter+="$filter|"
        done

        filteringCmd="_filedir $fullFilter"
        __darkman_debug "File filtering command: $filteringCmd"
        $filteringCmd
    elif (((directive & shellCompDirectiveFilterDirs) != 0)); then
        # File completion for directories only

        local subdir
        subdir=${completions[0]}
        if [[ -n $subdir ]]; then
            __darkman_debug "Listing directories in $subdir"
            pushd "$subdir" >/dev/null 2>&1 && _filedir -d && popd >/dev/null 2>&1 || return
        else
            __darkman_debug "Listing directories in ."
            _filedir -d
        fi
    else
        __darkman_handle_completion_types
    fi

    __darkman_handle_special_char "$cur" :
    __darkman_handle_special_char "$cur" =

    # Print the activeHelp statements before we finish
    if ((${#activeHelp[*]} != 0)); then
        printf "\n";
        printf "%s\n" "${activeHelp[@]}"
        printf "\n"

        # The prompt format is only available from bash 4.4.
        # We test if it is available before using it.
        if (x=${PS1@P}) 2> /dev/null; then
            printf "%s" "${PS1@P}${COMP_LINE[@]}"
        else
            # Can't print the prompt.  Just print the
            # text the user had typed, it is workable enough.
            printf "%s" "${COMP_LINE[@]}"
        fi
    fi
}

# Separate activeHelp lines from real completions.
# Fills the $activeHelp and $completions arrays.
__darkman_extract_activeHelp() {
    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}

    while IFS='' read -r comp; do
        if [[ ${comp:0:endIndex} == $activeHelpMarker ]]; then
            comp=${comp:endIndex}
            __darkman_debug "ActiveHelp found: $comp"
            if [[ -n $comp ]]; then
                activeHelp+=("$comp")
            fi
        else
            # Not an activeHelp line but a normal completion
            completions+=("$comp")
        fi
    done <<<"${out}"
}

__darkman_handle_completion_types() {
    __darkman_debug "__darkman_handle_completion_types: COMP_TYPE is $COMP_TYPE"

    case $COMP_TYPE in
    37|42)
        # Type: menu-complete/menu-complete-backward and insert-completions
        # If the user requested inserting one completion at a time, or all
        # completions at once on the command-line we must remove the descriptions.
        # https://github.com/spf13/cobra/issues/1508
        local tab=$'\t' comp
        while IFS='' read -r comp; do
            [[ -z $comp ]] && continue
            # Strip any description
            comp=${comp%%$tab*}
            # Only consider the completions that match
            if [[ $comp == "$cur"* ]]; then
                COMPREPLY+=("$comp")
            fi
        done < <(printf "%s\n" "${completions[@]}")
        ;;

    *)
        # Type: complete (normal completion)
        __darkman_handle_standard_completion_case
        ;; 
    esac
}

__darkman_handle_standard_completion_case() {
    local tab=$'\t' comp

    # Short circuit to optimize if we don't have descriptions
    if [[ "${completions[*]}" != *$tab* ]]; then
        IFS=$'\n' read -ra COMPREPLY -d '' < <(compgen -W "${completions[*]}" -- "$cur")
        return 0
    fi

    local longest=0
    local compline
    # Look for the longest completion so that we can format things nicely
    while IFS='' read -r compline; do
        [[ -z $compline ]] && continue
        # Strip any description before checking the length
        comp=${compline%%$tab*}
        # Only consider the completions that match
        [[ $comp == "$cur"* ]] || continue
        COMPREPLY+=("$compline")
        if ((${#comp}>longest)); then
            longest=${#comp}
        fi
    done < <(printf "%s\n" "${completions[@]}")

    # If there is a single completion left, remove the description text
    if ((${#COMPREPLY[*]} == 1)); then
        __darkman_debug "COMPREPLY[0]: ${COMPREPLY[0]}"
        comp="${COMPREPLY[0]%%$tab*}"
        __darkman_debug "Removed description from single completion, which is now: ${comp}"
        COMPREPLY[0]=$comp
    else # Format the descriptions
        __darkman_format_comp_descriptions $longest
    fi
}

__darkman_handle_special_char()
{
    local comp="$1"
    local char=$2
    if [[ "$comp" == *${char}* && "$COMP_WORDBREAKS" == *${char}* ]]; then
        local word=${comp%"${comp##*${char}}"}
        local idx=${#COMPREPLY[*]}
        while ((--idx >= 0)); do
            COMPREPLY[idx]=${COMPREPLY[idx]#"$word"}
        done
    fi
}

__darkman_format_comp_descriptions()
{
    local tab=$'\t'
    local comp desc maxdesclength
    local longest=$1

    local i ci
    for ci in ${!COMPREPLY[*]}; do
        comp=${COMPREPLY[ci]}
        # Properly format the description string which follows a tab character if there is one
        if [[ "$comp" == *$tab* ]]; then
            __darkman_debug "Original comp: $comp"
            desc=${comp#*$tab}
            comp=${comp%%$tab*}

            # $COLUMNS stores the current shell width.
            # Remove an extra 4 because we add 2 spaces and 2 parentheses.
            maxdesclength=$(( COLUMNS - longest - 4 ))

            # Make sure we can fit a description of at least 8 characters
            # if we are to align the descriptions.
            if ((maxdesclength > 8)); then
                # Add the proper number of spaces to align the descriptions
                for ((i = ${#comp} ; i < longest ; i++)); do
                    comp+=" "
                done
            else
                # Don't pad the descriptions so we can fit more text after the completion
                maxdesclength=$(( COLUMNS - ${#comp} - 4 ))
            fi

            # If there is enough space for any description text,
            # truncate the descriptions that are too long for the shell width
            if ((maxdesclength > 0)); then
                if ((${#desc} > maxdesclength)); then
                    desc=${desc:0:$(( maxdesclength - 1 ))}
                    desc+="…"
                fi
                comp+="  ($desc)"
            fi
            COMPREPLY[ci]=$comp
            __darkman_debug "Final comp: $comp"
        fi
    done
}

__start_darkman()
{
    local cur prev words cword split

    COMPREPLY=()

    # Call _init_completion from the bash-completion package
    # to prepare the arguments properly
    if declare -F _init_completion >/dev/null 2>&1; then
        _init_completion -n =: || return
    else
        __darkman_init_completion -n =: || return
    fi

    __darkman_debug
    __darkman_debug "========= starting completion logic =========="
    __darkman_debug "cur is ${cur}, words[*] is ${words[*]}, #words[@] is ${#words[@]}, cword is $cword"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $cword location, so we need
    # to truncate the command-line ($words) up to the $cword location.
    words=("${words[@]:0:$cword+1}")
    __darkman_debug "Truncated words[*]: ${words[*]},"

    local out directive
    __darkman_get_completion_results
    __darkman_process_completion_results
}

if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -F __start_darkman darkman
else
    complete -o default -o nospace -F __start_darkman darkman
fi

# -----------------------------------------------------------------------------
# Prompt (Starship) - Keep Last
# -----------------------------------------------------------------------------
eval "$(starship init bash)"