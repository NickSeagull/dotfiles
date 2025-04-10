{ lib, pkgs, ... }: {
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

      # Work stuff
      golangci-lint
      golangci-lint-langserver
      pre-commit
      nixfmt-classic
      google-cloud-sdk
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
  };
}
