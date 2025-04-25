{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ramsys";
  time.timeZone = "Atlantic/Canary";
  networking.firewall.allowedTCPPorts = [ 22 4321 8081 3000 5173 ];

  virtualisation.docker = {
    enable = true;
  };

  services.coder= {
    enable = true;
    listenAddress = "0.0.0.0:3000";
  };
  services.xserver.xkb.layout = "us";
  services.printing.enable = true;
  users.users.nick = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    mosh
  ];

  services.openssh.enable = true;

  programs.mosh.enable = true;
  programs.mosh.openFirewall = true;
  system.stateVersion = "24.11";
}
