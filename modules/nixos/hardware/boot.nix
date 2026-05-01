{ config, pkgs, ... }:
{
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
    };

    boot.loader.timeout = 5;
    boot.loader.systemd-boot.configurationLimit = 10;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.extraModulePackages = with config.boot.kernelPackages; [
        yt6801
    ];

    boot.extraModprobeConfig = ''
        options nvidia_drm fbdev=0
    '';
}
