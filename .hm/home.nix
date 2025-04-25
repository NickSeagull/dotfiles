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

  home = {
    packages = with pkgs; [
      bitwarden-cli
      nixpkgs-fmt
      libvterm
      gnumake
      xclip
      browsh
      firefox  # required for browsh
      eza

      # Work stuff
      typescript-language-server
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
