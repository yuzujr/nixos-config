{
  lib,
  pkgs,
  ...
}:
{
  systemd.user = {
    services.drcom = {
      Unit = {
        Description = "DRCOM client";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
        ExecStart = "/run/current-system/sw/bin/drcom_client -c %h/.config/drcom-client-cpp/drcom_jlu.conf";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    services.gold-price-history-daily = {
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

    timers.gold-price-history-daily = {
      Unit = {
        Description = "Run gold-price-history-daily once per day";
      };

      Timer = {
        OnCalendar = "*-*-* 00:10:00";
        RandomizedDelaySec = "15m";
        Persistent = true;
        Unit = "gold-price-history-daily.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    services.gold-price-watch = {
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

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    services.sunshine = {
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
        ExecStart = "/run/current-system/sw/bin/sunshine";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        # WantedBy = [ "graphical-session.target" ];
      };
    };

    services.wl-clip-persist = {
      Unit = {
        Description = "Wayland clipboard persistence";
        PartOf = [ "niri.service" ];
        After = [ "niri.service" ];
        BindsTo = [ "niri.service" ];
      };

      Service = {
        ExecStart = "/run/current-system/sw/bin/wl-clip-persist --clipboard regular";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install = {
        WantedBy = [ "niri.service" ];
      };
    };
  };
}
