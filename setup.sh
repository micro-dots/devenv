#!/bin/bash
# -----------------------------------------------------------------------------
# DOTFILES SETUP SCRIPT (Stow-based)
#
# This script sets up a complete development environment using GNU Stow
# for symlink management of dotfiles.
# -----------------------------------------------------------------------------

set -e # Exit immediately if a command exits with a non-zero status.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Helper Functions
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  log_error "This script is currently only supported on macOS"
  exit 1
fi

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log_info "Starting dotfiles setup from: $DOTFILES_DIR"

# Install Homebrew if not present
if ! command_exists brew; then
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  log_success "Homebrew is already installed"
fi

# Install GNU Stow
if ! command_exists stow; then
  log_info "Installing GNU Stow..."
  brew install stow
else
  log_success "GNU Stow is already installed"
fi

# Install essential tools
log_info "Installing essential development tools..."

TOOLS=(
  # Core development
  "git" "neovim" "lazygit" 
  # Modern CLI tools
  "fzf" "ripgrep" "exa" "bat" "zoxide" "fd" "yazi"
  # System tools
  "gdu" "bottom" "htop"
  # Language tools
  "python@3.13" "node" "ruby" "openjdk" "rust" "go"
  # Development dependencies for LazyVim/AstroNvim
  "fish" "ast-grep" "luarocks" "composer" "php" "julia"
  # Document processing
  "ghostscript" "tectonic"
  # Terminal and prompt
  "tmux" "starship"
  # Perl for Neovim provider
  "perl" "cpanminus"
  # Font support
  "fontconfig"
)

for tool in "${TOOLS[@]}"; do
  if ! brew list "$tool" &>/dev/null; then
    log_info "Installing $tool..."
    brew install "$tool"
  else
    log_success "$tool is already installed"
  fi
done

# Install GUI applications
log_info "Installing GUI applications..."
GUI_APPS=("kitty")

for app in "${GUI_APPS[@]}"; do
  if ! brew list --cask "$app" &>/dev/null; then
    log_info "Installing $app..."
    brew install --cask "$app"
  else
    log_success "$app is already installed"
  fi
done

# Install npm packages
if command_exists npm; then
  log_info "Installing global npm packages..."
  npm install -g neovim @mermaid-js/mermaid-cli
fi

# Install rbenv and Ruby setup
if command_exists rbenv; then
  log_info "Setting up Ruby environment..."
  eval "$(rbenv init -)"
  
  if [ ! -d "$HOME/.rbenv/versions/3.3.0" ]; then
    log_info "Installing Ruby 3.3.0..."
    rbenv install 3.3.0
    rbenv global 3.3.0
  else
    log_success "Ruby 3.3.0 already installed"
  fi
  
  log_info "Installing neovim Ruby gem..."
  rbenv exec gem install neovim
else
  log_warning "rbenv not found, installing..."
  brew install rbenv ruby-build
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  log_info "Please restart your shell and run this script again for Ruby setup"
fi

# Install Perl modules for Neovim
if command_exists cpanm; then
  log_info "Installing Neovim Perl modules..."
  
  # Set up local::lib for Perl modules
  if [ ! -d "$HOME/perl5" ]; then
    PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" $(brew --prefix perl)/bin/perl -MCPANM -e 'install local::lib'
    eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
  fi
  
  cpanm MsgPack::Raw
  cpanm Neovim::Ext
else
  log_warning "cpanm not found, Perl modules will not be installed"
fi

# Create Python virtual environments
log_info "Creating Python virtual environments for Neovim..."

PYTHON_VENVS=("nvim" "lazyvim" "astronvim")
for venv in "${PYTHON_VENVS[@]}"; do
  if [ ! -d "$HOME/.venvs/$venv" ]; then
    log_info "Creating Python venv: $venv"
    python3 -m venv "$HOME/.venvs/$venv"
    "$HOME/.venvs/$venv/bin/pip" install pynvim
  else
    log_success "Python venv $venv already exists"
  fi
done

# Initialize rbenv if installed
if command_exists rbenv; then
  eval "$(rbenv init -)"
  if [ ! -d "$HOME/.rbenv/versions/3.3.0" ]; then
    log_info "Installing Ruby 3.3.0..."
    rbenv install 3.3.0
    rbenv global 3.3.0
  fi
  rbenv exec gem install neovim
fi

# Stow dotfiles
log_info "Setting up dotfiles with GNU Stow..."

# Available stow packages
STOW_PACKAGES=(
  "shell"      # Shell configurations (.bashrc, .bash_profile, etc.)
  "starship"   # Starship prompt
  "nvim"       # Default Neovim config
  "lazyvim"    # LazyVim config
  "astronvim"  # AstroNvim config
  "tmux"       # Tmux configuration
  "kitty"      # Kitty terminal config
)

