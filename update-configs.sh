#!/bin/bash
# -----------------------------------------------------------------------------
# UPDATE NEOVIM CONFIGURATIONS SCRIPT
#
# This script updates LazyVim and AstroNvim configurations from their upstream
# repositories while preserving local customizations.
# -----------------------------------------------------------------------------

set -e

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

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if we're in the right directory
if [ ! -f "$SCRIPT_DIR/setup.sh" ]; then
  log_error "This script must be run from the devenv repository root"
  exit 1
fi

# Create temporary directory for updates
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

log_info "Starting Neovim configuration updates..."

# Update LazyVim
update_lazyvim() {
  log_info "Updating LazyVim configuration..."
  
  # Clone latest LazyVim starter
  git clone --depth 1 https://github.com/LazyVim/starter "$TMP_DIR/lazyvim-new"
  rm -rf "$TMP_DIR/lazyvim-new/.git"
  
  # Backup current customizations
  local custom_files=(
    "lua/config/options.lua"
    "lua/config/keymaps.lua" 
    "lua/config/autocmds.lua"
    "lua/plugins/"
  )
  
  mkdir -p "$TMP_DIR/lazyvim-backup"
  for file in "${custom_files[@]}"; do
    if [ -e "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim/$file" ]; then
      cp -r "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim/$file" "$TMP_DIR/lazyvim-backup/"
      log_info "Backed up: $file"
    fi
  done
  
  # Replace with new version
  rm -rf "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim"
  mkdir -p "$SCRIPT_DIR/lazyvim/.config/lazyvim"
  mv "$TMP_DIR/lazyvim-new" "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim"
  
  # Restore customizations
  for file in "${custom_files[@]}"; do
    if [ -e "$TMP_DIR/lazyvim-backup/$file" ]; then
      cp -r "$TMP_DIR/lazyvim-backup/$file" "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim/$(dirname "$file")/"
      log_success "Restored: $file"
    fi
  done
  
  # Ensure Python provider is configured
  if ! grep -q "python3_host_prog.*lazyvim" "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim/lua/config/options.lua"; then
    echo 'vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/lazyvim/bin/python3"' >> "$SCRIPT_DIR/lazyvim/.config/lazyvim/nvim/lua/config/options.lua"
  fi
  
  log_success "LazyVim updated successfully"
}

# Update AstroNvim
update_astronvim() {
  log_info "Updating AstroNvim configuration..."
  
  # Clone latest AstroNvim template
  git clone --depth 1 https://github.com/AstroNvim/template "$TMP_DIR/astronvim-new"
  rm -rf "$TMP_DIR/astronvim-new/.git"
  
  # Backup current customizations
  local custom_files=(
    "lua/plugins/astrocore.lua"
    "lua/plugins/astroui.lua"
    "lua/plugins/user.lua" 
    "lua/community.lua"
    "lua/polish.lua"
  )
  
  mkdir -p "$TMP_DIR/astronvim-backup"
  for file in "${custom_files[@]}"; do
    if [ -e "$SCRIPT_DIR/astronvim/.config/astronvim/nvim/$file" ]; then
      cp -r "$SCRIPT_DIR/astronvim/.config/astronvim/nvim/$file" "$TMP_DIR/astronvim-backup/"
      log_info "Backed up: $file"
    fi
  done
  
  # Replace with new version
  rm -rf "$SCRIPT_DIR/astronvim/.config/astronvim/nvim"
  mkdir -p "$SCRIPT_DIR/astronvim/.config/astronvim"
  mv "$TMP_DIR/astronvim-new" "$SCRIPT_DIR/astronvim/.config/astronvim/nvim"
  
  # Restore customizations
  for file in "${custom_files[@]}"; do
    if [ -e "$TMP_DIR/astronvim-backup/$file" ]; then
      cp -r "$TMP_DIR/astronvim-backup/$file" "$SCRIPT_DIR/astronvim/.config/astronvim/nvim/$(dirname "$file")/"
      log_success "Restored: $file"
    fi
  done
  
  # Ensure Python provider is configured in astrocore.lua
  local astrocore_file="$SCRIPT_DIR/astronvim/.config/astronvim/nvim/lua/plugins/astrocore.lua"
  if [ -f "$astrocore_file" ]; then
    # Enable astrocore.lua if it has the blocking line
    if grep -q "if true then return {} end" "$astrocore_file"; then
      sed -i '' 's/if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE/-- Activated to configure Python provider/' "$astrocore_file"
    fi
    
    # Add Python provider if not present
    if ! grep -q "python3_host_prog" "$astrocore_file"; then
      sed -i '' '/g = { -- vim.g.<key>/a\
        python3_host_prog = vim.fn.expand("~/.venvs/astronvim/bin/python3"),
' "$astrocore_file"
    fi
  fi
  
  log_success "AstroNvim updated successfully"
}

# Main execution
case "${1:-all}" in
  "lazyvim")
    update_lazyvim
    ;;
  "astronvim")
    update_astronvim
    ;;
  "all")
    update_lazyvim
    update_astronvim
    ;;
  *)
    echo "Usage: $0 {lazyvim|astronvim|all}"
    echo "  lazyvim   - Update only LazyVim configuration"
    echo "  astronvim - Update only AstroNvim configuration" 
    echo "  all       - Update both configurations (default)"
    exit 1
    ;;
esac

log_success "Configuration updates completed!"
log_info "Next steps:"
echo "1. Review the changes: git diff"
echo "2. Test the configurations: lazyvim, astrovim"
echo "3. Commit the updates: git add . && git commit -m 'feat: update upstream configs'"
echo "4. Restow if needed: stow lazyvim astronvim"