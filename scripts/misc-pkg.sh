#!/bin/bash

PLATFORM=$(uname)

install_rust()
{
    echo "Installing rust"
    if [[ $PLATFORM == 'Linux' ]]; then
        rustup-init
    elif [[ $PLATFORM == 'Darwin' ]]; then
        rustup default stable
    else
        echo "OS not supported. Exiting..."
        sleep 2
        exit 1
    fi

    source ./pkg/rust
    echo "Installing rust components"
    rustup component add ${rustup_components[@]}
}

install_cargo_packages()
{
    source ./pkg/rust
    echo "Installing packages using Cargo"

    cargo install ${cargo_packages[@]}
}

install_go_packages()
{
    source ./pkg/golang
    echo "Installing packages using Cargo"

    go install ${go_packages[@]}
}

install_npm_packages()
{
    source ./pkg/npm
    echo "Installing packages using Cargo"

    pnpm install -g ${npm_packages[@]}
}

install_rust
install_cargo_packages
install_go_packages
install_npm_packages
