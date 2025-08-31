#!/bin/bash

home-manager switch --flake .#$(nix eval --impure --raw --expr 'builtins.currentSystem') && \
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" && \
doom sync