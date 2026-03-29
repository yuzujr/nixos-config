{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.networking.mihomo;
in
{
  options.modules.networking.mihomo.enable = lib.mkEnableOption "mihomo service";

  config = lib.mkMerge [
    {
      networking.networkmanager = {
        enable = true;
        settings.connectivity.enabled = false;
      };

      systemd.services.NetworkManager-wait-online.enable = false;
      networking.firewall.enable = true;

      services.openssh = {
        enable = true;
        openFirewall = true;
      };
    }

    (lib.mkIf cfg.enable {
      services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.metacubexd;
        configFile = "/etc/agenix/mihomo-config.yaml";
      };

      # Mihomo's TUN mode can use asymmetric routing that conflicts with
      # NixOS's default strict reverse-path filtering.
      networking.firewall.checkReversePath = lib.mkDefault "loose";
    })
  ];
}
