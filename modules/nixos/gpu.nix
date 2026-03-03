{ config, ... }:

{
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    dynamicBoost.enable = true;
  };

  boot.extraModprobeConfig = ''
    options nvidia_drm fbdev=0
  '';
}
