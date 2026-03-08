# Nix-Based Dotfiles

This directory contains the Nix-based configuration for managing dotfiles across macOS and Fedora Linux using nix-darwin and home-manager.

## Configuration Decisions

- **nixpkgs branch**: `unstable` (latest packages, updated frequently)
- **Secrets management**: `sops-nix` with age encryption (supports age, GPG, AWS KMS)
- **Additional packages**: `nixpkgs-wayland` included for Wayland support

## Quick Start

### Prerequisites

1. **Install Nix** with flakes enabled:
   ```bash
   # Enable flakes
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. **Install sops** for secrets management (optional, for Phase 8+):
   ```bash
   nix-shell -p sops
   ```

### macOS (Darwin)

1. **Bootstrap nix-darwin**:
   ```bash
   nix run nix-darwin -- switch --flake .#macbook
   ```

2. **Update configuration**:
   ```bash
   darwin-rebuild switch --flake .#macbook
   ```

3. **Dry-run** (test without applying):
   ```bash
   darwin-rebuild dry-activate --flake .#macbook
   ```

### Linux (Fedora)

1. **Bootstrap home-manager**:
   ```bash
   nix run home-manager -- switch --flake .#faizalmusthafa@desktop
   ```

2. **Update configuration**:
   ```bash
   home-manager switch --flake .#faizalmusthafa@desktop
   ```

3. **Dry-run** (test without applying):
   ```bash
   home-manager switch --flake .#faizalmusthafa@desktop --dry-run
   ```

## Directory Structure

```
nix/
├── flake.nix                      # Main flake entry point
├── README.md                      # This file
├── modules/
│   ├── common/                    # Shared Home Manager modules
│   │   ├── packages.nix           # Cross-platform packages
│   │   ├── git.nix                # Git configuration
│   │   ├── golang.nix             # Go tooling
│   │   ├── shell.nix              # Shell aliases, functions
│   │   ├── editors.nix            # Neovim, Helix configs
│   │   └── terminal.nix           # Terminal emulators
│   ├── darwin/                    # macOS-specific modules
│   │   ├── packages.nix           # macOS-only packages
│   │   ├── homebrew.nix           # Homebrew integration
│   │   ├── system.nix             # macOS system defaults
│   │   └── platform.nix           # Platform-specific configs
│   └── linux/                     # Linux-specific modules
│       ├── packages.nix           # Linux-only packages
│       ├── gnome.nix              # GNOME settings
│       ├── dconf.nix              # dconf configuration
│       └── flatpak.nix            # Flatpak integration
├── packages/
│   ├── overlays/                  # Custom nixpkgs overlays
│   └── custom/                    # Custom package definitions
├── hosts/
│   ├── macbook/                   # macOS laptop configuration
│   │   └── default.nix
│   └── desktop/                   # Fedora desktop configuration
│       └── default.nix
├── home/
│   └── default.nix                # Base home-manager configuration
└── secrets/                       # Secrets management (sops-nix)
    └── secrets.nix
```

## Building Without Activating

### macOS
```bash
nix build .#darwinConfigurations.macbook.system
```

### Linux
```bash
nix build .#homeConfigurations.faizalmusthafa@desktop.activationPackage
```

## Rollback

If issues arise:

### macOS
```bash
darwin-rebuild switch --rollback
```

### Linux
```bash
home-manager switch --rollback
```

## Updating Dependencies

Update flake inputs:
```bash
nix flake update
```

Then switch to apply updates:
```bash
# macOS
darwin-rebuild switch --flake .#macbook

# Linux
home-manager switch --flake .#faizalmusthafa@desktop
```

## Development

Enter development shell with Nix tools:
```bash
nix develop
```

This provides `nixpkgs-fmt` and `rnix-lsp` for Nix file editing.

## Migration Status

This Nix configuration is being phased in alongside the existing Makefile + GNU Stow setup. See the comprehensive migration plan at `../docs/plan/nix-plan-glm.md` for details.

Current phase: **Phase 1: Foundation Setup** (in progress)

## Contributing

When adding new configurations:
1. Use modular structure (separate files for each concern)
2. Prefer `programs.*` modules over `xdg.configFile` when available
3. Keep platform-specific configs in appropriate modules (darwin/ or linux/)
4. Test on both platforms if possible
5. Document any non-obvious package mappings

## Troubleshooting

### Flakes not enabled
Add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### Build fails
Try a dry-run to see what would change:
```bash
# macOS
darwin-rebuild dry-activate --flake .#macbook

# Linux
home-manager switch --flake .#faizalmusthafa@desktop --dry-run
```

### Secrets not decrypting
Ensure `sops` is installed and your encryption key is configured in `secrets/.sops.yaml`.

## See Also

- [Main Migration Plan](../docs/plan/nix-plan-glm.md)
- [nix-darwin Documentation](https://github.com/LnL7/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
