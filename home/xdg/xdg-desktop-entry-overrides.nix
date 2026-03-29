{ ... }:
{
  xdg.desktopEntries = {
    code = {
      name = "Visual Studio Code";
      genericName = "Text Editor";
      comment = "Code Editing. Redefined.";
      exec = "env __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json code %F";
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

    qq = {
      name = "QQ";
      comment = "QQ";
      exec = "env __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json qq %U";
      icon = "qq";
      terminal = false;
      categories = [ "Network" ];
      settings.StartupWMClass = "QQ";
    };

    typora = {
      name = "Typora";
      genericName = "Markdown Editor";
      exec = "typora --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 %U";
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
}
