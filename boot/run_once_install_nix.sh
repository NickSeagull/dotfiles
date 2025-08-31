#!/bin/bash

if command -v nix &> /dev/null; then
    echo "Nix is already installed, skipping installation"
    exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate