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
      git

      # work
      go
      gopls
      pre-commit
      buf
      protobuf
      golangci-lint
      dotnet-sdk_9
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
