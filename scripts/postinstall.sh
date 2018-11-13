#!/bin/sh

set -e
set -x

nix-channel --add https://nixos.org/channels/nixos-18.09 nixos
nix-channel --update nixos
cat /etc/nixos/configuration.nix
sudo systemctl daemon-reload
sudo nixos-rebuild switch --upgrade

### try https://unix.stackexchange.com/a/447046/102072
#$(which nixos-enter) --root / # most probably led to wrong permissions of /home/vagrant/.cache
#$(which nixos-enter) --root / -- nix-channel --add https://nixos.org/channels/nixos-18.09 nixos
#$(which nixos-enter) --root / -- nix-channel --update nixos


# Upgrade.
#$(which nixos-enter) --root / -- nixos-rebuild switch --upgrade
#nixos-rebuild switch --fallback --show-trace --option binary-caches https://cache.nixos.org/

# Cleanup any previous generations and delete old packages.
#$(which nixos-enter) --root / -- nix-collect-garbage -d

#################
# General cleanup
#################

# Clear history
unset HISTFILE
if [ -f /root/.bash_history ]; then
  rm /root/.bash_history
fi
if [ -f /home/vagrant/.bash_history ]; then
  rm /home/vagrant/.bash_history
fi

# Clear temporary folder
rm -rf /tmp/*

# Truncate the logs.
#find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Zero the unused space.
#count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
#let count--
#dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
#rm /tmp/whitespace;
