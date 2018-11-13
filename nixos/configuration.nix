{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  inherit (builtins) hasAttr;
in {
  imports = [ 
    ./hardware-configuration.nix 
    ./graphical.nix
    ./guest.nix
    ./users.nix
    ./vagrant.nix
    ./vagrant-network.nix
    ./vagrant-hostname.nix
  ];

  nix.useSandbox = true;
  
  systemd.services.systemd-udev-settle.enable = false;

  environment.systemPackages =
    [ ]
    ++ lib.optionals (hasAttr "biosdevname" pkgs) [pkgs.biosdevname]; # Vagrant plugin support.
}
