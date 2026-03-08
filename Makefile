OS := $(shell uname -s)

.PHONY: help init stow check-stow \
        stow-ghostty stow-bat stow-claude stow-helix stow-kitty \
        stow-lazygit stow-opencode stow-nvim stow-procs stow-wezterm \
        install-all install-rust install-go install-npm \
        install-Darwin install-Linux install-xcode install-brew \
        install-fedora install-dnf install-flatpak \
        configure-firefox configure-golang configure-fonts \
        configure-k8s configure-logseq configure-zoxide

help:
	@echo "Available targets:"
	@echo "  make init            - Full first-time setup (packages + stow)"
	@echo "  make stow            - Stow all dotfiles"
	@echo "  make stow-nvim       - Stow Neovim config"
	@echo "  make stow-helix      - Stow Helix config"
	@echo "  make stow-ghostty    - Stow Ghostty config"
	@echo "  make stow-kitty      - Stow Kitty config"
	@echo "  make stow-lazygit    - Stow Lazygit config"
	@echo "  make stow-opencode   - Stow Opencode config"
	@echo "  make stow-bat        - Stow Bat config"
	@echo "  make stow-claude     - Stow Claude config"
	@echo "  make stow-procs      - Stow Procs config"
	@echo "  make stow-wezterm    - Stow Wezterm config"
	@echo ""
	@echo "  make install-all     - Install all packages (OS + language)"
	@echo "  make install-rust    - Install Rust toolchain and cargo packages"
	@echo "  make install-go      - Install Go packages"
	@echo "  make install-npm     - Install NPM packages"
	@echo "  make install-dnf     - Install DNF packages (Fedora)"
	@echo "  make install-flatpak - Install Flatpak packages (Fedora)"
	@echo "  make install-brew    - Install Homebrew packages (macOS)"
	@echo "  make install-xcode   - Install Xcode CLT (macOS)"
	@echo ""
	@echo "Configuration targets:"
	@echo "  configure-firefox   - Firefox configuration"
	@echo "  configure-golang    - Golang configuration"
	@echo "  configure-fonts     - Fonts configuration"
	@echo "  configure-k8s       - Kubernetes configuration"
	@echo "  configure-logseq    - Logseq configuration"
	@echo "  configure-zoxide    - Zoxide configuration"

init: install-all stow

check-stow:
	@command -v stow > /dev/null || { echo "Error: stow not installed"; exit 1; }

stow: check-stow stow-ghostty stow-bat stow-claude stow-helix stow-kitty \
          stow-lazygit stow-opencode stow-nvim stow-procs stow-wezterm

stow-ghostty: check-stow
	stow ghostty
	@if [ "$(OS)" = "Darwin" ]; then \
		ln -sfn macos.conf ~/.config/ghostty/platform.conf; \
	else \
		ln -sfn linux.conf ~/.config/ghostty/platform.conf; \
	fi

stow-bat: check-stow
	stow bat

stow-claude: check-stow
	stow claude

stow-helix: check-stow
	stow helix

stow-kitty: check-stow
	stow kitty

stow-lazygit: check-stow
	stow lazygit

stow-opencode: check-stow
	stow opencode

stow-nvim: check-stow
	stow nvim

stow-procs: check-stow
	stow procs

stow-wezterm: check-stow
	stow wezterm

install-all: install-$(OS) install-rust install-go install-npm

install-Darwin: install-xcode install-brew

install-Linux: install-fedora

install-xcode:
	@if ! xcode-select -p &>/dev/null; then \
		echo "Installing Xcode Command Line Tools..."; \
		xcode-select --install; \
	fi

install-brew:
	@if ! command -v brew > /dev/null; then \
		echo "Installing Homebrew..."; \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Installing Homebrew packages..."
	@brew update && brew upgrade
	@brew bundle install --file=./scripts/pkg/Brewfile

install-fedora: install-dnf install-flatpak

install-dnf:
	@echo "Installing DNF packages..."
	@source ./scripts/pkg/dnf && sudo dnf update --refresh --skip-unavailable -y
	@source ./scripts/pkg/dnf && sudo dnf install --skip-unavailable -y $${dnf_packages[@]}

install-flatpak:
	@echo "Installing Flatpak packages..."
	@flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	@flatpak update -y
	@source ./scripts/pkg/flatpak && flatpak install flathub $${flatpak_packages[@]} -y

install-rust:
	@if [ "$(OS)" = "Linux" ] && ! command -v rustup > /dev/null; then \
		echo "Installing Rust..."; \
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

configure-firefox:
	@echo "Firefox configuration (placeholder)"

configure-golang:
	@echo "Golang configuration (placeholder)"

configure-fonts:
	@echo "Fonts configuration (placeholder)"

configure-k8s:
	@echo "Installing kind..."
	@# kind install command to be added

configure-logseq:
	@echo "Logseq configuration (placeholder)"

configure-zoxide:
	@echo "Zoxide configuration (placeholder)"
