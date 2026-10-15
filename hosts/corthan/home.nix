{ pkgs, ... }:
{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "26.05";

  # Runtime for LazyVim tools installed through Mason (e.g. npm-based servers).
  home.packages = [ pkgs.nodejs ];
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
