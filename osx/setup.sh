#!/bin/bash
# -----------------------------------------------------------------------------
# SETUP SCRIPT
#
# This script copies the dotfiles from this directory to the user's home
# directory. It creates a backup of any existing files.
# -----------------------------------------------------------------------------

set -e # Exit immediately if a command exits with a non-zero status.

# Directory where this script is located.
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# --- Helper Functions ---

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Installation Functions ---

install_homebrew() {
  if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed."
  fi
}

install_lazygit() {
  if ! command_exists lazygit; then
    echo "Installing lazygit..."
    brew install lazygit
  else
    echo "lazygit is already installed."
  fi
}

install_neovim() {
  if ! command_exists nvim; then
    echo "Installing neovim..."
    brew install neovim
  else
    echo "neovim is already installed."
  fi
}

install_lazyvim() {
  # Requirements check
  echo "Checking requirements for LazyVim..."

  # Git requirement
  if ! command_exists git; then
    echo "Error: git is not installed. Please install git and run this script again."
    exit 1
  fi
  local git_version
  git_version=$(git --version | awk '{print $3}')
  local min_git_version="2.19.0"
  if ! printf '%s\n' "$min_git_version" "$git_version" | sort -V -C; then
    echo "Error: git version $min_git_version or higher is required. You have $git_version."
    exit 1
  fi
  echo "Git version is sufficient."

  # Neovim requirement
  if ! command_exists nvim; then
    echo "Error: neovim is not installed. Please install neovim and run this script again."
    exit 1
  fi
  local nvim_version
  # Extracts version number like 0.9.5 from "NVIM v0.9.5"
  nvim_version=$(nvim --version | head -n 1 | sed -E 's/NVIM v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)/\1.\2.\3/')
  local min_nvim_version="0.9.0"
  if ! printf '%s\n' "$min_nvim_version" "$nvim_version" | sort -V -C; then
    echo "Error: nvim version $min_nvim_version or higher is required. You have $nvim_version."
    exit 1
  fi
  echo "Neovim version is sufficient."

  # Nerd Font check
  echo "Checking for Nerd Font..."
  if ! command_exists fc-list; then
      echo "Warning: 'fontconfig' not found, cannot check for Nerd Fonts. Installing it now..."
      brew install fontconfig
  fi
  if ! fc-list | grep -i "Nerd Font" > /dev/null; then
      echo "Warning: Nerd Font not found. Please install a Nerd Font for the best experience."
      echo "You can find them at https://www.nerdfonts.com/font-downloads"
  else
      echo "Nerd Font found."
  fi


  # Backup existing nvim config
  local timestamp=$(date +%Y%m%d%H%M%S)
  if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing neovim configuration to $HOME/.config/nvim.bak.$timestamp"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$timestamp"
  fi

  if [ -d "$HOME/.local/share/lazyvim" ]; then
    echo "Backing up existing LazyVim share to $HOME/.local/share/lazyvim.bak.$timestamp"
    mv "$HOME/.local/share/lazyvim" "$HOME/.local/share/lazyvim.bak.$timestamp"
  fi
  if [ -d "$HOME/.config/lazyvim" ]; then
    echo "Backing up existing LazyVim config to $HOME/.config/lazyvim.bak.$timestamp"
    mv "$HOME/.config/lazyvim" "$HOME/.config/lazyvim.bak.$timestamp"
  fi


  # Clone LazyVim starter
  echo "Cloning LazyVim starter..."
  mkdir -p ~/.config/lazyvim
  git clone https://github.com/LazyVim/starter ~/.config/lazyvim/nvim

  # Remove .git folder
  echo "Removing .git folder from starter..."
  rm -rf ~/.config/lazyvim/nvim/.git

  echo "LazyVim installation complete."
}