# Backup existing configs
log_info "Backing up existing configurations..."
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="$HOME/.config_backup_$timestamp"

for package in "${STOW_PACKAGES[@]}"; do
  case $package in
    "shell")
      # Backup shell files
      for file in .bashrc .bash_profile .bash_aliases .bash_functions; do
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
          mkdir -p "$backup_dir"
          mv "$HOME/$file" "$backup_dir/"
          log_warning "Backed up $file to $backup_dir/"
        fi
      done
      ;;
    "nvim"|"lazyvim"|"astronvim")
      config_path="$HOME/.config/$package"
      if [ -d "$config_path" ] && [ ! -L "$config_path" ]; then
        mkdir -p "$backup_dir"
        mv "$config_path" "$backup_dir/"
        log_warning "Backed up $config_path to $backup_dir/"
      fi
      ;;
    *)
      config_path="$HOME/.config/$package"
      if [ -d "$config_path" ] && [ ! -L "$config_path" ]; then
        mkdir -p "$backup_dir"
        mv "$config_path" "$backup_dir/"
        log_warning "Backed up $config_path to $backup_dir/"
      fi
      ;;
  esac
done

# Apply stow packages
cd "$DOTFILES_DIR"
for package in "${STOW_PACKAGES[@]}"; do
  if [ -d "$package" ]; then
    log_info "Stowing $package..."
    stow -v "$package"
    log_success "Stowed $package"
  else
    log_warning "Package $package not found, skipping"
  fi
done

# Configure Python providers for each Neovim configuration
log_info "Configuring Python providers for Neovim configurations..."

# Configure default nvim
if [ -f "$HOME/.config/nvim/lua/config/options.lua" ]; then
  if ! grep -q "python3_host_prog.*nvim" "$HOME/.config/nvim/lua/config/options.lua"; then
    echo 'vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/nvim/bin/python3"' >> "$HOME/.config/nvim/lua/config/options.lua"
    log_success "Configured Python provider for default nvim"
  fi
fi

# Configure LazyVim
if [ -f "$HOME/.config/lazyvim/nvim/lua/config/options.lua" ]; then
  if ! grep -q "python3_host_prog.*lazyvim" "$HOME/.config/lazyvim/nvim/lua/config/options.lua"; then
    echo 'vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/lazyvim/bin/python3"' >> "$HOME/.config/lazyvim/nvim/lua/config/options.lua"
    log_success "Configured Python provider for LazyVim"
  fi
fi

# Configure AstroNvim
if [ -f "$HOME/.config/astronvim/nvim/lua/plugins/astrocore.lua" ]; then
  if ! grep -q "python3_host_prog" "$HOME/.config/astronvim/nvim/lua/plugins/astrocore.lua"; then
    # Enable astrocore.lua if it has the blocking line
    if grep -q "if true then return {} end" "$HOME/.config/astronvim/nvim/lua/plugins/astrocore.lua"; then
      sed -i '' 's/if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE/-- Activated to configure Python provider/' "$HOME/.config/astronvim/nvim/lua/plugins/astrocore.lua"
    fi
    
    # Add Python provider configuration in the g section
    sed -i '' '/g = { -- vim.g.<key>/a\
        python3_host_prog = vim.fn.expand("~/.venvs/astronvim/bin/python3"),
' "$HOME/.config/astronvim/nvim/lua/plugins/astrocore.lua"
    log_success "Configured Python provider for AstroNvim"
  fi
fi

# Setup fzf key bindings
if command_exists fzf; then
  $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# Create necessary directories
mkdir -p "$HOME/bin"

# Set up kitty config if it doesn't exist
if [ ! -f "$HOME/.config/kitty/kitty.conf" ]; then
  log_info "Creating kitty configuration..."
  mkdir -p "$HOME/.config/kitty"
  cat > "$HOME/.config/kitty/kitty.conf" << 'EOF'
# Kitty Configuration
font_family FiraCode Nerd Font
font_size 14.0
background_opacity 0.95
window_margin_width 0
window_padding_width 0
hide_window_decorations yes
allow_remote_control yes
listen_on unix:/tmp/mykitty
remember_window_size no
initial_window_width 120c
initial_window_height 40c
EOF
fi

log_success "Dotfiles setup complete!"
log_info "Please restart your shell or run 'source ~/.bash_profile' to apply changes"

# Display next steps
echo
log_info "=== Next Steps ==="
echo "1. Restart your terminal or run: source ~/.bash_profile"
echo "2. Test Neovim configurations:"
echo "   - nvim      (Default Neovim)"
echo "   - lazyvim   (LazyVim configuration)"
echo "   - astrovim  (AstroNvim configuration)"
echo "3. Configure tmux: tmux"
echo "4. Set up kitty hotkey with: kitty-hotkey toggle"
echo
log_success "Happy coding! 🚀"