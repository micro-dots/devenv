# DevEnv - Cross-Platform Development Environment Setup

A comprehensive, automated setup for modern development environments across macOS, Linux, and Windows platforms.

## Overview

DevEnv provides opinionated, battle-tested configurations for a productive development workflow featuring:

- **Multiple Neovim configurations** running side-by-side (default, LazyVim, AstroNvim)
- **Isolated environments** with proper XDG directory separation
- **Modern terminal tooling** with enhanced productivity features
- **Language-specific setups** with proper provider configuration
- **Cross-platform compatibility** (planned for Linux and Windows)

## Features

### ✨ Neovim Configurations
- **Three isolated setups**: Switch between `nvim`, `lazyvim`, and `astrovim` seamlessly
- **Separate virtual environments**: Independent Python providers for each configuration
- **Complete isolation**: Each config has its own data, cache, state, and plugin directories
- **Zero conflicts**: Run all three configurations without interference

### 🛠 Development Tools
- **Enhanced shell experience** with Starship prompt, fzf, zoxide, and modern CLI tools
- **Language support**: Java, Python, Ruby, Node.js, and more
- **System monitoring**: Integrated tools for disk usage and system performance
- **Terminal multiplexing**: Kitty terminal with hotkey window functionality

### 🎯 Platform Support
- ✅ **macOS** - Complete setup with Homebrew ecosystem
- 🔄 **Linux** - Coming soon
- 🔄 **Windows** - Planned

## Quick Start

### macOS Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/micro-dots/devenv.git
   cd devenv
   ```

2. **Run the setup script:**
   ```bash
   source ./osx/setup.sh
   ```

3. **Start a new terminal session or reload your profile:**
   ```bash
   source ~/.bash_profile
   ```

4. **Test your Neovim configurations:**
   ```bash
   nvim      # Default Neovim
   lazyvim   # LazyVim configuration
   astrovim  # AstroNvim configuration
   ```

## What Gets Installed

### Core Tools
- **Homebrew** - Package manager for macOS
- **Modern shell tools**: `fzf`, `ripgrep`, `exa`, `bat`, `zoxide`
- **Development utilities**: `lazygit`, `gdu`, `bottom`
- **Terminal emulator**: Kitty with hotkey window support

### Language Environments
- **Python**: Separate virtual environments for each Neovim config
- **Ruby**: rbenv with latest stable version
- **Node.js**: Latest LTS with global neovim package
- **Java**: OpenJDK with proper PATH configuration
- **Perl**: CPAN modules for Neovim integration

### Neovim Ecosystem
- **LazyVim**: Modern Neovim configuration with sane defaults
- **AstroNvim**: Community-driven configuration with extensive features
- **TreeSitter**: Language parsers for syntax highlighting
- **LSP support**: Language servers via Mason
- **Fuzzy finding**: Telescope integration

## Directory Structure

```
devenv/
├── osx/                          # macOS-specific setup
│   ├── setup.sh                  # Main setup script
│   ├── .bash_profile             # Shell environment
│   ├── .bashrc                   # Interactive shell config
│   ├── .bash_aliases             # Command shortcuts
│   ├── .bash_functions           # Shell functions
│   ├── kitty-hotkey              # Kitty hotkey script
│   └── starship_shell_template.toml # Prompt configuration
├── CLAUDE.md                     # AI assistant guidance
└── README.md                     # This file
```

## Configuration Locations

After setup, your configurations will be located at:

### Default Neovim
- Config: `~/.config/nvim/`
- Data: `~/.local/share/nvim/`
- Python: `~/.venvs/nvim/`

### LazyVim
- Config: `~/.config/lazyvim/nvim/`
- Data: `~/.local/share/lazyvim/`
- Python: `~/.venvs/lazyvim/`

### AstroNvim
- Config: `~/.config/astronvim/nvim/`
- Data: `~/.local/share/astronvim/`
- Python: `~/.venvs/astronvim/`

## Customization

### Shell Configuration
Customize your shell experience by editing:
- `~/.bash_aliases` - Add your custom aliases
- `~/.bash_functions` - Add custom shell functions
- `~/.config/starship.toml` - Customize your prompt

### Neovim Configurations
Each Neovim configuration can be customized independently:
- **LazyVim**: Follow [LazyVim documentation](https://lazyvim.github.io/)
- **AstroNvim**: Follow [AstroNvim documentation](https://docs.astronvim.com/)

## Troubleshooting

### Health Checks
Run health checks in any Neovim configuration:
```vim
:checkhealth
```

### Plugin Management
Update plugins in LazyVim:
```vim
:Lazy update
```

### Common Issues
- **TreeSitter warnings**: These are usually false positives due to XDG isolation
- **Plugin loading**: Some plugins are lazy-loaded and only appear when needed
- **PATH issues**: Restart your terminal after running the setup script

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Roadmap

- [ ] Linux support (Ubuntu, Fedora, Arch)
- [ ] Windows support (PowerShell, WSL)
- [ ] Docker-based development environments
- [ ] Cloud development environment support
- [ ] Additional language setups (Go, Rust, etc.)

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) - Excellent Neovim configuration
- [AstroNvim](https://github.com/AstroNvim/AstroNvim) - Community-driven Neovim setup
- [Homebrew](https://brew.sh/) - Package management for macOS
- [Starship](https://starship.rs/) - Cross-shell prompt customization

---

**Happy coding!** 🚀