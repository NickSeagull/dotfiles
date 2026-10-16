{ pkgs }:
let
  # Keep the supported push-msg protocol, but reject TCP commands: the engine
  # runs as root and loopback clients must never reload user-controlled config.
  engine = pkgs.kanata.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/tcp_server.rs --replace-fail \
        'log::debug!("tcp server received command: {:?}", event);' \
        'log::debug!("tcp server received command: {:?}", event); if !matches!(event, ClientMessage::Hello {}) { continue; }'
    '';
  });
  simulator = pkgs.kanata.overrideAttrs (_: {
    pname = "kanata-simulator";
    cargoBuildFlags = [ "--package" "kanata-sim" ];
    cargoTestFlags = [ "--package" "kanata-sim" ];
    doCheck = false;
    doInstallCheck = false;
    postInstall = "";
    # Also needed when the workspace member has its own feature namespace.
    buildFeatures = [ "simulated_output" ];
    postPatch = ''
      substituteInPlace src/kanata/mod.rs --replace-fail \
        'log::debug!("Action push-msg");' \
        'log::info!("SIM_MESSAGE {:?}", _message);'
    '';
    meta.mainProgram = "kanata_simulated_input";
  });
in { inherit engine simulator; }
