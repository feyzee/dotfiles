#!/bin/bash

configure_dnf_repos()
{
}

install_dnf_packages()
{
    source ./pkg/dnf
    echo "Installing packages using DNF"

    sudo dnf update --refresh --skip-unavailable -y
    sudo dnf install --skip-unavailable -y ${dnf_packages[@]}
}

setup_flatpak()
{
    source ./pkg/flatpak
    echo "Installing packages using Flatpak"

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak update -y
    flatpak install flathub ${flatpak_packages[@]} -y
}
