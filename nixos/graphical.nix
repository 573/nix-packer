{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.kdm.enable = true;
    desktopManager.kde4.enable = true;
  };

  environment.systemPackages = [ pkgs.glxinfo ];

  services.xserver.videoDrivers = [ "virtualbox" ];
}
