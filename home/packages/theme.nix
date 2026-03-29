{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    let
      gtkThemes = [
        adw-gtk3
      ];

      cursorThemes = [
        bibata-cursors
      ];

      iconThemes = [
        tela-circle-icon-theme
      ];

      themeTools = [
        kdePackages.qt6ct
        nwg-look
      ];
    in
    gtkThemes ++ cursorThemes ++ iconThemes ++ themeTools;
}
