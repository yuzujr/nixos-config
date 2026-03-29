{
  config,
  pkgs,
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
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
      ExecStart = "${config.home.profileDirectory}/bin/drcom_client -c %h/.config/drcom-client-cpp/drcom_jlu.conf";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
