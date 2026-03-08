# Nix Migration Plan

## Overview

This plan outlines the migration from the current Makefile + GNU Stow + shell scripts setup to a Nix-based reproducible environment system. The new system will coexist with the existing setup in the `nix/` directory, allowing gradual migration and testing.

**Consolidated Approach**: This plan was created by merging nix-plan-mm.md and nix-plan-glm.md, combining the modular architecture and nix-darwin integration from the glm plan with the app-by-app migration phases from the mm plan.

## Configuration Decisions

The following configuration decisions have been made for this implementation:

- **nixpkgs branch**: `unstable` (latest packages, updated frequently)
- **Secrets management**: `sops-nix` with age encryption (supports age, GPG, AWS KMS)
- **Additional packages**: `nixpkgs-wayland` included for Wayland support
- **Flake description**: To be updated by user

## Goals

- **Reproducible environment across all machines**: Same packages, versions, and configs on macOS and Fedora using nix-darwin + home-manager
- **Declarative configuration management**: Replace imperative shell scripts with declarative Nix expressions
- **Side-by-side deployment**: Keep both configs together; Nix-related configs will be in `nix/` folder
- **Layered package approach**: Nix manages as much as possible, with intelligent fallback to native package managers
- **Home Manager for configs**: Use Home Manager's `xdg.configFile` instead of GNU Stow for all app configurations
- **Common modules architecture**: Shared config in common modules, platform-specific in separate files
- **Modern flake-based workflow**: Use Nix Flakes for reproducible builds and declarative inputs
- **Native fallback**: Use Homebrew/DNF/Flatpak for unavailable packages
- **External secrets management**: Use sops-nix with age-encrypted secrets

## Current Setup Analysis

### Directory Structure
```
dotfiles/
├── bat/.config/
├── claude/.claude/
├── fish/.config/fish/
├── ghostty/.config/ghostty/
├── helix/.config/helix/
├── kitty/.config/kitty/
├── lazygit/.config/lazygit/
├── nvim/.config/nvim/
├── opencode/.config/opencode/
├── procs/.config/procs/
├── wezterm/.config/wezterm/
├── Makefile
├── install.sh
├── scripts/
│   ├── pkg/
│   │   ├── Brewfile (100 lines)
│   │   ├── dnf (69 packages)
│   │   ├── flatpak (21 packages)
│   │   ├── golang (3 packages)
│   │   ├── npm (minimal)
│   │   └── rust (3 cargo packages)
│   ├── macos.sh
│   └── fedora.sh
└── .stow-local-ignore
```

### Package Inventory

**macOS (Homebrew):**
- CLI tools: bat, eza, fd, fzf, gh, git, lazygit, neovim, procs, ripgrep, tmux, zoxide, etc.
- Dev tools: go, golangci-lint, node, rustup, etc.
- GUI apps: ghostty, obsidian, logseq, karabiner-elements, wezterm, etc.
- Casks: alt-tab, audacity, gimp, iina, visual-studio-code, etc.

**Fedora (DNF):**
- CLI tools: bat, eza, fd-find, fish, fzf, git, lazygit, neovim, etc.
- Dev tools: golang, nodejs, rust, etc.
- GUI: helix, wezterm, etc.

**Language Packages:**
- Rust: selene, stylua, eza
- Go: cue, golangci-lint-langserver, goimports
- NPM: minimal

**Flatpak (Fedora):**
- be.alexandervanhee.gradia, com.bitwarden.desktop, com.github.johnfactotum.Foliate, etc.

## New Architecture

### Directory Structure

```
nix/
├── flake.nix                      # Main flake entry point
├── README.md                      # Usage documentation
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
│   │   └── default.nix
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

## Component Design

### Flake Configuration (`flake.nix`)

**Inputs:**
- `nixpkgs`: Unstable branch (latest packages, updated frequently)
- `nix-darwin`: macOS system configuration
- `home-manager`: User environment management
- `nixpkgs-wayland`: Additional packages (included)
- `sops-nix`: Secrets encryption with age/GPG/AWS KMS support
- Optional: Community flakes for specific packages

**Outputs:**
- `darwinConfigurations`: macOS system profiles (nix-darwin)
- `homeConfigurations`: Linux/Home Manager configurations
- `devShells`: Development shell with Nix tools

**Darwin Integration:**
- Home Manager as nix-darwin module
- Combined system + user configuration
- Activation via `darwin-rebuild switch --flake .#<hostname>`

**Linux Integration:**
- Standalone home-manager configuration
- Activation via `home-manager switch --flake .#<user>@<hostname>`

