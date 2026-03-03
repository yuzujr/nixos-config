{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    pkgs.linuxPackages_latest.yt6801
  ];

  zramSwap.enable = true;
}
