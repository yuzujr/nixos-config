{ pkgs, ... }:
{
    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
        ];
        config.niri = {
            default = [
                "gnome"
                "gtk"
            ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Access" = [ "gtk" ];
            "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
    };
}
