#!/bin/sh

set -e
set -x

nix-channel --add https://nixos.org/channels/nixos-18.09 nixos
nix-channel --update nixos

# Mount a VirtualBox shared folder.
# This is configurable in the VirtualBox menu at
# Machine / Settings / Shared Folders.
# Also devices' "nameofdevicetomount" is found there
# Add this after packer only, according to Vagrantfile
# https://unix.stackexchange.com/questions/45591/using-a-here-doc-for-sed-and-a-file/170200#170200
# https://github.com/NixOS/nixpkgs/issues/38429
# process substitution only with bash and no posix meaning no sh, could use shebang /bin/bash here or
# write some very nasty function myself here but no, rather using the simpler variant
#sed -f <( cat << SED_SCRIPT
#s/}/  fileSystems."\/mnt" = {\n    fsType = "vboxsf";\n    device = "vagrant";\n    options = [ "rw" ];\n  };\n}/g
#SED_SCRIPT) /etc/nixos/guest.nix | sudo tee /etc/nixos/guest.nix

cat /etc/nixos/guest.nix | sed -E '$s/}/\n  fileSystems."\/mnt" = {\n    fsType = "vboxsf";\n    device = "vagrant";\n    options = [ "rw,noauto,x-systemd.automount" ];\n  };\n}/g' | sudo tee /etc/nixos/guest.nix
sudo mkdir /mnt

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
