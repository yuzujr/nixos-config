{ pkgs, ... }:
{
    xdg.configFile = {
        "autostart/nm-applet.desktop".text = ''
            [Desktop Entry]
            Hidden=true
        '';
    };

    xdg.desktopEntries = {
        qq = {
            name = "QQ";
            exec = "env __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json qq %U";
            terminal = false;
            type = "Application";
            icon = "qq";
            categories = [ "Network" ];
            comment = "QQ";
        };

        code = {
            name = "Visual Studio Code";
            genericName = "Text Editor";
            comment = "Code Editing. Redefined.";
            exec = "code --ozone-platform-hint=auto %F";
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
            typora
            google-chrome
        ];
    };

    xdg.userDirs = {
        enable = true;
        createDirectories = true;
    };
}
