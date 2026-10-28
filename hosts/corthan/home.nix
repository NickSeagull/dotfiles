{ lib, osConfig, pkgs, ... }:
let
  # Use the Azure CLI already managed by nix-darwin's Homebrew configuration.
  # Git appends the operation argument; the helper must end at `f`, without a newline.
  azureCredentialHelper = lib.removeSuffix "\n" ''
    !f() {
      test "$1" = get || return 0
      bearer=
      while IFS= read -r line && test -n "$line"; do
        case "$line" in 'capability[]=authtype') bearer=1 ;; esac
      done
      token=$(${lib.escapeShellArg "${osConfig.homebrew.prefix}/bin/az"} account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken --output tsv --only-show-errors) || return $?
      test -n "$token" || return 1
      if test "$bearer" = 1; then
        printf 'capability[]=authtype\nauthtype=Bearer\ncredential=%s\n' "$token"
      else
        printf 'username=azure-cli\npassword=%s\n' "$token"
      fi
    }; f
  '';
in
{
  imports = [
    ../../config/agent-skills
    ../../config/codex
    ../../config/orca
    ../../config/wallpaper.nix
  ];

  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "26.05";

  launchd.agents.easy-move-resize = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "/Applications/Easy Move+Resize.app" ];
      RunAtLoad = true;
    };
  };

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
    settings = {
      user = {
        name = "Nick Seagull";
        email = "github@nickseagull.dev";
      };
      credential = lib.genAttrs [ "https://dev.azure.com" "https://*.visualstudio.com" ] (_: {
        # Reset inherited helpers so Azure tokens never enter another helper's store.
        helper = [ "" azureCredentialHelper ];
        useHttpPath = true;
      });
    };
  };

  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.lazygit.enable = true;

  xdg.configFile = {
    "git/config".force = true;
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
