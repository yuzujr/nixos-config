{ config, ... }:
{
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