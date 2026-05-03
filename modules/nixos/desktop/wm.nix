{ pkgs, ... }:
{
    # niri
    programs.niri.enable = true;
    # kde plasma
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        elisa
        gwenview
        okular
        khelpcenter
        krdp
    ];

    # leave these event for wm to handle
    services.logind.settings.Login = {
        HandlePowerKey = "ignore";
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
    };

    # Keep Plasma installed, but disable KDE's crash handler entirely.
    systemd.services."drkonqi-coredump-processor@".enable = false;
    systemd.user.sockets."drkonqi-coredump-launcher".enable = false;
    systemd.user.services."drkonqi-coredump-launcher@".enable = false;
    systemd.user.services."drkonqi-coredump-pickup".enable = false;
    systemd.user.timers."drkonqi-coredump-cleanup".enable = false;
    systemd.user.services."drkonqi-sentry-postman".enable = false;
    systemd.user.paths."drkonqi-sentry-postman".enable = false;
    systemd.user.timers."drkonqi-sentry-postman".enable = false;

    # services
    services.dbus.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    services.orca.enable = false;
    services.speechd.enable = false;
}
