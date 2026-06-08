{ ... }:
let
    defaultTo =
        desktopFile: mimeTypes:
        builtins.listToAttrs (
            map (mimeType: {
                name = mimeType;
                value = desktopFile;
            }) mimeTypes
        );
in
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

        defaultApplications =
            defaultTo "google-chrome.desktop" [
                "text/html"
                "application/xhtml+xml"
                "image/svg+xml"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
                "x-scheme-handler/about"
                "x-scheme-handler/unknown"
            ]
            // defaultTo "org.kde.dolphin.desktop" [
                "inode/directory"
            ]
            // defaultTo "feh.desktop" [
                "image/bmp"
                "image/gif"
                "image/heic"
                "image/jpeg"
                "image/jpg"
                "image/pjpeg"
                "image/png"
                "image/tiff"
                "image/webp"
                "image/x-bmp"
                "image/x-pcx"
                "image/x-png"
                "image/x-portable-anymap"
                "image/x-portable-bitmap"
                "image/x-portable-graymap"
                "image/x-portable-pixmap"
                "image/x-tga"
                "image/x-xbitmap"
            ]
            // defaultTo "typora.desktop" [
                "text/markdown"
                "text/x-markdown"
            ]
            // defaultTo "org.pwmt.zathura-pdf-mupdf.desktop" [
                "application/epub+zip"
                "application/oxps"
                "application/pdf"
                "application/x-fictionbook"
                "application/x-mobipocket-ebook"
            ]
            // defaultTo "org.pwmt.zathura-djvu.desktop" [
                "image/vnd.djvu"
                "image/vnd.djvu+multipage"
            ]
            // defaultTo "org.pwmt.zathura-ps.desktop" [
                "application/eps"
                "application/postscript"
                "application/x-eps"
                "image/eps"
                "image/x-eps"
            ]
            // defaultTo "org.kde.ark.desktop" [
                "application/arj"
                "application/gzip"
                "application/vnd.ms-cab-compressed"
                "application/vnd.rar"
                "application/x-7z-compressed"
                "application/x-archive"
                "application/x-arj"
                "application/x-bzip"
                "application/x-bzip-compressed-tar"
                "application/x-bzip2"
                "application/x-bzip2-compressed-tar"
                "application/x-compress"
                "application/x-compressed-tar"
                "application/x-cpio"
                "application/x-gzip"
                "application/x-lha"
                "application/x-lrzip"
                "application/x-lrzip-compressed-tar"
                "application/x-lz4"
                "application/x-lz4-compressed-tar"
                "application/x-lzip"
                "application/x-lzip-compressed-tar"
                "application/x-lzma"
                "application/x-lzma-compressed-tar"
                "application/x-lzop"
                "application/x-rar"
                "application/x-stuffit"
                "application/x-tar"
                "application/x-tarz"
                "application/x-tzo"
                "application/x-xz"
                "application/x-xz-compressed-tar"
                "application/x-zstd-compressed-tar"
                "application/zip"
                "application/zlib"
                "application/zstd"
            ]
            // defaultTo "org.pwmt.zathura-cb.desktop" [
                "application/x-cb7"
                "application/x-cbr"
                "application/x-cbt"
                "application/x-cbz"
            ];
    };

    xdg.userDirs = {
        enable = true;
        createDirectories = true;
    };
}
