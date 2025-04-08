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

      # Work stuff
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
