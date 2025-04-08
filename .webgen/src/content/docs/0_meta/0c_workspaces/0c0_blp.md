+++
title = "BLP Workspace Shell"
author = ["Nikita Tchayka"]
date = 2025-04-06T00:00:00+01:00
draft = false
+++

This file defines the development shell that I use for my work at BLP Digital.

It ensures that all necessary tools and dependencies are available when entering the workspace, and runs a one-time setup script to initialize everything.

As always, this file is tangled from Org Mode, and lives in:

```text
.workspaces/blp/shell.nix
```

---

We begin by importing `nixpkgs` as usual:

```nix
{ pkgs ? import <nixpkgs> {} }:
```

We define a `mkShell` environment with all the tools needed for development:

```nix
pkgs.mkShell {
  buildInputs = with pkgs; [
    golangci-lint
    golangci-lint-langserver
    pre-commit
    nixfmt-classic
    google-cloud-sdk
    buf
    protobuf
    go
    git
    dotnet-sdk_9
    nodePackages.prettier
  ];
```

The following `shellHook` runs automatically when the shell is entered. It performs a one-time setup, guarded by a sentinel file in `.git/setup_executed`.

This includes:

1.  Initializing Git submodules
2.  Installing pre-commit hooks
3.  Running the `Makefile` target `local_setup`

<!--listend-->

```nix
  shellHook = ''
    cd document-api
    if [ ! -f .git/setup_executed ]; then
      echo "Getting submodules"
      git submodule update --init --recursive

      echo "Installing pre-commit hooks"
      pre-commit install

      echo "Running Makefile"
      make local_setup

      echo "Setup complete"
      echo 'true' > .git/setup_executed
    fi
  '';
}
```

This approach ensures that setup tasks run exactly once, speeding up subsequent shell entries while still initializing a fully working environment on first use.

The result is a reproducible, ergonomic workspace, bootstrapped with zero friction.
