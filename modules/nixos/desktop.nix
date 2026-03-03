{ config, pkgs, ... }:

{
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.power-profiles-daemon.enable = true;

  programs.niri.enable = true;
  services.displayManager.sessionPackages = [ pkgs.niri ];

  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;

      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "yuzujr";
      };

      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
