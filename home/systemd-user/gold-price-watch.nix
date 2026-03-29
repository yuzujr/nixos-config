{ ... }:
{
  systemd.user.services.gold-price-watch = {
    Unit = {
      Description = "Gold price watcher (USD/oz)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "%h/.local/bin/gold-price-watch --loop";
      Restart = "always";
      RestartSec = 10;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
