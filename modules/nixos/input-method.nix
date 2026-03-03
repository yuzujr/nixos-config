{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-rime
      qt6Packages.fcitx5-configtool
      fcitx5-mellow-themes
      rime-ice
    ];

    fcitx5.waylandFrontend = true;
  };
}
