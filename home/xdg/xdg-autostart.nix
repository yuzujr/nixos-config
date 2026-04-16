{ pkgs, ... }:
{
    xdg.configFile = {
        "autostart/nm-applet.desktop".text = ''
            [Desktop Entry]
            Hidden=true
        '';
    };
}
