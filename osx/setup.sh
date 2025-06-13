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

# List of files to copy to the home directory.
FILES_TO_COPY=(".bash_profile" ".bashrc" ".bash_aliases" ".bash_functions")

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

echo "Setup complete! Please restart your shell or run 'source ~/.bash_profile' to apply the changes." 