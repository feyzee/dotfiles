#!/bin/bash

install_xcode_tools()
{
    if ! xcode-select -p &>/dev/null; then
      echo "Xcode Command Line Tools not installed. Installing now..."
      xcode-select --install
    fi
}

install_brew_packages()
{
    if ! [ -x "$(command -v brew)" ]; then
        echo 'Homebrew is not installed. Instaling now...'
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [ ! -f ./Brewfile ]; then
        echo "Brewfile not found. Brew packages not installed..."
        return
    done

    echo "Installing packages using homebrew Brewfile..."

    brew update && brew upgrade
    brew bundle install --file=./Brewfile
}
