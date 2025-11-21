#!/bin/bash

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

    echo "Cloning dotfiles repository"
    git clone https://github.com/feyzee/dotfiles
    cd dotfiles

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
    echo "Installing stow"
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
