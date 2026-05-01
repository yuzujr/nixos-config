{ pkgs, ... }:
{
    programs.niri.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
        gwenview
        okular
        khelpcenter
        krdp
    ];

    # Keep Plasma installed, but disable KDE's crash handler entirely.
    systemd.services."drkonqi-coredump-processor@".enable = false;
    systemd.user.sockets."drkonqi-coredump-launcher".enable = false;
    systemd.user.services."drkonqi-coredump-launcher@".enable = false;
    systemd.user.services."drkonqi-coredump-pickup".enable = false;
    systemd.user.timers."drkonqi-coredump-cleanup".enable = false;
    systemd.user.services."drkonqi-sentry-postman".enable = false;
    systemd.user.paths."drkonqi-sentry-postman".enable = false;
    systemd.user.timers."drkonqi-sentry-postman".enable = false;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "Polkit GNOME Authentication Agent";
        partOf = [ "niri.service" ];
        after = [ "niri.service" ];
        bindsTo = [ "niri.service" ];
        wantedBy = [ "niri.service" ];

        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
        };
    };
}