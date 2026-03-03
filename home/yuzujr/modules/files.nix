{ ... }:

let
  dotfilesRoot = ../dotfiles;

  configDirs = [
    "autostart"
    "btop"
    "cava"
    "drcom-client-cpp"
    "emacs"
    "fastfetch"
    "fcitx5"
    "feh"
    "fish"
    "gold-price"
    "kitty"
    "mihomo"
    "niri"
    "nvim"
    "nwg-look"
    "qt6ct"
    "xdg-desktop-portal"
    "zathura"
  ];

  mkConfigDir = name: {
    name = ".config/${name}";
    value.source = dotfilesRoot + "/.config/${name}";
  };
in {
  home.file =
    builtins.listToAttrs (map mkConfigDir configDirs)
    // {
      ".config/chrome-flags.conf".source = dotfilesRoot + "/.config/chrome-flags.conf";
      ".config/kwinrc".source = dotfilesRoot + "/.config/kwinrc";
      ".config/starship.toml".source = dotfilesRoot + "/.config/starship.toml";

      ".icons/default".source = dotfilesRoot + "/.icons/default";

      ".local/bin".source = dotfilesRoot + "/.local/bin";

      ".local/share/applications".source =
        dotfilesRoot + "/.local/share/applications";

      ".local/share/dbus-1/services".source =
        dotfilesRoot + "/.local/share/dbus-1/services";

      ".local/share/fcitx5/rime".source =
        dotfilesRoot + "/.local/share/fcitx5/rime";

      ".local/share/konsole".source =
        dotfilesRoot + "/.local/share/konsole";
    };
}
