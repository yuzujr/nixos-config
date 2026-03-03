{ pkgs, ... }:

{
  systemd.user.startServices = "sd-switch";

  systemd.user.services = {
    wl-clip-persist = {
      Unit = {
        Description = "Wayland clipboard persistence";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        BindsTo = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    sunshine = {
      Unit = {
        Description = "Self-hosted game stream host for Moonlight";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        BindsTo = [ "graphical-session.target" ];
      };

      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart = "${pkgs.sunshine}/bin/sunshine";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    gold-price-watch = {
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

    gold-price-history-daily = {
      Unit = {
        Description = "Fetch and store daily gold price history (USD/oz)";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "%h/.local/bin/gold-price-history-daily";
      };
    };

    drcom = {
      Unit = {
        Description = "DRCOM client";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Environment = [
          "LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib"
        ];
        ExecStart = "%h/.local/bin/drcom_client -c %h/.config/drcom-client-cpp/drcom_jlu.conf";
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.gold-price-history-daily = {
    Unit.Description = "Run gold-price-history-daily once per day";

    Timer = {
      OnCalendar = "*-*-* 00:10:00";
      RandomizedDelaySec = "15m";
      Persistent = true;
      Unit = "gold-price-history-daily.service";
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
