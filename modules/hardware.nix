{ config, pkgs, ... }:
{
    zramSwap.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
    };

    # Keep the boot menu available, but do not spend 5 seconds waiting on it.
    boot.loader.timeout = 5;
    boot.loader.systemd-boot.configurationLimit = 10;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.extraModulePackages = with config.boot.kernelPackages; [
        yt6801
    ];

    boot.extraModprobeConfig = ''
        options nvidia_drm fbdev=0
    '';

    security.rtkit.enable = true;

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
    };

    hardware.i2c.enable = true;
    hardware.steam-hardware.enable = true;

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        modesetting.enable = true;
        powerManagement.enable = true;
        dynamicBoost.enable = true;
        nvidiaSettings = false;
    };
}
