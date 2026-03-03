{ lib, ... }:

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

      ".local/share/konsole".source =
        dotfilesRoot + "/.local/share/konsole";
    };

  # Copy rime config as writable files so rime can sync/deploy
  home.activation.fcitx5Rime = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rimeDir="$HOME/.local/share/fcitx5/rime"
    $DRY_RUN_CMD mkdir -p "$rimeDir"
    while IFS= read -r -d "" f; do
      dest="$rimeDir/$(basename "$f")"
      if [ ! -e "$dest" ]; then
        $DRY_RUN_CMD cp "$f" "$dest"
        $DRY_RUN_CMD chmod u+w "$dest"
      fi
    done < <(find ${dotfilesRoot + "/.local/share/fcitx5/rime"} -maxdepth 1 -type f -print0)
  '';
}
