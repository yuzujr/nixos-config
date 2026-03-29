{ pkgs, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = with pkgs; [
      feh
      kdePackages.dolphin
    ];
    defaultApplications = {
      "text/markdown" = [ "typora.desktop" ];
      "text/x-markdown" = [ "typora.desktop" ];
    };
  };
}
