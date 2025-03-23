#!/bin/bash

set -e # Exit immediately on error
set -u # Treat unset variables as errors

### Ensure running as root ###
if [[ "$(id -u)" -ne 0 ]]; then
  echo "This script must be run as root!" >&2
  exit 1
fi

apt-get update && apt-get install -y curl openssh-server sudo xz-utils

### Check if user 'nick' already exists ###
if ! id "nick" &>/dev/null; then
  echo "Creating user 'nick'..."
  useradd -m -s /bin/bash -G sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev -U nick
  mkdir -p /etc/sudoers.d #
  echo "nick ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/nick
  chmod 0440 /etc/sudoers.d/nick
fi

# Move tmp creds into place
[ -f /tmp/bw_email ] && mv /tmp/bw_email /home/nick/.bw_email
[ -f /tmp/bw_master ] && mv /tmp/bw_master /home/nick/.bw_master

if [ ! -f /home/nick/.bw_email ]; then
  [ -z "$BW_EMAIL" ] && read -p "Enter Bitwarden email: " BW_EMAIL
  echo "$BW_EMAIL" >/home/nick/.bw_email
fi

if [ ! -f /home/nick/.bw_master ]; then
  [ -z "$BW_MASTER" ] && read -s -p "Enter Bitwarden master password: " BW_MASTER
  echo "$BW_MASTER" >/home/nick/.bw_master
fi

### Ensure correct home directory ownership ###
chown -R nick:nick /home/nick

### Switch to 'nick' user and continue installation ###
su - nick <<'EOF'
# Skip if nix is already installed
command -v nix >/dev/null && exit

set -e  # Ensure errors cause exit in the new shell
echo "Now running as $(whoami)..."
if [ -f /run/.dockerenv ]; then
  echo "Running inside Docker"
  sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes
else
  sh <(curl -L https://nixos.org/nix/install) --daemon --yes
fi
mkdir -p /home/nick/.config/nix
echo 'experimental-features = nix-command flakes' >> /home/nick/.config/nix/nix.conf
EOF

# Restart shell
su - nick <<'EOF'
# Skip if home-manager is already installed
command -v home-manager >/dev/null && exit

# Install home manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

echo 'source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh' > .bashrc
source ~/.bashrc
EOF

### Fetch SSH keys using Bitwarden CLI ###
su - nick <<'EOF'
[ -e ~/.ssh/id_ed25519 ] && exit
echo "Fetching SSH keys using Bitwarden CLI..."

# Run a temporary nix-shell with bitwarden-cli and jq
nix-shell -p bitwarden-cli jq git --run '

set -e
set -u

# Ensure Bitwarden is unlocked
if ! bw status | grep -q "unlocked"; then
    echo "Logging into Bitwarden..."
    export BW_EMAIL=$(cat /home/nick/.bw_email)
    export BW_MASTER=$(cat /home/nick/.bw_master)
    export BW_SESSION=$(bw login $BW_EMAIL $BW_MASTER --raw)  # Unlock and store session key
fi

PRIVATE_KEY=$(bw get item "06402220-1908-4042-af30-b230011e2a82" | jq -r ".notes" | sed -E "s/(-----BEGIN .*-----) (.*) (-----END .*-----)/\1\n\2\n\3/")
PUBLIC_KEY=$(bw get item "57624b62-29a6-4511-b5f7-b230011eec2b" | jq -r ".notes")

# Store keys in ~/.ssh
mkdir -p ~/.ssh
echo "$PRIVATE_KEY" > ~/.ssh/id_ed25519
echo "$PUBLIC_KEY" > ~/.ssh/id_ed25519.pub

# Set correct permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# Add key to SSH agent
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

echo "SSH key added successfully!"

# Allow cloning from github using SSH
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

[ -e ~/.replicant ] && exit
git clone git@github.com:NickSeagull/REPLICANT.git ~/.replicant
'
EOF

su - nick <<'EOF'
cd ~/.replicant
home-manager switch --flake .#nick
EOF

rm /home/nick/.bw_email
rm /home/nick/.bw_master

echo "Setup completed!"