**Overlays:**
- Custom package definitions
- Package version overrides
- Cross-platform consistency

### Home Manager Configuration

**Base Configuration (`nix/home/default.nix`):**
- User settings (username, home directory)
- State version
- Common imports (shell, git, editors, etc.)

**Configuration Migration from Stow:**

| Current Stow Module | Home Manager Approach |
|---------------------|----------------------|
| `nvim/` | `programs.neovim` with `extraConfig` or `xdg.configFile` |
| `helix/` | `programs.helix` or `xdg.configFile` |
| `fish/` | `programs.fish` with shellInit, functions, aliases |
| `ghostty/` | `xdg.configFile."ghostty".source` |
| `kitty/` | `xdg.configFile."kitty".source` |
| `lazygit/` | `xdg.configFile."lazygit".source` |
| `bat/` | `programs.bat` |
| `procs/` | `xdg.configFile."procs".source` |
| `wezterm/` | `xdg.configFile."wezterm".source` |
| `claude/` | `xdg.configFile."claude".source` |
| `opencode/` | `xdg.configFile."opencode".source` |

**Fish Shell Migration:**
- `fish/.config/fish/config.fish` → `programs.fish.shellInit`
- `fish/.config/fish/aliases.fish` → `programs.fish.shellAliases`
- `fish/.config/fish/functions/` → `programs.fish.functions`
- `fish/.config/fish/conf.d/` → `programs.fish.interactiveShellInit`

**Platform-Specific Configs:**
- Ghostty: Conditional linking of `macos.conf` vs `linux.conf`
- Wezterm: Platform-specific config paths
- Terminal emulators: Platform-specific behavior

### Package Management Strategy

**Layered Approach:**
1. **Nix packages** (primary): Everything available in nixpkgs
2. **Native fallback**: Packages not available in nixpkgs
3. **Manual override**: Packages requiring special handling

**Module Structure:**
```
nix/modules/common/packages.nix    # All platforms
nix/modules/darwin/packages.nix    # macOS only
nix/modules/linux/packages.nix     # Linux only
```

**Language Packages:**
```nix
# Rust
{
  programs.rust.enable = true;
  home.packages = with pkgs; [
    selene
    stylua
    eza
  ];
}

# Go
{
  programs.go.enable = true;
  home.packages = with pkgs.goPackages; [
    cue
    gopls
  ];
}

# NPM
{
  home.packages = with pkgs.nodePackages; [
    # npm packages
  ];
}
```

**Native Package Manager Integration:**

macOS (via nix-darwin):
```nix
{
  homebrew = {
    enable = true;
    brews = [ ... ];    # Homebrew formulae
    casks = [ ... ];    # GUI applications
  };
}
```

Linux (via scripts):
```nix
{
  # Flatpak packages via activation scripts
  home.activation.flatpakPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
    flatpak install flathub com.bitwarden.desktop ...
  '';
}
```

### Secrets Management

**Approach:** Use sops-nix for encrypted secrets (age/GPG/AWS KMS support)

**Integration:**
```nix
{
  imports = [ ./secrets/secrets.nix ];
  sops.secrets.api-key = {
    format = "yaml";
    sopsFile = ./secrets/secrets.yaml;
  };
}
```

**Secrets to manage:**
- API keys (GitHub, cloud services)
- Authentication tokens
- Sensitive configuration
- Credentials

**Encryption methods supported:**
- age (recommended for simplicity)
- GPG
- AWS KMS
- Azure Key Vault

## Implementation Phases

### Phase 1: Foundation Setup (4 tasks)

**Tasks:**
1. Create `nix/` directory structure
2. Create `flake.nix` with proper inputs and outputs
3. Set up Git attributes for Nix files
4. Create `.gitignore` for Nix artifacts

**Files to create:**
- `nix/flake.nix`
- `nix/.gitignore`
- `nix/README.md`

**Commands:**
```bash
mkdir -p nix/{modules/{common,darwin,linux},packages/{overlays,custom},hosts/{macbook,desktop},home,secrets}
```

**Flake Outputs Structure:**
```nix
outputs = { self, nixpkgs, darwin, home-manager, sops-nix, ... }:
  let
    inherit (self) inputs;
    system = "aarch64-darwin";  # or x86_64-linux
    pkgs = import nixpkgs { inherit system; };
  in {
    # macOS: nix-darwin with Home Manager module
    darwinConfigurations = {
      macbook = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/macbook/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.users.faizalmusthafa = import ./home/default.nix;
          }
        ];
      };
    };

    # Linux: Standalone Home Manager
    homeConfigurations = {
      "faizalmusthafa@desktop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/default.nix ./hosts/desktop/default.nix ];
      };
    };
  };
```

