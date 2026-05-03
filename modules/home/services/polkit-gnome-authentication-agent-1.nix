{
    pkgs,
    ...
}:
{
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
            Description = "Polkit GNOME Authentication Agent";
            PartOf = [ "niri.service" ];
            After = [ "niri.service" ];
            BindsTo = [ "niri.service" ];
        };

        Service = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
        };

        Install.WantedBy = [ "niri.service" ];
    };
}
