{ config, pkgs, ... }:

{
  home.username = "nick";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/nick" else "/home/nick";
  programs.home-manager.enable = true;

  launchd.enable = if pkgs.stdenv.isDarwin then true else false;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