install_astrovim() {
  # Requirements check (similar to LazyVim, but AstroNvim specific)
  echo "Checking requirements for AstroNvim..."

  # Git requirement
  if ! command_exists git; then
    echo "Error: git is not installed. Please install git and run this script again."
    exit 1
  fi
  local git_version
  git_version=$(git --version | awk '{print $3}')
  local min_git_version="2.19.0"
  if ! printf '%s\n' "$min_git_version" "$git_version" | sort -V -C; then
    echo "Error: git version $min_git_version or higher is required. You have $git_version."
    exit 1
  fi
  echo "Git version is sufficient."

  # Neovim requirement
  if ! command_exists nvim; then
    echo "Error: neovim is not installed. Please install neovim and run this script again."
    exit 1
  fi
  local nvim_version
  nvim_version=$(nvim --version | head -n 1 | sed -E 's/NVIM v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)/\1.\2.\3/')
  local min_nvim_version="0.9.0"
  if ! printf '%s\n' "$min_nvim_version" "$nvim_version" | sort -V -C; then
    echo "Error: nvim version $min_nvim_version or higher is required. You have $nvim_version."
    exit 1
  fi
  echo "Neovim version is sufficient."

  # Backup existing AstroNvim config
  local timestamp=$(date +%Y%m%d%H%M%S)
  if [ -d "$HOME/.config/astronvim" ]; then
    echo "Backing up existing AstroNvim configuration to $HOME/.config/astronvim.bak.$timestamp"
    mv "$HOME/.config/astronvim" "$HOME/.config/astronvim.bak.$timestamp"
  fi
  if [ -d "$HOME/.local/share/astronvim" ]; then
    echo "Backing up existing AstroNvim share to $HOME/.local/share/astronvim.bak.$timestamp"
    mv "$HOME/.local/share/astronvim" "$HOME/.local/share/astronvim.bak.$timestamp"
  fi

  # Clone AstroNvim template
  echo "Cloning AstroNvim template..."
  mkdir -p ~/.config/astronvim
  git clone --depth 1 https://github.com/AstroNvim/template ~/.config/astronvim/nvim

  # Remove .git folder
  echo "Removing .git folder from starter..."
  rm -rf ~/.config/astronvim/nvim/.git

  echo "AstroNvim installation complete."
}

