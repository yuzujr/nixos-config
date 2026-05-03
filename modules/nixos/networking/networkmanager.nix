{ pkgs, ... }:
{
    networking.networkmanager = {
        enable = true;
        settings.connectivity.enabled = false;
    };
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.suppressedSystemUnits = [ "systemd-user-sessions.service" ];
    systemd.services.systemd-user-sessions = {
        description = "Permit User Sessions";
        documentation = [ "man:systemd-user-sessions.service(8)" ];
        wantedBy = [ "multi-user.target" ];
        after = [
            "remote-fs.target"
            "nss-user-lookup.target"
            "home.mount"
        ];
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.systemd}/lib/systemd/systemd-user-sessions start";
            ExecStop = "${pkgs.systemd}/lib/systemd/systemd-user-sessions stop";
        };
    };
    networking.firewall.enable = true;
}
