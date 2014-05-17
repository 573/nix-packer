{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
    ./guest.nix
    ./users.nix
    ./vagrant.nix
  ];

  nix.useChroot = true;
  users.mutableUsers = false; # DELETE ME (see https://github.com/NixOS/nixpkgs/pull/2675))

  nixpkgs.config = {
    packageOverrides = pkgs: {
      # https://github.com/NixOS/nixpkgs/pull/2653
      mkpasswd = pkgs.callPackage ./vagrant/pkgs/mkpasswd { };
    };
  };
}
