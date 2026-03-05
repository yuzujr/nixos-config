{ config, pkgs, ... }:

{
  zramSwap.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    yt6801
  ];

  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.i2c.enable = true;

  hardware.steam-hardware.enable = true;

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = true;
    dynamicBoost.enable = true;
    nvidiaSettings = false;
  };

  boot.extraModprobeConfig = ''
    options nvidia_drm fbdev=0
  '';
}
