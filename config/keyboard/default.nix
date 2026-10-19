{ config, lib, pkgs, ... }:
let
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;
  packages = import ./packages.nix { inherit pkgs; };
  driver = pkgs.kanata.darwinDriver;
  helper = pkgs.stdenv.mkDerivation {
    pname = "keyboard-actions";
    version = "1";
    src = ./actions.m;
    dontUnpack = true;
    buildPhase = ''
      $CC -fobjc-arc -Wall -Wextra -framework Cocoa -framework ApplicationServices \
        -x objective-c $src -o keyboard-actions
    '';
    installPhase = ''
      mkdir -p "$out/bin"
      cp keyboard-actions "$out/bin/"
    '';
  };
  support = pkgs.runCommand "keyboard-support" { nativeBuildInputs = [ pkgs.python3 ]; } ''
    mkdir -p "$out"
    cp ${./.}/*.py ${./.}/*.json "$out/"
    python3 "$out/generate.py" > "$out/kanata.kbd"
    ${packages.engine}/bin/kanata --check --cfg "$out/kanata.kbd"
    export KEYBOARD_SOURCE="$out"
    export PYTHONDONTWRITEBYTECODE=1
    export KANATA_SIMULATOR=${packages.simulator}/bin/kanata_simulated_input
    python3 -m unittest discover -s ${./tests} -p test_keyboard.py -v
  '';
  control = pkgs.writeShellScriptBin "keyboard" ''
    exec ${pkgs.python3}/bin/python3 ${support}/service.py "$@"
  '';
  driverDaemon = "${driver}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
in
{
  environment.systemPackages = [ control ];

  # macOS system-extension registration needs a real application under
  # /Applications (a symlink into the store resolves outside that directory).
  # Preserve signatures; keep the managed-source receipt outside the bundle.
  system.activationScripts.postActivation.text = ''
    manager=/Applications/.Karabiner-VirtualHIDDevice-Manager.app
    receipt=/var/db/org.nick.keyboard-driver-source
    source=${driver}/Applications/.Karabiner-VirtualHIDDevice-Manager.app
    if [ ! -e "$manager" ] && [ ! -L "$manager" ]; then
      /usr/bin/ditto "$source" "$manager"
      printf '%s\n' "$source" > "$receipt"
    elif [ -f "$receipt" ]; then
      if [ "$(cat "$receipt")" != "$source" ]; then
        /usr/bin/ditto "$source" "$manager"
        printf '%s\n' "$source" > "$receipt"
      fi
    else
      echo "Preserving existing driver manager at $manager; verify its version before enabling keyboard layers."
    fi
  '';

  launchd.daemons.keyboard-driver = {
    serviceConfig = {
      Label = "org.nick.keyboard-driver";
      ProgramArguments = [ driverDaemon ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/var/log/keyboard-driver.log";
      StandardErrorPath = "/var/log/keyboard-driver.log";
    };
  };
  launchd.daemons.keyboard = {
    serviceConfig = {
      Label = "org.nick.keyboard";
      ProgramArguments = [
        "${pkgs.python3}/bin/python3" "${support}/service.py" "supervise"
        "--user" user "--engine" "${packages.engine}/bin/kanata"
        "--config" "${support}/kanata.kbd"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      ExitTimeOut = 10;
      StandardOutPath = "/var/log/keyboard.log";
      StandardErrorPath = "/var/log/keyboard.log";
    };
  };

  home-manager.users.${user} = {
    xdg.configFile."keyboard" = { source = support; force = true; };
    home.file = {
      ".local/bin/keyboard" = { source = "${control}/bin/keyboard"; force = true; };
      ".codex/skills/configure-keyboard" = {
        source = ../../skills/configure-keyboard;
        recursive = true;
        force = true;
      };
      ".codex/skills/keyboard-reference" = {
        source = ../../skills/keyboard-reference;
        recursive = true;
        force = true;
      };
    };
    launchd.agents.keyboard-actions = {
      enable = true;
      config = {
        Label = "org.nick.keyboard-actions";
        ProgramArguments = [
          "${pkgs.python3}/bin/python3" "${support}/runner.py"
          "--helper" "${helper}/bin/keyboard-actions" "--adapter" "${support}/macos.json"
        ];
        RunAtLoad = true;
        KeepAlive = false;
        ExitTimeOut = 5;
        StandardOutPath = "${home}/Library/Logs/keyboard-actions.log";
        StandardErrorPath = "${home}/Library/Logs/keyboard-actions.log";
      };
    };
  };
}
