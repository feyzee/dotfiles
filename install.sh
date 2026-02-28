#!/bin/bash

# TODO: configure (nerd) fonts, install gnome extensions, configure gnome settings via dconf or gnome-tweaks,
# fastestmirror and other dnf conf, enable copr's, ghostty


main()
{
    while getopts "init" init; do
        echo "Intializing for the first time..."
        init
    done

    configure_dotfiles
}

init()
{
    platform=$(uname)

    if ! [ -x "$(command -v git)" ]; then
        echo 'Git is not installed. Installing now...'
        install_git $platform
    fi

    echo "Installing packages"
    if [ $platform == 'Linux' ]; then
        source scripts/fedora.sh
        source scripts/flatpak.sh
        configure_dnf_repos
        install_dnf_packages
        setup_flatpak
    elif [ $platform == 'Darwin' ]; then
        source scripts/macos.sh
        install_xcode_tools
        install_brew_packages
    else
        echo "OS not supported. Exiting..."
        sleep 2
        exit 1
    fi
}

install_git()
{
    if [ $1 == 'Linux' ]; then
        sudo dnf install -y git
    elif [ $1 == 'Darwin' ]; then
        brew install git
    else
        echo "OS not supported. Exiting..."
        sleep 2
        exit 1
    fi
}

configure_dotfiles()
{
    OS=$(uname)

    if ! [ -x "$(command -v stow)" ]; then
        echo 'Stow is not installed. Exiting...'
        exit 1
    fi

    # Configure Ghostty
    stow ghostty
    pushd ~/.config/ghostty > /dev/null
        if [ "$OS" = "Darwin" ]; then
            ln -sfn macos.conf platform.conf
        else
            ln -sfn linux.conf platform.conf
        fi
    popd > /dev/null

    stow bat
    stow claude
    stow helix
    stow kitty
    stow lazygit
    stow opencode
    stow nvim
    stow procs
    stow wezterm
    stow nvim
}

configure_firefox()
{}

configure_golang()
{}

configure_fonts()
{}

configure_k8s()
{
    echo "install kind"
}

configure_zoxide()
{}

configure_logseq()

main $1 $2
