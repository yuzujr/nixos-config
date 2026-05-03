{
    config,
    lib,
    pkgs,
    ...
}:
{
    services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.metacubexd;
        configFile = config.sops.secrets."network/mihomo".path;
    };
    systemd.services.mihomo = {
        wantedBy = lib.mkForce [ ];
        requires = lib.mkForce [ ];
        after = lib.mkForce [ ];
        serviceConfig = {
            Restart = "on-failure";
            RestartSec = "5s";
        };
    };
    systemd.timers.mihomo-delayed = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
            OnBootSec = "10s";
            AccuracySec = "1s";
            Unit = "mihomo.service";
        };
    };
    # Mihomo's TUN mode can use asymmetric routing that conflicts with
    # NixOS's default strict reverse-path filtering.
    networking.firewall.checkReversePath = lib.mkDefault "loose";
}
