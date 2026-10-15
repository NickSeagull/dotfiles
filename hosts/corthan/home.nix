{ pkgs, ... }:
{
  imports = [ ../../config/codex ];

  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "26.05";

  home.packages = [
    # Bartender 6 supports macOS 26; nixpkgs' older download URL returns 404.
    (pkgs.bartender.overrideAttrs (finalAttrs: _: {
      version = "6.6.2";
      src = pkgs.fetchzip {
        url = "https://downloads.macbartender.com/B2/updates/${
          builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
        }/Bartender%206.zip";
        hash = "sha256-anIvq/M0/LcnRfVcOq0F7LWx5NSNVyqjfpWfmC/XmkY=";
      };
    }))
    # Runtime for LazyVim tools installed through Mason (e.g. npm-based servers).
    pkgs.nodejs
  ];
  home.file = {
    "Library/Application Support/com.mitchellh.ghostty/config.ghostty" = {
      source = ../../config/ghostty/config.ghostty;
      force = true;
    };
    ".codex/skills/activate-darwin" = {
      source = ../../skills/activate-darwin;
      recursive = true;
      force = true;
    };
    ".codex/skills/configure-lazyvim" = {
      source = ../../skills/configure-lazyvim;
      recursive = true;
      force = true;
    };
    ".codex/skills/configure-app-theme" = {
      source = ../../skills/configure-app-theme;
      recursive = true;
      force = true;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Nick Seagull";
      email = "github@nickseagull.dev";
    };
  };

  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.lazygit.enable = true;

  xdg.configFile = {
    "herdr/config.toml" = {
      source = ../../config/herdr/config.toml;
      force = true;
    };
    "herdr-nvim/config.toml" = {
      source = ../../config/herdr-nvim/config.toml;
      force = true;
    };
    "nvim/init.lua" = {
      text = ''
        require("config.lazy")
      '';
      force = true;
    };
    "nvim/lua" = {
      source = ../../config/nvim/lua;
      recursive = true;
      force = true;
    };
  };
}
