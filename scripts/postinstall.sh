#!/bin/sh

set -e
set -x

nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-14.04/ nixos

# Attempt to rebuild, but fail due to https://github.com/NixOS/nixpkgs/pull/2675
# then create the user manually,
# then run rebuild again.
nixos-rebuild switch --upgrade || true
useradd \
  -g "vagrant" \
  -G "users,vboxsf,wheel" \
  -s "/run/current-system/sw/bin/bash" \
  -d "/home/vagrant" \
  "vagrant"
nixos-rebuild switch --upgrade

# Prevent collection of utilities needed by the Vagrant plugin.
mkdir -p /etc/nixos/vagrant
ln -sv /etc/nixos/vagrant /nix/var/nix/gcroots

# Build and symlink utilities needed by Vagrant.
mkdir -p /etc/nixos/vagrant/bin
biosdevname_expr='((import <nixpkgs> {}).callPackage /etc/nixos/vagrant/pkgs/biosdevname {})'
echo "$biosdevname_expr" > biosdevname.nix
biosdevname=$(nix-build --no-out-link biosdevname.nix)/bin/biosdevname
ln -sv "$biosdevname" /etc/nixos/vagrant/bin
rm biosdevname.nix

# Cleanup any previous generations and delete old packages.
nix-collect-garbage -d

#################
# General cleanup
#################

# Clear history
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

# Truncate the logs.
#find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Zero the unused space.
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;
