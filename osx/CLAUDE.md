# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS development environment setup repository containing:
- **Shell configuration files** (`.bash_profile`, `.bashrc`, `.bash_aliases`, `.bash_functions`)
- **Setup automation script** (`setup.sh`)
- **Starship prompt configuration** (`starship_shell_template.toml`)
- **Documentation** for macOS development environment setup

The repository focuses on creating a productive Bash-based development environment with modern tools like Starship, fzf, zoxide, and multiple Neovim configurations.

## Common Commands

### Environment Setup
```bash
# Run the main setup script (must be sourced to apply environment changes)
source ./osx/setup.sh

# Copy dotfiles to home directory
cp osx/.bash_profile ~/.bash_profile
cp osx/.bashrc ~/.bashrc
cp osx/.bash_aliases ~/.bash_aliases
cp osx/.bash_functions ~/.bash_functions

# Apply changes to current shell
source ~/.bash_profile
```

### Neovim Configurations
The setup provides three Neovim configurations that can be used side-by-side:
```bash
# Plain Neovim with default configuration
nvim

# LazyVim configuration
lazyvim

# AstroNvim configuration
astrovim
```

### Shell Aliases and Functions (from `.bash_aliases` and `.bash_functions`)
```bash
# Git shortcuts
stt                    # git status
git_branch            # Extract current git branch name

# File operations
ll                    # ls -la
cat                   # bat --paging=never (with syntax highlighting)
cls                   # Clear screen and scrollback

# Editor shortcuts
sublime               # Open Sublime Text
```

## Architecture & Structure

### Shell Configuration Architecture
The shell configuration follows a modular approach:

1. **`.bash_profile`** - Login shell environment setup
   - Environment variables (LANG, TERM, FZF_CTRL_R_OPTS)
   - PATH configuration (Homebrew, rbenv, .NET, Ruby gems)
   - Sources `.bashrc` for interactive shell setup

2. **`.bashrc`** - Interactive shell configuration
   - Sources modular files (`.bash_aliases`, `.bash_functions`, `.bash_env`)
   - Initializes tools (Starship, fzf, zoxide, bash completion)
   - Sets up terminal integration

3. **`.bash_aliases`** - Command shortcuts and abbreviations

4. **`.bash_functions`** - Complex shell functions and Neovim configuration switching

### Setup Script Architecture (`setup.sh`)
The setup script follows a dependency-driven installation approach:

1. **Core Dependencies**: Homebrew, git, neovim, lazygit
2. **Neovim Configurations**: LazyVim and AstroNvim with isolated XDG directories
3. **Language Support**: Python venv, Ruby (rbenv), Perl modules, Node.js
4. **Development Tools**: Language servers, formatters, and debugging tools

### Neovim Configuration Isolation
Uses XDG directory specification to maintain separate configurations:
- **LazyVim**: `~/.config/lazyvim/`, `~/.local/share/lazyvim/`
- **AstroNvim**: `~/.config/astronvim/`, `~/.local/share/astronvim/`
- **Default**: `~/.config/nvim/`, `~/.local/share/nvim/`

## Key Implementation Details

### Environment Variable Management
- Silences macOS zsh deprecation warning via `BASH_SILENCE_DEPRECATION_WARNING=1`
- Configures fzf with custom preview and border settings
- Maintains careful PATH precedence ordering

### Starship Integration
- Custom prompt configuration with Gruvbox theme
- Automatic window title updates via `set_win_title()` function
- Pre-command hooks for enhanced terminal experience

### Development Tool Integration
- Python virtual environment at `~/.venvs/nvim` for Neovim providers
- rbenv for Ruby version management
- local::lib setup for Perl module isolation
- Comprehensive language server support for multiple programming languages

## File Locations

- **Main setup script**: `osx/setup.sh`
- **Shell configuration**: `osx/.bash_profile`, `osx/.bashrc`, `osx/.bash_aliases`, `osx/.bash_functions`
- **Starship configuration**: `osx/starship_shell_template.toml`
- **Documentation**: `osx/# MacOS Development Environment Setup.md`