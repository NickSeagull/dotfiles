#!/bin/bash

if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
fi

# Check if nix flake support is available
if ! nix flake --help &> /dev/null; then
    echo "Error: Nix flake support is not installed"
    echo "Please uninstall Nix and run this script again"
    exit 1
fi