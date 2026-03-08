# Nix-Based Dotfiles Migration Plan

## Overview

Migrate the existing Makefile + GNU Stow + Shell Scripts dotfiles setup to a Nix-based system using home-manager for declarative, reproducible configuration management across both macOS and Fedora Linux.

## Current State

### Existing Structure
```
dotfiles/
├── Makefile                 # Package installation + stow targets
├── install.sh              # Shell script installer
├── fish/                   # Fish shell config
├── ghostty/               # Ghostty terminal config
├── nvim/                  # Neovim config
├── helix/                 # Helix config
├── wezterm/              # Wezterm config
├── kitty/                # Kitty config
├── opencode/             # Opencode config
├── bat/                  # Bat config
├── procs/                # Procs config
├── lazygit/              # Lazygit config
├── claude/               # Claude config
├── scripts/              # Package management scripts
│   ├── pkg/
│   │   ├── Brewfile
│   │   ├── dnf
│   │   ├── flatpak
│   │   ├── rust
│   │   ├── npm
│   │   └── golang
│   ├── fedora.sh
│   └── macos.sh
└── .stow-local-ignore
```

### Current Features
- 11 stow packages (fish, ghostty, helix, kitty, lazygit, nvim, opencode, procs, wezterm, bat, claude)
- Package installation for macOS (Homebrew) and Fedora (DNF/Flatpak)
- Platform-specific shell scripts

---

## Target Design

### Project Structure

```
dotfiles/
├── nix-alt/                              # Nix configuration
│   ├── flake.nix                        # Main flake entry
│   ├── home/
│   │   └── default.nix                  # Base home-manager config
│   ├── modules/
│   │   ├── common/
│   │   │   ├── packages.nix             # Cross-platform packages
│   │   │   ├── shell.nix               # Fish/zsh, aliases, functions
│   │   │   ├── git.nix                 # Git config
│   │   │   ├── editors.nix             # Neovim, Helix
│   │   │   └── terminal.nix             # Ghostty, WezTerm, Kitty
│   ├── darwin/
│   │   └── packages.nix                 # macOS-specific packages
│   └── linux/
│       └── packages.nix                 # Linux-specific packages
├── hosts/
│   ├── macbook/default.nix               # macOS host config
│   └── desktop/default.nix               # Linux host config
├── Makefile                             # Updated for Nix bootstrapping
├── fish/                                # Keep for reference during migration
├── ghostty/
├── nvim/
├── helix/
├── wezterm/
├── kitty/
├── opencode/
├── bat/
├── procs/
├── lazygit/
├── claude/
└── scripts/                             # Keep for non-Nix package management
```

### Configuration Files

#### flake.nix
```nix
{
  description = "Faizal's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      username = "faizalmusthafa";
    in {
      homeManagerConfigurations = {
        # Linux configuration (x86_64-linux)
        ${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./hosts/desktop ];
 Darwin/macOS        };

        # configuration (x86_64-darwin)
        "${username}-darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          modules = [ ./hosts/macbook ];
        };
      };
    };
}
```

#### hosts/desktop/default.nix
```nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home/default.nix
    ../../modules/common/packages.nix
    ../../modules/common/shell.nix
    ../../modules/common/git.nix
    ../../modules/common/editors.nix
    ../../modules/common/terminal.nix
    ../../modules/linux/packages.nix
  ];

  home.username = "faizalmusthafa";
  home.homeDirectory = "/home/faizalmusthafa";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
```

#### hosts/macbook/default.nix
```nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home/default.nix
    ../../modules/common/packages.nix
    ../../modules/common/shell.nix
    ../../modules/common/git.nix
    ../../modules/common/editors.nix
    ../../modules/common/terminal.nix
    ../../modules/darwin/packages.nix
  ];

  home.username = "faizalmusthafa";
  home.homeDirectory = "/Users/faizalmusthafa";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
```

#### modules/common/shell.nix
```nix
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ../../fish/.config/fish/config.fish;

    plugins = [
      # tide prompt via home-manager
    ];

    functions = {
      # Custom functions
    };

    conf = {
      fish_greeting = "";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
  };
}
```

#### modules/common/packages.nix
```nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core CLI tools
    fish
    zsh
    git
    stow
    fzf
    ripgrep
    bat
    eza
    dust
    procs
    lazygit

    # Dev tools
    nodejs_22
    rustup
    go

    # Editors
    neovim
    helix
  ];
}
```

#### modules/common/terminal.nix
```nix
{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../../ghostty/.config/ghostty/config);
  };

  programs.wezterm = {
    enable = true;
    settings = { };
  };

  programs.kitty = {
    enable = true;
    settings = { };
  };
}
```

#### modules/common/editors.nix
```nix
{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.helix = {
    enable = true;
  };

  xdg.configFile."nvim".source = ../nvim/.config/nvim;
  xdg.configFile."helix".source = ../helix/.config/helix;
}
```

### Makefile Updates

```makefile
OS := $(shell uname -s)

.PHONY: help init install-nix install-home-manager switch \
        home-manager-switch check-nix

help:
	@echo "Available targets:"
	@echo "  make install-nix          - Install Nix package manager"
	@echo "  make install-home-manager - Install home-manager"
	@echo "  make switch               - Full setup (install + switch)"
	@echo "  home-manager-switch       - Switch home-manager config"
	@echo ""
	@echo "Legacy targets (for non-Nix package management):"
	@echo "  make install-all          - Install all packages (OS + language)"
	@echo "  make install-rust         - Install Rust toolchain"
	@echo "  make install-go           - Install Go packages"
	@echo "  make install-npm          - Install NPM packages"
	@echo "  make install-brew         - Install Homebrew packages (macOS)"
	@echo "  make install-fedora       - Install DNF packages (Fedora)"

check-nix:
	@command -v nix > /dev/null || { echo "Error: nix not installed. Run 'make install-nix'"; exit 1; }

install-nix:
	@if [ "$(OS)" = "Darwin" ]; then \
		sh <(curl -L https://nixos.org/nix/install) --daemon; \
	else \
		sh <(curl -L https://nixos.org/nix/install) --daemon; \
	fi

install-home-manager: check-nix
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
	nix-channel --update

switch: install-nix install-home-manager
	@echo "Switching home-manager configuration..."
	nix run home-manager -- switch --flake .#$(USER)

home-manager-switch: check-nix
	nix run home-manager -- switch --flake .#$(USER)

# Legacy package management targets (gradual migration)
install-all: install-$(OS) install-rust install-go install-npm

install-Darwin: install-brew

install-Linux: install-fedora

install-brew:
	@if ! command -v brew > /dev/null; then \
		echo "Installing Homebrew..."; \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@brew update && brew upgrade
	@brew bundle install --file=./scripts/pkg/Brewfile

install-fedora:
	@source ./scripts/pkg/dnf && sudo dnf update --refresh --skip-unavailable -y
	@source ./scripts/pkg/dnf && sudo dnf install --skip-unavailable -y $${dnf_packages[@]}

install-rust:
	@if [ "$(OS)" = "Linux" ] && ! command -v rustup > /dev/null; then \
		rustup-init -y; \
	elif [ "$(OS)" = "Darwin" ]; then \
		rustup default stable; \
	fi
	@source ./scripts/pkg/rust && rustup component add $${rustup_components[@]}
	@source ./scripts/pkg/rust && cargo install $${cargo_packages[@]}

install-go:
	@source ./scripts/pkg/golang && go install $${go_packages[@]}

install-npm:
	@source ./scripts/pkg/npm && npm install -g $${npm_packages[@]}
```

---

## Migration Strategy

### Phase 1: Bootstrap
1. Create `nix-alt/` directory structure
2. Create basic `flake.nix` with home-manager inputs
3. Create `home/default.nix` with base config
4. Enable flakes in Nix config
5. Test: `nix --version`

### Phase 2: Core Shell
1. Migrate fish configuration to `modules/common/shell.nix`
2. Add zsh fallback in same file
3. Use home-manager's fish module (not fisher)
4. Test: `home-manager switch --flake .#faizalmusthafa`
5. Verify shell works on both macOS and Fedora

### Phase 3: Terminals & Editors
1. Migrate terminal configs to `modules/common/terminal.nix`
2. Import nvim/helix configs via `xdg.configFile`
3. Handle Ghostty platform-specific configs (macos.conf vs linux.conf)
4. Verify all terminals and editors work

### Phase 4: Packages
1. Add CLI packages to `modules/common/packages.nix`
2. Add macOS-specific to `modules/darwin/packages.nix`
3. Add Linux-specific to `modules/linux/packages.nix`
4. Keep GUI apps via Homebrew/DNF initially
5. Gradual migration as packages become available in nixpkgs

