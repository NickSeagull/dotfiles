{ lib, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "bartender";

  # Determinate manages Nix, its daemon, and /etc/nix/nix.conf.
  nix.enable = false;

  system.stateVersion = 6;
  system.primaryUser = "nick";
  users.users.nick.home = "/Users/nick";

  homebrew = {
    enable = true;
    taps = [ "sozercan/repo" ];
    brews = [
      "direnv"
      "neovim"
    ];
    casks = [
      "azure-cli"
      "ghostty"
      "sozercan/repo/kaset"
      "muesli"
      "raycast"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nick = import ./home.nix;
  };
}
