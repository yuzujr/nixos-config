{ pkgs, ... }:
{
    xdg.mimeApps = {
        enable = true;
        defaultApplicationPackages = with pkgs; [
            feh
            kdePackages.dolphin
        ];
        defaultApplications = {
            "application/xhtml+xml" = [ "google-chrome.desktop" ];
            "text/markdown" = [ "typora.desktop" ];
            "text/html" = [ "google-chrome.desktop" ];
            "text/x-markdown" = [ "typora.desktop" ];
            "x-scheme-handler/about" = [ "google-chrome.desktop" ];
            "x-scheme-handler/http" = [ "google-chrome.desktop" ];
            "x-scheme-handler/https" = [ "google-chrome.desktop" ];
            "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
        };
    };
}