### Phase 2: Home Manager Base (4 tasks)

**Tasks:**
1. Create `nix/home/default.nix` with base configuration
2. Migrate Fish shell to `programs.fish` module (full migration, no builtins.readFile)
3. Create common modules for git, golang
4. Set up base shell configuration

**Files to create:**
- `nix/home/default.nix`
- `nix/modules/common/shell.nix` (full fish migration with shellInit, aliases, functions)
- `nix/modules/common/git.nix`
- `nix/modules/common/golang.nix`

**Fish Shell Full Migration Example:**
```nix
{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx fish_greeting ""
      set -gx EDITOR nvim
    '';
    shellAliases = {
      ll = "eza -la";
      gs = "git status";
      gc = "git commit";
    };
    functions = {
      mkcd = ''
        mkdir -p $argv[1] && cd $argv[1]
      '';
      gitclean = ''
        git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
      '';
    };
    plugins = [
      # tide, fisher plugins managed here
    ];
  };
}
```

### Phase 3: Package Migration (6 tasks)

**Tasks:**
1. Audit all current packages
2. Create simple per-module package lists (no complex spreadsheet)
3. Implement module-level package lists
4. Set up language-specific tooling
5. Create native fallback mechanism
6. Test package availability on both platforms

**Files to create:**
- `nix/modules/common/packages.nix`
- `nix/modules/darwin/packages.nix`
- `nix/modules/darwin/homebrew.nix`
- `nix/modules/linux/packages.nix`
- `nix/modules/linux/flatpak.nix`
- `nix/modules/common/rust.nix`
- `nix/modules/common/go.nix`
- `nix/modules/common/npm.nix`

**Package Module Structure:**
```nix
# Common packages (all platforms)
{
  home.packages = with pkgs; [
    bat eza fd fzf ripgrep git lazygit procs tmux zoxide
  ];
}

# macOS-only with Homebrew fallback
{
  home.packages = with pkgs; [ ... ];
  homebrew = {
    enable = true;
    brews = [ ... ];
    casks = [ ghostty wezterm ... ];
  };
}

# Linux-only with Flatpak fallback
{
  home.packages = with pkgs; [ ... ];
  home.activation.flatpakPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
    flatpak install flathub com.bitwarden.desktop ...
  '';
}
```

### Phase 4: Terminal Migration (5 tasks) ← App-by-App Approach

**Tasks:**
1. Migrate Ghostty config to terminal.nix with platform conditionals
2. Implement Ghostty platform.conf linking (macos.conf vs linux.conf)
3. Migrate Wezterm config
4. Migrate Kitty config
5. Test all terminals on both platforms

**Files to create:**
- `nix/modules/common/terminal.nix`

**Ghostty Platform-Specific Handling:**
```nix
{ pkgs, lib, ... }:
{
  xdg.configFile."ghostty/config".text = lib.concatStrings [
    ''
      # Common config
      font-size = 14
      ${lib.optionalString pkgs.stdenv.isDarwin ''
      # macOS-specific
      include-config = ${pkgs.ghostty}/share/ghostty/macos.conf
      ''}
      ${lib.optionalString pkgs.stdenv.isLinux ''
      # Linux-specific
      include-config = ${pkgs.ghostty}/share/ghostty/linux.conf
      ''}
    ''
  ];
}
```

### Phase 5: Editor Migration (3 tasks) ← App-by-App Approach

**Tasks:**
1. Migrate Neovim config (xdg.configFile or extraConfig, not builtins.readFile)
2. Migrate Helix config
3. Test both editors

**Files to create:**
- `nix/modules/common/editors.nix`

### Phase 6: Tool Configs Migration (4 tasks) ← App-by-App Approach

**Tasks:**
1. Migrate bat, procs, lazygit, claude, opencode configs using xdg.configFile
2. Test functionality of each tool
3. Verify configs work identically to stow setup
4. Keep old configs side-by-side for comparison

**Files to create:**
- `nix/modules/common/tools.nix`

### Phase 7: Platform Integration (5 tasks)

**Tasks:**
1. Create nix/hosts/macbook/default.nix (nix-darwin)
2. Create nix/hosts/desktop/default.nix (home-manager)
3. Set up macOS system defaults, fonts, launchd services
4. Set up Linux GNOME/dconf settings
5. Configure platform-specific environment variables

