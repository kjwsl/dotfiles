set -gx MISE_SHELL fish
set -gx __MISE_ORIG_PATH $PATH

# -------------------------------------------------------------------------
# Dynamic 'mise' binary detection for portability (NixOS vs Non-NixOS)
# -------------------------------------------------------------------------
set -l current_user "$USER"
set -l mise_candidates \
    "/home/$current_user/.nix-profile/bin/mise" \
    "/etc/profiles/per-user/$current_user/bin/mise" \
    "/usr/bin/mise" \
    "/usr/local/bin/mise"

set -g MISE_BIN ""

# First, try to find it in known absolute paths (fixing the startup PATH issue)
for candidate in $mise_candidates
    if test -x "$candidate"
        set -g MISE_BIN "$candidate"
        break
    end
end

# If not found in candidate paths, fall back to PATH lookup
if test -z "$MISE_BIN"
    if type -q mise
        set -g MISE_BIN (type -p mise)
    else
        # Last resort fallback to bare command, though this may fail if not in PATH
        set -g MISE_BIN "mise"
    end
end
# -------------------------------------------------------------------------

function mise
  if test (count $argv) -eq 0
    command $MISE_BIN
    return
  end

  set command $argv[1]
  set -e argv[1]

  if contains -- --help $argv
    command $MISE_BIN "$command" $argv
    return $status
  end

  switch "$command"
  case deactivate shell sh
    # if help is requested, don't eval
    if contains -- -h $argv
      command $MISE_BIN "$command" $argv
    else if contains -- --help $argv
      command $MISE_BIN "$command" $argv
    else
      source (command $MISE_BIN "$command" $argv |psub)
    end
  case '*'
    command $MISE_BIN "$command" $argv
  end
end

function __mise_env_eval --on-event fish_prompt --description 'Update mise environment when changing directories';
    command $MISE_BIN hook-env -s fish | source;

    if test "$mise_fish_mode" != "disable_arrow";
        function __mise_cd_hook --on-variable PWD --description 'Update mise environment when changing directories';
            if test "$mise_fish_mode" = "eval_after_arrow";
                set -g __mise_env_again 0;
            else;
                command $MISE_BIN hook-env -s fish | source;
            end;
        end;
    end;
end;

function __mise_env_eval_2 --on-event fish_preexec --description 'Update mise environment when changing directories';
    if set -q __mise_env_again;
        set -e __mise_env_again;
        command $MISE_BIN hook-env -s fish | source;
        echo;
    end;

    functions --erase __mise_cd_hook;
end;

__mise_env_eval
if functions -q fish_command_not_found; and not functions -q __mise_fish_command_not_found
    functions -e __mise_fish_command_not_found
    functions -c fish_command_not_found __mise_fish_command_not_found
end

function fish_command_not_found
    if string match -qrv -- '^(?:mise$|mise-)' $argv[1] &&
        command $MISE_BIN hook-not-found -s fish -- $argv[1]
        command $MISE_BIN hook-env -s fish | source
    else if functions -q __mise_fish_command_not_found
        __mise_fish_command_not_found $argv
    else
        __fish_default_command_not_found_handler $argv
    end
end
