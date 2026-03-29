{ pkgs, ... }:
{
  xdg.configFile = {
    "autostart/nm-applet.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';

    "autostart/net.lutris.Lutris.desktop".text = ''
      [Desktop Entry]
      OnlyShowIn=KDE;
      Hidden=true
    '';
  };
}
