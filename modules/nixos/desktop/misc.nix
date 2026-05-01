{ ... }:
{
    services.dbus.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    services.orca.enable = false;
    services.speechd.enable = false;

    # leave for niri to handle
    services.logind.settings.Login = {
        HandlePowerKey = "ignore";
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
    };
}