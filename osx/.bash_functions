# -----------------------------------------------------------------------------
# FUNCTIONS
#
# Define more complex, reusable shell functions. This file is sourced by .bashrc.
# -----------------------------------------------------------------------------

# Cleanly extracts the name of the current Git branch.
# Used for the shell prompt.
git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Sets the terminal window title to the name of the current directory.
# This is used by Starship's pre-command hook.
set_win_title() {
  echo -ne "\033]0; $(basename \"$PWD\") \007"
} 