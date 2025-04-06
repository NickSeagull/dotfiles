{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    golangci-lint
    golangci-lint-langserver
    pre-commit
    nixfmt-classic
    google-cloud-sdk
    buf
    protobuf
    go
  ];

  shellHook = ''
    if [ ! -f .git/setup_executed ]; then
      echo "Getting submodules"
      git submodule update --init --recursive

      echo "Installing pre-commit hooks"
      pre-commit install

      echo "Running Makefile"
      make local_setup

      echo "Setup complete"
      echo 'true' > .git/setup_executed
    fi
  '';
}
