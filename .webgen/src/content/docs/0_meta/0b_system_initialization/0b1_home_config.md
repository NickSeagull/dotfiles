+++
title = "Home Configuration"
author = ["Nikita Tchayka"]
date = 2025-04-06T00:00:00+01:00
draft = false
+++

This file defines the base user environment for my system using `Home Manager`.

It's part of the Home Manager flake, and is imported by `flake.nix` under the `nick` profile.

As always, this file is generated from this very Org document via Org Babel tangling.

First, we allow unfree packages. I make no attempt to live a purely free software life. Practicality comes first.

```nix
{ lib, pkgs, ... }:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
    kubectl
  ]);
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
```

Next, we define the `home` block: the user, their home directory, their package list, and the system version.

```nix
  home = {
    packages = with pkgs; [
      bitwarden-cli
      nixpkgs-fmt
      libvterm
      gnumake
      xclip
      browsh
      firefox  # required for browsh

      # Work stuff
      golangci-lint
      golangci-lint-langserver
      pre-commit
      nixfmt-classic
      gdk
      buf
      protobuf
      go
      gopls
      git
      dotnet-sdk_9
      nodePackages.prettier
      nodejs_22
    ];

    username = "nick";
    homeDirectory = "/home/nick/";
    stateVersion = "24.11";
  };
```

I install a few core development tools, such as:

-   `bitwarden-cli`: for secrets and password access
-   `nixpkgs-fmt`: to format Nix code

These packages are managed declaratively — no manual installation needed.

Now, we configure some essential programs:

```nix
  programs = {
    git = {
      enable = true;
      userEmail = "github@nickseagull.dev";
      userName = "Nikita Tchayka";
    };
    home-manager = { enable = true; };
    fish = { enable = true; };
    emacs = { enable = true; };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };
}
```

I use:

-   `git` with my preferred identity
-   `home-manager` itself (naturally)
-   `fish` as my interactive shell
-   `emacs` for, well, everything

This configuration is minimal, but expressive. It defines a portable user environment I can reproduce anywhere — from scratch — starting with nothing but `git` and `nix`.
