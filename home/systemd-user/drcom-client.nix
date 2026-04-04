{
    config,
    ...
}:
{
    systemd.user.services.drcom = {
        Unit = {
            Description = "DRCOM client";
            After = [ "network-online.target" ];
            Wants = [ "network-online.target" ];
        };

        Service = {
            ExecStart = "${config.home.profileDirectory}/bin/drcom_client -c /etc/agenix/drcom-jlu.conf";
        };

        Install.WantedBy = [ "default.target" ];
    };
}
