# -----------------------------------------------------------------------------
# ALIASES
#
# Define convenient command shortcuts. This file is sourced by .bashrc.
# -----------------------------------------------------------------------------

# More detailed 'ls' output.
alias ll='ls -la'

# git status
alias stt='git status'

# A better 'cat' with syntax highlighting.
alias cat='bat --paging=never'

# Clear the terminal screen and scrollback buffer.
alias cls='clear && printf "\033[3J"'

# Open files in Sublime Text from the terminal.
alias sublime="open -a Sublime\ Text $@"

# Enable color support for 'ls' and distinguish file types.
# This is a safe way to do it that works on different systems.
ls --color=al > /dev/null 2&>1 && alias ls='ls -F --color=al' || alias ls='ls -G'

# -----------------------------------------------------------------------------
