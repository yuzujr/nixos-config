{
    config,
    ...
}:
{
    systemd.user.services.drcom = {
        Unit = {
            Description = "DRCOM client";
        };

        Service = {
            ExecStart = "${config.home.profileDirectory}/bin/drcom_client -c ${config.xdg.configHome}/drcom-client-cpp/drcom-jlu.conf";
        };

        Install.WantedBy = [ "default.target" ];
    };
}
