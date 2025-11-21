#!/bin/bash

configure_dnf_repos()
{
}

install_dnf_packages()
{
    if [ ! -f ./fedora-packages.sh ]; then
        echo "List of packages to install not found. Stopped installing fedora packages"
        return
    end

    source ./fedora-packages.sh
    echo "Installing packages using DNF"

    sudo dnf update --refresh --skip-unavailable -y
    sudo dnf install --skip-unavailable -y ${linux_programs[@]}
}
