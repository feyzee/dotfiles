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

    if [ ! -f ./pkg/rust ]; then
        echo "Components list to install not found. Stopped installing"
        return
    fi

    source ./pkg/rust
    echo "Installing rust components"
    rustup component add ${rustup_components[@]}
}

install_cargo_packages()
{
    if [ ! -f ./pkg/rust ]; then
        echo "List of packages to install not found. Stopped installing rust packages"
        return
    fi

    source ./pkg/rust
    echo "Installing packages using Cargo"

    cargo install ${cargo_packages[@]}
}

install_go_packages()
{
    if [ ! -f ./pkg/golang ]; then
        echo "List of packages to install not found. Stopped installing Go packages"
        return
    fi

    source ./pkg/golang
    echo "Installing packages using Cargo"

    go install ${go_packages[@]}
}

install_npm_packages()
{
    if [ ! -f ./pkg/npm ]; then
        echo "List of packages to install not found. Stopped installing NPM packages"
        return
    fi

    source ./pkg/npm
    echo "Installing packages using Cargo"

    npm install -g ${npm_packages[@]}
}
