{ config, lib, pkgs, ... }:
{
    options.modules.networking.mihomo.enable = lib.mkEnableOption "mihomo service";

    config = lib.mkIf config.modules.networking.mihomo.enable {
        services.mihomo = {
            enable = true;
            tunMode = true;
            webui = pkgs.metacubexd;
            configFile = config.age.secrets."mihomo.yaml".path;
        };
        # Mihomo's TUN mode can use asymmetric routing that conflicts with
        # NixOS's default strict reverse-path filtering.
        # networking.firewall.checkReversePath = lib.mkDefault "loose";
    };
}