# -----------------------------------------------------------------------------
# .BASH_PROFILE
#
# Executed by login shells. This file sets up the environment and then
# sources .bashrc to configure the shell itself.
# -----------------------------------------------------------------------------

# Silence the "default interactive shell is now zsh" warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------

# Set the default locale.
export LANG=en_US.UTF-8

# Set the terminal type. Important for colors and compatibility.
export TERM=xterm-color

# Configure fzf's Ctrl+R preview window.
export FZF_CTRL_R_OPTS="--preview 'echo {}' --height=40% --border"

# -----------------------------------------------------------------------------
# PATH CONFIGURATION
#
# The order is important. Directories added earlier take precedence.
# -----------------------------------------------------------------------------

# Add user's local bin directory to PATH.
export PATH=~/bin:$PATH

# Add Homebrew to the shell environment.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add Google Cloud SDK to PATH and enable shell command completion.
#if [ -f '/Users/paulomoreira/Projects/google-cloud-sdk/path.bash.inc' ]; then
#  . '/Users/paulomoreira/Projects/google-cloud-sdk/path.bash.inc'
#fi
#if [ -f '/Users/paulomoreira/Projects/google-cloud-sdk/completion.bash.inc' ]; then
#  . '/Users/paulomoreira/Projects/google-cloud-sdk/completion.bash.inc'
#fi

# Add Windsurf/Codeium to PATH.
export PATH="/Users/paulomoreira/.codeium/windsurf/bin:$PATH"

# -----------------------------------------------------------------------------
# USER-SPECIFIC ENVIRONMENT (Unity/ILS)
# -----------------------------------------------------------------------------
#export FOO_REPO_ROOT=/Users/paulomoreira/Projects/Unity/foo

# -----------------------------------------------------------------------------
# SOURCE .BASHRC
#
# Finally, load the interactive shell configuration.
# -----------------------------------------------------------------------------
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi 