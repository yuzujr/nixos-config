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
      ExecStart = "${config.home.profileDirectory}/bin/drcom_client -c %h/.config/drcom-client-cpp/drcom_jlu.conf";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
