{ pkgs, ... }:
{
    home.packages = with pkgs; [
        adw-gtk3
        bibata-cursors
        kdePackages.qt6ct
        nwg-look
        tela-circle-icon-theme
    ];
}
