{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Core CLI tools
    git
    stow
    fzf
    ripgrep
    fd
    bat
    eza
    procs
    lazygit
    tmux
    zoxide
    jq
    gh
    git-delta

    # Dev tools
    nodejs_22
    rustup
    go
    golangci-lint
    gop Editors
    nels

    #ovim
    helix

    # Shells
    fish
    zsh

    # Additional tools
    curl
    wget
    rsync
    tree
    htop
    httpie
    yq
    docker
    podman
  ];
}
