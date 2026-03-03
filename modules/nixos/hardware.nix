{ pkgs, ... }:

{
  zramSwap.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    pkgs.linuxPackages_latest.yt6801
  ];

  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.steam-hardware.enable = true;

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