**Files to create:**
- `nix/hosts/macbook/default.nix`
- `nix/hosts/desktop/default.nix`
- `nix/modules/darwin/system.nix`
- `nix/modules/linux/gnome.nix`
- `nix/modules/linux/dconf.nix`

### Phase 8: Secrets Management (4 tasks)

**Tasks:**
1. Create nix/secrets/ directory structure
2. Identify secrets to migrate from old configs
3. Set up sops-nix with age encryption
4. Test secret access and decryption

**Files to create:**
- `nix/secrets/secrets.nix`
- `nix/secrets/.sops.yaml` - Sops configuration file
- `nix/secrets/secrets.yaml` - Encrypted secrets (will be .age files)

**Secrets Integration:**
```nix
{
  imports = [ ./secrets/secrets.nix ];
  sops.secrets.api-key = {
    format = "yaml";
    sopsFile = ./secrets/secrets.yaml;
  };
}
```

### Phase 9: Testing & Verification (8 tasks)

**Tasks:**
1. Test macOS: darwin-rebuild switch --flake .#macbook
2. Test Linux: home-manager switch --flake .#<user>@<desktop>
3. Verify all packages installed correctly
4. Verify all configs work identically to stow setup
5. Test rollback functionality
6. Run comprehensive verification checklist
7. Compare with stow setup side-by-side
8. Document any issues encountered

**Test commands:**
```bash
# macOS
darwin-rebuild switch --flake .#macbook
darwin-rebuild dry-activate --flake .#macbook

# Linux
home-manager switch --flake .#<user>@<hostname>

# Build without activating
nix build .#darwinConfigurations.macbook.system
nix build .#homeConfigurations.<user>@<hostname>.activationPackage
```

**Verification checklist:**
- [ ] Neovim configuration loads correctly
- [ ] Fish shell has all aliases/functions
- [ ] Terminal emulators (ghostty, kitty, wezterm) work
- [ ] Git configuration is correct
- [ ] All CLI tools installed and functional
- [ ] GUI apps installed (macOS)
- [ ] Flatpak apps installed (Linux)
- [ ] Secrets accessible and working
- [ ] Platform-specific configs applied correctly

### Phase 10: Documentation & Cleanup (5 tasks)

**Tasks:**
1. Update nix/README.md with full usage instructions
2. Create MIGRATION.md from Makefile
3. Document troubleshooting steps
4. Update root README to mention Nix setup
5. Create quickstart guide for new machines

**Files to create/modify:**
- `nix/README.md`
- `nix/MIGRATION.md`
- `nix/QUICKSTART.md`
- `README.md` (root - mention Nix setup)
- `docs/troubleshooting.md`

## Files to Keep vs Remove During Migration

### Keep Until Fully Migrated
- `Makefile` - Legacy install targets for reference
- `install.sh` - Keep for bootstrap
- `.stow-local-ignore` - Keep until all configs migrated
- All stow packages: `fish/`, `ghostty/`, `helix/`, `kitty/`, `nvim/`, `bat/`, `procs/`, `lazygit/`, `claude/`, `opencode/`
- `scripts/` - Keep for non-Nix package management reference
- `scripts/pkg/` - Keep for package lists until fully migrated

### Remove After Verification
- Old configs after each phase completes successfully
- Stow setup after Phase 9 verification passes
- Makefile legacy targets after Phase 10 documentation complete
- Scripts directory after all packages managed by Nix

### Never Remove
- Git history (commit often!)
- Backup of critical configs
- Any secrets (handled by sops-nix)

## Migration Commands

### Initial Setup

```bash
# Enable flakes (if not already)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# On macOS - Install nix-darwin
nix run nix-darwin -- switch --flake .#macbook

# On Linux - Install home-manager
nix run home-manager/master -- switch --flake .#<user>@<hostname>
```

### Updating Configuration

```bash
# macOS
darwin-rebuild switch --flake .#macbook

# Linux
home-manager switch --flake .#<user>@<hostname>
```

### Building without activating

```bash
# macOS
nix build .#darwinConfigurations.macbook.system

# Linux
nix build .#homeConfigurations.<user>@<hostname>.activationPackage
```

## Makefile Integration

