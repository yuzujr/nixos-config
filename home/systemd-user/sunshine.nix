{
    config,
    pkgs,
    ...
}:
{
    systemd.user.services.sunshine = {
        Unit = {
            Description = "Self-hosted game stream host for Moonlight";
            StartLimitIntervalSec = 500;
            StartLimitBurst = 5;
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
            BindsTo = [ "graphical-session.target" ];
        };

        Service = {
            # Only auto-start Sunshine for the normal Niri profile.
            ExecCondition = "${pkgs.bash}/bin/bash -lc 'target=$(${pkgs.coreutils}/bin/readlink \"$HOME/.config/niri/profiles/current-config.kdl\" 2>/dev/null || true); [[ \"$target\" == normal/config.kdl ]]'";
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
            ExecStart = "${config.home.profileDirectory}/bin/sunshine";
            Restart = "on-failure";
            RestartSec = "5s";
        };

        Install = {
            # WantedBy = [ "graphical-session.target" ];
        };
    };
}
