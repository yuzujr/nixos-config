{
    config,
    osConfig ? { },
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
            ExecStart = "${config.home.profileDirectory}/bin/drcom_client -c ${
                osConfig.age.secrets."drcom-jlu.conf".path
            }";
        };

        Install.WantedBy = [ "default.target" ];
    };
}
