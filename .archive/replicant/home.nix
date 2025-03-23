{ lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      bitwarden-cli
      nixpkgs-fmt
      libvterm

      # work
      go
      gopls
      pre-commit
      buf
      protobuf
      golangci-lint
      google-cloud-sdk
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
