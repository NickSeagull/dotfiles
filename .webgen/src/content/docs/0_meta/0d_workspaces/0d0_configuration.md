+++
title = "Server Configuration"
author = ["Nikita Tchayka"]
date = 2025-04-07T00:00:00+01:00
draft = false
+++

This file defines the basic configuration for my home server.

Given that `/etc/nixos/configuration.nix` is protected, I just put the config here:

```text
.server/configuration.nix
```

```nix
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
  networking.firewall.allowedTCPPorts = [ 22 4321 8081 3000 ];

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

```
