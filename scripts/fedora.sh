#!/bin/bash

configure_dnf_repos()
{
}

install_dnf_packages()
{
    if [ ! -f ./pkg/dnf ]; then
        echo "List of packages to install not found. Stopped installing fedora packages"
        return
    fi

    source ./pkg/dnf
    echo "Installing packages using DNF"

    sudo dnf update --refresh --skip-unavailable -y
    sudo dnf install --skip-unavailable -y ${dnf_packages[@]}
}

setup_flatpak()
{
    if [ ! -f ./pkg/flatpak ]; then
        echo "List of packages to install not found. Stopped installing flatpak packages"
        return
    fi

    source ./pkg/flatpak
    echo "Installing packages using Flatpak"

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak update -y
    flatpak install flathub ${flatpak_packages[@]} -y
}
