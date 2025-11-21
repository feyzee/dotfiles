#!/bin/bash

flatpak_packages=(
    be.alexandervanhee.gradia
    ca.desrt.dconf-editor
    com.belmoussaoui.Authenticator
    com.bitwarden.desktop
    com.github.johnfactotum.Foliate
    com.github.maoschanz.drawing
    com.github.tchx84.Flatseal
    com.logseq.Logseq
    com.slack.Slack
    com.spotify.Client
    md.obsidian.Obsidian
    org.gimp.GIMP
    org.gnome.Extensions
    org.keepassxc.KeePassXC
    org.kde.PlatformTheme.QGnomePlatform
    org.libreoffice.LibreOffice
    org.mozilla.Thunderbird
)

setup_flatpak()
{
    if ! [ -x "$(command -v flatpak)" ]; then
        echo 'Flatpak is not installed. Instaling now...' >&2
        sudo dnf install -y flatpak
    fi

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak update -y
    flatpak install flathub ${flatpak_packages[@]} -y
}
