{ config, pkgs, ... }:

{
  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;
  
  # https://github.com/NixOS/nixpkgs/issues/17943#issuecomment-341860410
  # https://github.com/NixOS/nixpkgs/issues/28687
  # https://github.com/NixOS/nixpkgs/issues/15653#issuecomment-234538778 (this is what happens otherwise if not setting services...)
  # https://www.google.com/search?q=nixos-rebuild+Failed+to+connect+to+bus:+No+data+available
  # steps to set that on-the-fly
  # sudo nano /etc/nixos/configuration.nix # add setting to file
  # sudo nixos-rebuild switch
  # systemctl daemon-reload # as the warning resulting of nixos-rebuild suggests
  # (provided the vagrant password there - using option (2) in the dialog)
  # sudo nixos-rebuild switch
  services.dbus.socketActivated = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  users.users.root.initialHashedPassword = "test";
  
  boot.initrd.checkJournalingFS = false;
  
  # Vagrant cannot yet handle udev's new predictable interface names.
  # Use the old ethX naming system for the moment.
  # http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
  networking.usePredictableInterfaceNames = false;
}
