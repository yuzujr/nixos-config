{ ... }:
{
    systemd.user.services.gold-price-history-daily = {
        Unit = {
            Description = "Fetch and store daily gold price history (USD/oz)";
        };

        Service = {
            Type = "oneshot";
            ExecStart = "%h/.local/bin/gold-price-history-daily";
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
