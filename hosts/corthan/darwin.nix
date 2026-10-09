{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate manages Nix, its daemon, and /etc/nix/nix.conf.
  nix.enable = false;

  system.stateVersion = 6;
  users.users.nick.home = "/Users/nick";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nick = import ./home.nix;
  };
}
