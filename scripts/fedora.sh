#!/bin/bash

source ./pkg/dnf
source ./pkg/flatpak

echo "Installing packages using DNF"
sudo dnf update --refresh --skip-unavailable -y
sudo dnf install --skip-unavailable -y ${dnf_packages[@]}

echo "Installing packages using Flatpak"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update -y
flatpak install flathub ${flatpak_packages[@]} -y
