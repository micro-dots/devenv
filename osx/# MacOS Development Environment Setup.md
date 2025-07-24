# MacOS Development Environment Setup

## Overview
This document provides a streamlined setup guide for a productive development environment on macOS, using Bash as the primary shell with Starship for prompt customization, `fzf` for fuzzy finding, and additional tools to improve efficiency.

## Prerequisites
Ensure you have [Homebrew](https://brew.sh/) installed before proceeding:
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Core Tools
### 1. Install Bash (Latest Version)
macOS ships with an outdated version of Bash. Install the latest version:
```sh
brew install bash
```
After installation, change your default shell to Homebrew’s Bash:
```sh
echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
chsh -s $(brew --prefix)/bin/bash
```
To suppress the macOS deprecation warning:
```sh
echo 'export BASH_SILENCE_DEPRECATION_WARNING=1' >> ~/.bash_profile
```

### 2. Install Starship (Prompt Customization)
```sh
brew install starship
mkdir -p ~/.config && touch ~/.config/starship.toml
echo 'eval "$(starship init bash)"' >> ~/.bashrc
```
Install a NerdFont from https://www.nerdfonts.com/font-downloads (FiraCode and FiraMono suggested)  
Customize Starship by editing `~/.config/starship.toml`.
To check slow modules:
```sh
starship timings
```

### 3. Install `fzf` (Fuzzy Finder)
```sh
brew install fzf
$(brew --prefix)/opt/fzf/install
```
Usage example:
- `CTRL+R`: Search command history
- `fzf`: Fuzzy search files interactively

### 4. Install `bash-completion`
```sh
brew install bash-completion
```
Ensure it’s loaded in `~/.bashrc`:
```sh
echo "[[ -r $(brew --prefix)/etc/profile.d/bash_completion.sh ]] && . $(brew --prefix)/etc/profile.d/bash_completion.sh" >> ~/.bashrc
```

## Additional Tools
### 5. Install `ripgrep` (Faster Grep Alternative)
```sh
brew install ripgrep
```
Usage:
```sh
rg "search-term" /path/to/directory
```

### 6. Install `exa` (Modern `ls` Replacement)
```sh
brew install exa
```
Usage:
```sh
exa -lah
```

### 7. Install `zoxide` (Smart `cd` Alternative)
```sh
brew install zoxide
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
```
Usage:
```sh
z foo  # Jumps to most frequently used directory matching 'foo'
```

### 8. Install `bat` (Better `cat` Alternative)
```sh
brew install bat
```
Usage:
```sh
bat file.txt
```
Alias `bat` to replace `cat`:
```sh
echo "alias cat='bat --paging=never'" >> ~/.bashrc
```

### 9. Install `atuin` (Better Shell History Management)
```sh
brew install atuin
atuin import auto
atuin sync
```
Usage:
```sh
atuin search "command"
```

### 10. Configure macOS Defaults
#### Speed Up Key Repeat
```sh
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
```
#### Show Hidden Files in Finder
```sh
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```
#### Clean Up macOS Dock (Optional)
Install `dockutil`, a command-line tool to manage the macOS dock:
```sh
brew install dockutil
```
Remove all icons from the dock:
```sh
dockutil --remove all
```
To add back essential apps:
```sh
dockutil --add /Applications/Google\ Chrome.app
dockutil --add /Applications/iTerm.app
```

### 11. Install and Configure `iTerm2` (Enhanced Terminal Emulator)
```sh
brew install --cask iterm2
```
Enable shell integration for better experience:
```sh
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
```
If needing to uninstall shell integration for any reason, check: https://gist.github.com/victor-torres/67c272be0cb0d6989729  

## Shell Configuration
### Environment Variables
```sh
export LANG=en_US.UTF-8
export TERM=xterm-color
```

### Aliases and Functions Organization
To keep the `.bashrc` file clean, split aliases and functions into separate files:

#### **Create and Load a `.bash_aliases` File:**
```sh
echo 'if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi' >> ~/.bashrc
```
**Example `~/.bash_aliases` Content:**
```sh
alias ll='ls -la'
alias sublime="open -a Sublime\\ Text $@"
alias cls='clear && printf "\033[3J"' # clear screen and scrollback buffer
```

#### **Create and Load a `.bash_functions` File:**
```sh
echo 'if [ -f ~/.bash_functions ]; then . ~/.bash_functions; fi' >> ~/.bashrc
```
**Example `~/.bash_functions` Content:**
```sh
git_branch () { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }
set_win_title() { echo -ne "\033]0; $(basename \"$PWD\") \007"; }
```

### Keybindings for `fzf` History Search
```sh
export FZF_CTRL_R_OPTS="--preview 'echo {}' --height=40% --border"
```

### Prompt Customization
```sh
TIME='\033[01;31m\]\t \033[01;32m\]'
LOCATION=' \033[01;36m\]`pwd | sed "s#\(/[^/]\{1,\}/[^/]\{1,\}/[^/]\{1,\}/\).*/\(/[^/]\{1,\}/[^/]\{1,\}\)/\{0,1\}#\1_\2#g"`'
BRANCH=' \033[00;33m\]$(git_branch)\[\033[00m\]\n$ '
PS1=$TIME$USER$LOCATION$BRANCH
PS2='\[\033[01;36m\]>'

# Automatically update window title
starship_precmd_user_func="set_win_title"
```

## Reload Configuration
After installation, apply changes:
```sh
source ~/.bashrc
```

## Summary
This setup provides an enhanced Bash shell with:
- Aesthetic, informative prompts (`starship`)
- Faster fuzzy searching (`fzf`)
- Smarter navigation (`zoxide`)
- Better file listing (`exa`)
- Improved command history (`atuin`)
- High-performance searching (`ripgrep`)
- Enhanced GitHub workflow (`gh`)
- Terminal multiplexing (`tmux`)
- Efficient file searching (`fd`)
- System monitoring (`htop`)
- Optimized macOS settings and dock management
- Enhanced terminal experience with `iTerm2`

For more details, refer to each tool’s documentation.

---
### [GitHub Repository (TBD)](https://github.com/your-repo)

