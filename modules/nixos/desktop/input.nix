{ pkgs, ... }:
{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
            fcitx5-mellow-themes
            (fcitx5-rime.override {
                rimeDataPkgs = [ pkgs.rime-ice ];
            })
            qt6Packages.fcitx5-configtool
        ];
    };
}