install_dependencies() {
    echo "Installing additional dependencies for Neovim configurations..."

    # Core tools for various plugins
    if ! command_exists fish; then
        brew install fish
    else
        echo "fish is already installed. Skipping installation."
    fi

    if ! command_exists ast-grep; then
        brew install ast-grep
    else
        echo "ast-grep is already installed. Skipping installation."
    fi

    if ! command_exists luarocks; then
        brew install luarocks
    else
        echo "luarocks is already installed. Skipping installation."
    fi

    if ! command_exists go; then
        brew install go
    else
        echo "go is already installed. Skipping installation."
    fi
    if ! command_exists composer; then
        brew install composer
    else
        echo "composer is already installed. Skipping installation."
    fi
    if ! command_exists php; then
        brew install php
    else
        echo "php is already installed. Skipping installation."
    fi
    if ! command_exists rustc; then
        brew install rust
    else
        echo "rust is already installed. Skipping installation."
    fi
    if ! command_exists java; then
        brew install openjdk
    else
        echo "openjdk is already installed. Skipping installation."
    fi
    if ! command_exists julia; then
        brew install julia
    else
        echo "julia is already installed. Skipping installation."
    fi

    if ! command_exists ghostscript; then
        brew install ghostscript
    else
        echo "ghostscript is already installed. Skipping installation."
    fi
    if ! command_exists tectonic; then
        brew install tectonic
    else
        echo "tectonic is already installed. Skipping installation."
    fi
    if ! command_exists mmdc; then
        npm install -g @mermaid-js/mermaid-cli
    else
        echo "@mermaid-js/mermaid-cli is already installed. Skipping installation."
    fi

    # Add fd for AstroNvim requirement
    if ! command_exists fd; then
        brew install fd
    else
        echo "fd is already installed. Skipping installation."
    fi

    # Add gdu (disk usage analyzer) for AstroNvim
    if ! command_exists gdu; then
        brew install gdu
    else
        echo "gdu is already installed. Skipping installation."
    fi

    # Add bottom (system monitor) for AstroNvim
    if ! command_exists btm; then
        brew install bottom
    else
        echo "bottom is already installed. Skipping installation."
    fi

    # Python virtual environments for Neovim configurations
    echo "Creating Python virtual environments for Neovim configurations..."
    
    # Default nvim environment
    if [ ! -d "$HOME/.venvs/nvim" ]; then
        python3 -m venv "$HOME/.venvs/nvim"
        "$HOME/.venvs/nvim/bin/pip" install pynvim
    else
        echo "Python virtual environment for default nvim already exists. Skipping creation."
    fi
    
    # LazyVim environment
    if [ ! -d "$HOME/.venvs/lazyvim" ]; then
        python3 -m venv "$HOME/.venvs/lazyvim"
        "$HOME/.venvs/lazyvim/bin/pip" install pynvim
    else
        echo "Python virtual environment for LazyVim already exists. Skipping creation."
    fi
    
    # AstroNvim environment
    if [ ! -d "$HOME/.venvs/astronvim" ]; then
        python3 -m venv "$HOME/.venvs/astronvim"
        "$HOME/.venvs/astronvim/bin/pip" install pynvim
    else
        echo "Python virtual environment for AstroNvim already exists. Skipping creation."
    fi

    echo "Configuring Neovim configurations to use their respective Python virtual environments..."
    
    # Configure default nvim
    local default_config_dir="$HOME/.config/nvim/lua/config"
    local default_options_file="$default_config_dir/options.lua"
    local default_python_host_line='vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/nvim/bin/python3"'
    
    mkdir -p "$default_config_dir"
    if [ ! -f "$default_options_file" ] || ! grep -q "$default_python_host_line" "$default_options_file"; then
        echo "$default_python_host_line" >> "$default_options_file"
    fi
    
    # Configure LazyVim
    local lazyvim_config_dir="$HOME/.config/lazyvim/nvim/lua/config"
    local lazyvim_options_file="$lazyvim_config_dir/options.lua"
    local lazyvim_python_host_line='vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/lazyvim/bin/python3"'
    
    mkdir -p "$lazyvim_config_dir"
    if [ ! -f "$lazyvim_options_file" ] || ! grep -q "$lazyvim_python_host_line" "$lazyvim_options_file"; then
        echo "$lazyvim_python_host_line" >> "$lazyvim_options_file"
    fi
    
    # Configure AstroNvim
    local astronvim_astrocore_file="$HOME/.config/astronvim/nvim/lua/plugins/astrocore.lua"
    
    # Enable astrocore.lua and configure Python provider
    if [ -f "$astronvim_astrocore_file" ]; then
        # Remove the blocking line if it exists
        if grep -q "if true then return {} end" "$astronvim_astrocore_file"; then
            sed -i '' 's/if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE/-- Activated to configure Python provider/' "$astronvim_astrocore_file"
        fi
        
        # Add Python provider if not already present
        if ! grep -q "python3_host_prog" "$astronvim_astrocore_file"; then
            # Insert Python provider configuration in the g section
            sed -i '' '/g = { -- vim.g.<key>/a\
        python3_host_prog = vim.fn.expand("~/.venvs/astronvim/bin/python3"),
' "$astronvim_astrocore_file"
        fi
    fi

    if ! command_exists npm || ! npm list -g --depth=0 | grep -q "neovim"; then
        npm install -g neovim
    else
        echo "neovim npm package is already installed. Skipping installation."
    fi

    echo "Installing rbenv and Ruby..."
    if ! command_exists rbenv; then
        brew install rbenv ruby-build
    else
        echo "rbenv is already installed. Skipping installation."
    fi

    if [ ! -d "$HOME/.rbenv/versions/3.3.0" ]; then
        rbenv install 3.3.0 # Install a recent stable Ruby version
        rbenv global 3.3.0
    else
        echo "Ruby 3.3.0 is already installed. Skipping installation."
    fi

    brew install perl
    if ! command_exists cpanm; then
        brew install cpanminus
    else
        echo "cpanminus is already installed. Skipping installation."
    fi

    # AstroNvim installation (handled by install_astrovim function)
    # This section is redundant and handled above
}


# --- Main Script ---

