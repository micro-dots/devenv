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

# Neovim configuration functions
nvim_plain_func() {
  nvim "$@"
}

lazyvim_func() {
  XDG_CONFIG_HOME="$HOME/.config/lazyvim" \
  XDG_DATA_HOME="$HOME/.local/share/lazyvim" \
  XDG_STATE_HOME="$HOME/.local/state/lazyvim" \
  XDG_CACHE_HOME="$HOME/.cache/lazyvim" \
  nvim "$@"
}

astrovim_func() {
  XDG_CONFIG_HOME="$HOME/.config/astronvim" \
  XDG_DATA_HOME="$HOME/.local/share/astronvim" \
  XDG_STATE_HOME="$HOME/.local/state/astronvim" \
  XDG_CACHE_HOME="$HOME/.cache/astronvim" \
  nvim "$@"
}
