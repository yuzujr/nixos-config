{
  config,
  lib,
  myvars,
  osConfig ? { },
  ...
}:
let
  repoRoot = myvars.repoRoot;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  hasSecret = name: lib.hasAttrByPath [
    "age"
    "secrets"
    name
  ] osConfig;
in
{
  xdg.configFile = {
    "fish".source = mkSymlink "${repoRoot}/home/base/tui/shell/fish";
    "nvim".source = mkSymlink "${repoRoot}/home/base/tui/editors/nvim";
    "emacs".source = mkSymlink "${repoRoot}/home/base/tui/editors/emacs";

    "niri".source = mkSymlink "${repoRoot}/home/linux/gui/niri/conf";
    "noctalia".source = mkSymlink "${repoRoot}/home/linux/gui/noctalia/config";
    "kitty".source = mkSymlink "${repoRoot}/home/linux/gui/kitty";
    "fuzzel".source = mkSymlink "${repoRoot}/home/linux/gui/fuzzel";
    "fastfetch".source = mkSymlink "${repoRoot}/home/linux/gui/fastfetch";
    "autostart".source = mkSymlink "${repoRoot}/home/linux/gui/autostart";
    "btop".source = mkSymlink "${repoRoot}/home/linux/gui/btop";
    "cava".source = mkSymlink "${repoRoot}/home/linux/gui/cava";
    "chrome-flags.conf".source = mkSymlink "${repoRoot}/home/linux/gui/chrome-flags.conf";
    "feh".source = mkSymlink "${repoRoot}/home/linux/gui/feh";
    "gold-price/gold-price-watch.conf".source =
      mkSymlink "${repoRoot}/home/linux/gui/gold-price/gold-price-watch.conf";
    "kwinrc".source = mkSymlink "${repoRoot}/home/linux/gui/kwinrc";
    "nwg-look".source = mkSymlink "${repoRoot}/home/linux/gui/nwg-look";
    "qt6ct".source = mkSymlink "${repoRoot}/home/linux/gui/qt6ct";
    "zathura".source = mkSymlink "${repoRoot}/home/linux/gui/zathura";

    "systemd/user/drcom.service".source =
      mkSymlink "${repoRoot}/home/linux/gui/systemd-user/drcom.service";
    "systemd/user/gold-price-history-daily.service".source =
      mkSymlink "${repoRoot}/home/linux/gui/systemd-user/gold-price-history-daily.service";
    "systemd/user/gold-price-history-daily.timer".source =
      mkSymlink "${repoRoot}/home/linux/gui/systemd-user/gold-price-history-daily.timer";
    "systemd/user/gold-price-watch.service".source =
      mkSymlink "${repoRoot}/home/linux/gui/systemd-user/gold-price-watch.service";
    "systemd/user/sunshine.service".source =
      mkSymlink "${repoRoot}/home/linux/gui/systemd-user/sunshine.service";
    "systemd/user/wl-clip-persist.service".source =
      mkSymlink "${repoRoot}/home/linux/gui/systemd-user/wl-clip-persist.service";
  }
  // lib.optionalAttrs (hasSecret "drcom-jlu.conf") {
    "drcom-client-cpp/drcom_jlu.conf" = {
      source = mkSymlink "/etc/agenix/drcom-jlu.conf";
      force = true;
    };
  }
  // lib.optionalAttrs (hasSecret "gold-price-history.conf") {
    "gold-price/gold-price-history.conf" = {
      source = mkSymlink "/etc/agenix/gold-price-history.conf";
      force = true;
    };
  }
  // lib.optionalAttrs (hasSecret "nix-user.conf") {
    "nix/nix.conf" = {
      source = mkSymlink "/etc/agenix/nix-user.conf";
      force = true;
    };
  };

  xdg.dataFile = {
    "applications".source = mkSymlink "${repoRoot}/home/linux/gui/local/applications";
    "konsole".source = mkSymlink "${repoRoot}/home/linux/gui/konsole";
    "fcitx5/rime".source = mkSymlink "${repoRoot}/home/linux/base/fcitx5/rime";
  };

  home.file.".local/bin".source = mkSymlink "${repoRoot}/home/linux/gui/local/bin";

  home.activation.niriProfileLinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    profiles_dir="$HOME/.config/niri/profiles"
    mkdir -p "$profiles_dir"

    create_if_missing() {
      local target="$1"
      local link="$2"
      if [ -e "$link" ] || [ -L "$link" ]; then
        return 0
      fi
      ln -s "$target" "$link"
    }

    create_if_missing "normal/config.kdl" "$profiles_dir/current-config.kdl"
    create_if_missing "normal/outputs.kdl" "$profiles_dir/current-outputs.kdl"
    create_if_missing "normal/startup.kdl" "$profiles_dir/current-startup.kdl"
  '';
}
