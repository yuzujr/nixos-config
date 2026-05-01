{
    config,
    ...
}:
{
    systemd.user.services.wl-clip-persist = {
        Unit = {
            Description = "Wayland clipboard persistence";
            PartOf = [ "niri.service" ];
            After = [ "niri.service" ];
            BindsTo = [ "niri.service" ];
        };

        Service = {
            ExecStart = "${config.home.profileDirectory}/bin/wl-clip-persist --clipboard regular";
            Restart = "on-failure";
            RestartSec = 1;
        };

        Install.WantedBy = [ "niri.service" ];
    };
}
