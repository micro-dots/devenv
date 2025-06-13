# -----------------------------------------------------------------------------
# .BASHRC
#
# Executed by interactive, non-login shells. This file configures the
# shell prompt, tools, and sources aliases and functions.
# -----------------------------------------------------------------------------

# Load custom aliases and functions.
# Check if the files exist before trying to source them.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

# -----------------------------------------------------------------------------
# SHELL & TOOL INITIALIZATION
# -----------------------------------------------------------------------------

# Initialize Starship for a custom prompt.
# This will override the default PS1.
eval "$(starship init bash)"

# Set up fzf (fuzzy finder) key bindings and fuzzy completion.
eval "$(fzf --bash)"

# Initialize zoxide, a "smarter cd" command.
eval "$(zoxide init bash)"

# Initialize Homebrew's bash completion.
if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  . /opt/homebrew/etc/profile.d/bash_completion.sh
fi

# Link the 'set_win_title' function to Starship's pre-command hook
# to automatically update the terminal window title.
starship_precmd_user_func="set_win_title"

# -----------------------------------------------------------------------------
# MISC & USER-SPECIFIC
# -----------------------------------------------------------------------------

# Source iTerm2 shell integration if it exists.
if [ -f "${HOME}/.iterm2_shell_integration.bash" ]; then
    source "${HOME}/.iterm2_shell_integration.bash"
fi 