### Phase 5: Cleanup
1. Remove stow packages as they're migrated
2. Finalize Makefile targets
3. Document the final setup
4. Keep old directories until fully verified

---

## Usage

### Initial Setup (Fresh Machine)
```bash
# Clone dotfiles
git clone https://github.com/faizalmusthafa/dotfiles.git
cd dotfiles

# Bootstrap Nix and switch configuration
make switch
```

### Update Configuration
```bash
# Edit nix-alt/modules/* files
# Then switch to apply changes

# Linux
home-manager switch --flake .#faizalmusthafa

# macOS
home-manager switch --flake .#faizalmusthafa-darwin
```

### Update Channels
```bash
nix-channel --update
home-manager switch --flake .#faizalmusthafa
```

---

## Implementation Status

### Directory Note
> The implementation uses `nix-mm/` instead of `nix-alt/` as the target directory.

### Implemented Components

| Component | Status | File |
|-----------|--------|------|
| flake.nix | ✓ | nix-mm/flake.nix |
| home/default.nix | ✓ | nix-mm/home/default.nix |
| shell.nix (fish + zsh) | ✓ | nix-mm/modules/common/shell.nix |
| git.nix | ✓ | nix-mm/modules/common/git.nix |
| packages.nix | ✓ | nix-mm/modules/common/packages.nix |
| editors.nix | ✓ | nix-mm/modules/common/editors.nix |
| terminal.nix | ✓ | nix-mm/modules/common/terminal.nix |
| darwin/packages.nix | ✓ | nix-mm/modules/darwin/packages.nix |
| linux/packages.nix | ✓ | nix-mm/modules/linux/packages.nix |
| hosts/desktop/default.nix | ✓ | nix-mm/hosts/desktop/default.nix |
| hosts/macbook/default.nix | ✓ | nix-mm/hosts/macbook/default.nix |

### Not Yet Implemented
- Makefile targets for Nix bootstrapping
- agenix/sops for secrets management
- golang/rust/npm tooling modules

---

## Future Tasks

### High Priority

1. **Add nix-darwin integration**
   - Replace standalone home-manager with nix-darwin for macOS
   - Enable system-level configuration (Dock, Finder, etc.)
   - Command: `darwin-rebuild switch --flake .#macbook`

2. **Add secrets management**
   - Integrate agenix or sops-nix for sensitive data
   - Encrypt API keys, tokens, credentials

3. **Complete fish plugin migration**
   - Migrate tide prompt configuration
   - Add fzf integration via home-manager
   - Add enhancd/zoxide integration

### Medium Priority

4. **Add language-specific modules**
   - `modules/common/golang.nix` - Go tooling (gopls, golangci-lint)
   - `modules/common/rust.nix` - Rust tooling (rust-analyzer, clippy)
   - `modules/common/npm.nix` - Node.js tooling

5. **Update Makefile**
   - Add `make install-nix` target
   - Add `make switch` target for home-manager
   - Keep legacy targets for non-Nix package management

6. **Ghostty configuration**
   - Currently uses xdg.configFile import
   - Could use home-manager's native ghostty module with settings

### Low Priority

7. **Complete config imports**
   - claude/.claude/ → xdg.configFile
   - opencode/.config/opencode → xdg.configFile

8. **Add more hosts**
   - Scale to additional machines (work laptop, server, etc.)

9. **CI/CD testing**
   - Add GitHub Actions to test configurations
   - Validate on multiple platforms

10. **Documentation**
    - Create nix-mm/README.md with usage instructions
    - Document troubleshooting steps
    - Migration guide from stow to nix

- **Standalone home-manager** on both macOS and Linux initially (not nix-darwin)
- **Fish shell** is primary, **zsh** is fallback
- **Ghostty** is primary terminal, **WezTerm** and **Kitty** are fallbacks
- Both **Neovim** and **Helix** are kept
- **Home-manager's fish module** for plugins (not fisher)
- **Hybrid package management**: Nix for CLI tools, Homebrew/DNF for GUI apps (gradual migration)
- Platform-specific handling via Nix conditionals for macOS (Darwin) and Fedora (Linux)
- **Later additions** (when ready):
  - Add nix-darwin for macOS system integration
  - Add agenix/sops for secrets management
  - Add more modules (golang, rust, npm tooling)
