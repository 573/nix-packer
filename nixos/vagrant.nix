{ config, pkgs, ... }:

#
# This file is used by the vagrant-nixos plugin
#

{
  imports = [
    ./vagrant-hostname.nix
    ./vagrant-network.nix
  ];
}
