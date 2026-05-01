{ pkgs, ... }:
{
    xdg.configFile = {
        "autostart/nm-applet.desktop".text = ''
            [Desktop Entry]
            Hidden=true
        '';
    };

    xdg.desktopEntries = {
        code = {
            name = "Visual Studio Code";
            genericName = "Text Editor";
            comment = "Code Editing. Redefined.";
            exec = "env __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json code --ozone-platform-hint=auto %F";
            icon = "vscode";
            terminal = false;
            startupNotify = true;
            categories = [
                "Utility"
                "TextEditor"
                "Development"
                "IDE"
            ];
            settings = {
                Keywords = "vscode";
                StartupWMClass = "Code";
                Version = "1.5";
            };
            actions.new-empty-window = {
                name = "New Empty Window";
                exec = "code --new-window %F";
                icon = "vscode";
            };
        };

        typora = {
            name = "Typora";
            genericName = "Markdown Editor";
            exec = "typora --ozone-platform-hint=auto --enable-wayland-ime --wayland-text-input-version=3 %U";
            icon = "typora";
            terminal = false;
            startupNotify = true;
            categories = [
                "Office"
                "WordProcessor"
            ];
            mimeType = [
                "text/markdown"
                "text/x-markdown"
            ];
        };
    };

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

    # Keep XDG user directories on the standard English names even if the UI
    # message locale is set to Chinese.
    xdg.userDirs = {
        enable = true;
        createDirectories = true;
    };
}
