#!/bin/bash

install_rust()
{
    echo "Installing rust"
    if [ $platform == 'Linux' ]; then
        rustup-init
    elif [ $platform == 'Darwin' ]; then
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

    npm install -g ${npm_packages[@]}
}