# IMPORTANT: This script should be SOURCED, not executed directly.
# Run it with: source ./setup.sh
# This ensures that environment variables (like PATH) are set in your current shell.

# List of files to copy to the home directory.
FILES_TO_COPY=(".bash_profile" ".bashrc" ".bash_aliases" ".bash_functions")

# List of executable scripts to install
SCRIPTS_TO_INSTALL=("kitty-hotkey")

echo "Starting dotfile setup..."

for file in "${FILES_TO_COPY[@]}"; do
  SOURCE_FILE="$DOTFILES_DIR/$file"
  DEST_FILE="$HOME/$file"

  # Check if the source file exists.
  if [ ! -f "$SOURCE_FILE" ]; then
    echo "- WARNING: Source file not found: $SOURCE_FILE. Skipping."
    continue
  fi

  # If a file already exists at the destination, create a backup.
  if [ -f "$DEST_FILE" ]; then
    BACKUP_FILE="$DEST_FILE.bak"
    echo "- Found existing file at $DEST_FILE. Creating backup at $BACKUP_FILE."
    mv "$DEST_FILE" "$BACKUP_FILE"
  fi

  # Copy the new dotfile.
  echo "- Copying $file to $HOME."
  cp "$SOURCE_FILE" "$DEST_FILE"
done

# Install executable scripts
echo "Installing executable scripts..."
mkdir -p "$HOME/bin"

for script in "${SCRIPTS_TO_INSTALL[@]}"; do
  SOURCE_SCRIPT="$DOTFILES_DIR/$script"
  DEST_SCRIPT="$HOME/bin/$script"

  # Check if the source script exists.
  if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "- WARNING: Source script not found: $SOURCE_SCRIPT. Skipping."
    continue
  fi

  # Copy the script and make it executable.
  echo "- Installing $script to $HOME/bin."
  cp "$SOURCE_SCRIPT" "$DEST_SCRIPT"
  chmod +x "$DEST_SCRIPT"
done

install_homebrew
install_lazygit
install_neovim

# Install kitty terminal
if ! command_exists kitty; then
    echo "Installing kitty terminal..."
    brew install --cask kitty
else
    echo "kitty is already installed."
fi

install_lazyvim
install_astrovim

# Initialize rbenv in the current shell context if rbenv is installed
if command_exists rbenv; then
    eval "$(rbenv init -)"
fi

install_dependencies

# Install Ruby gems for Neovim
if command_exists rbenv; then
    echo "Installing neovim Ruby gem..."
    rbenv exec gem install neovim
else
    echo "rbenv not found. Skipping neovim Ruby gem installation. Please install rbenv and Ruby manually if needed."
fi

# Install Perl modules for Neovim
if command_exists cpanm; then
    echo "Installing Neovim Perl modules..."
    # Ensure local::lib is set up for Perl modules
    if [ ! -d "$HOME/perl5" ]; then
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" $(brew --prefix perl)/bin/perl -MCPANM -e 'install local::lib'
        eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
    fi
    cpanm MsgPack::Raw
    cpanm Neovim::Ext
else
    echo "cpanm not found. Skipping Neovim Perl module installation. Please install cpanminus and Perl modules manually if needed."
fi

echo "Setup complete! Please restart your shell or run 'source ~/.bash_profile' to apply the changes."

# Setup kitty hotkey instructions
if command_exists kitty; then
    echo ""
    echo "=== Kitty Hotkey Window Setup ==="
    echo "To set up the kitty hotkey window (like iTerm2's hotkey):"
    echo "1. Run: kitty-hotkey toggle"
    echo "2. To create a system-wide hotkey:"
    echo "   - Open System Preferences > Keyboard > Shortcuts"
    echo "   - Click 'Services' in the left sidebar"
    echo "   - Click '+' to add a new shortcut"
    echo "   - Application: All Applications"
    echo "   - Menu Title: Kitty Hotkey"
    echo "   - Keyboard Shortcut: Cmd+Cmd (or your preferred key)"
    echo "   - Shell Command: $HOME/bin/kitty-hotkey toggle"
    echo "3. Alternatively, you can use: ~/bin/kitty-hotkey toggle"
    echo ""
fi
 