**Simplified targets for easy Nix management:**
```makefile
.PHONY: nix-switch nix-build nix-rollback nix-test nix-update

nix-switch:
	@if [ "$(shell uname -s)" = "Darwin" ]; then \
		darwin-rebuild switch --flake .#macbook; \
	else \
		home-manager switch --flake .#$${USER}@$(shell hostname); \
	fi

nix-build:
	@if [ "$(shell uname -s)" = "Darwin" ]; then \
		nix build .#darwinConfigurations.macbook.system; \
	else \
		nix build .#homeConfigurations.$${USER}@$(shell hostname).activationPackage; \
	fi

nix-rollback:
	@if [ "$(shell uname -s)" = "Darwin" ]; then \
		darwin-rebuild switch --rollback; \
	else \
		home-manager switch --rollback; \
	fi

nix-test:
	@if [ "$(shell uname -s)" = "Darwin" ]; then \
		darwin-rebuild dry-activate --flake .#macbook; \
	else \
		home-manager switch --flake .#$${USER}@$(shell hostname) --dry-run; \
	fi

nix-update:
	nix flake update
	@$(MAKE) nix-switch

# Keep legacy targets for reference until migration complete
install-all: install-$(OS) install-rust install-go install-npm
install-Darwin: install-brew
install-Linux: install-fedora
```

## Rollback Plan

If issues arise during migration:

1. **Quick rollback to old system:**
   ```bash
   # macOS
   darwin-rebuild switch --rollback

   # Linux
   home-manager switch --rollback
   ```

2. **Restore stow setup:**
   ```bash
   make stow
   ```

3. **Disable Nix configs:**
   - Remove nix-darwin entry from macOS
   - Delete home-manager generations

## Consolidated Plan Decisions

This plan combines the best of two approaches:

### Architectural Decisions

| Decision | Source | Rationale |
|----------|--------|-----------|
| **Modular directory structure** | Original glm plan | Scales better, separates common/darwin/linux concerns |
| **nix-darwin for macOS** | Original glm plan | Essential for system packages, fonts, daemons |
| **App-by-app migration phases** | Original mm plan | Clearer progress, easier to test each component |
| **xdg.configFile + Home Manager modules** | Original glm plan | Truly declarative, no dual-management |
| **Secrets with sops-nix** | Consolidated | Secure encrypted secrets with age/GPG/AWS KMS support |
| **nixpkgs unstable** | Consolidated | Latest packages, updated frequently |
| **nixpkgs-wayland** | Consolidated | Additional packages for Wayland support |
| **Full fish module migration** | Original glm plan | Better ergonomics, no builtins.readFile |
| **Conditional Ghostty handling** | Original glm plan | Solves platform.conf linking problem |
| **Simplified Makefile targets** | Original mm plan | Easier initial bootstrap |
| **10 phases instead of 7** | Consolidated | More granular, easier to track progress |

### Rejected Approaches

❌ **Flat file reading**: `builtins.readFile ../fish/.config/fish/config.fish`
- Replacement: Full `programs.fish` module migration
- Why: Declarative, no dual-management, rebuilds on config change

❌ **4 duplicate home-manager configs**: Same user for different architectures
- Replacement: One config per host (macbook, desktop)
- Why: Redundant, unnecessary complexity

❌ **Standalone home-manager on macOS**
- Replacement: nix-darwin + home-manager module
- Why: System-level packages (fonts, daemons, defaults)

❌ **All configs at once**
- Replacement: Migrate terminals → editors → tools sequentially
- Why: Reduce complexity, easier debugging

## Success Criteria

- [ ] All packages from current setup are managed by Nix or native fallback
- [ ] All configurations work identically to stow setup
- [ ] Reproducible builds on both macOS and Fedora
- [ ] Secrets management integrated and working
- [ ] No data loss during migration
- [ ] Documentation complete and accurate
- [ ] Rollback plan tested and verified

## Future Considerations

1. **NixOS Migration:** Consider full NixOS migration for Fedora
2. **Additional Hosts:** Scale to new machines easily
3. **Continuous Integration:** Test configurations in CI
4. **Performance:** Optimize build times and evaluation
5. **Community Sharing:** Share modules/flake if useful to others
6. **Automated Updates:** Periodic nixpkgs updates and testing

## Notes

- Keep existing Makefile and stow setup until Nix setup is verified
- Gradual migration allows testing per module
- Commit early and often with clear commit messages
- Document any non-obvious package mappings or configurations
- Consider version pinning for production stability
- This consolidated plan was created by merging nix-plan-mm.md and nix-plan-glm.md to combine their strengths
- No builtins.readFile for configs - use Home Manager's native modules for declarative management
- Platform-specific configs (like Ghostty) use lib.optionalString for conditional handling
- Secrets are managed with sops-nix using age encryption
- All changes are testable before activation using dry-run flags
