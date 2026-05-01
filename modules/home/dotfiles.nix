{
    config,
    lib,
    vars,
    osConfig ? { },
    ...
}:
let
    inherit (vars) repoRoot;
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    hasSecret =
        name:
        lib.hasAttrByPath [
            "age"
            "secrets"
            name
        ] osConfig;
in
{
    home.file.".local/bin".source = mkSymlink "${repoRoot}/dotfiles/local/bin";

    xdg.configFile = {
        "fish".source = mkSymlink "${repoRoot}/dotfiles/fish";
        "nvim".source = mkSymlink "${repoRoot}/dotfiles/nvim";
        "emacs".source = mkSymlink "${repoRoot}/dotfiles/emacs";
        "starship.toml".source = mkSymlink "${repoRoot}/dotfiles/starship.toml";

        "niri".source = mkSymlink "${repoRoot}/dotfiles/niri/";
        "noctalia".source = mkSymlink "${repoRoot}/dotfiles/noctalia/config";
        "kitty".source = mkSymlink "${repoRoot}/dotfiles/kitty";
        "fuzzel".source = mkSymlink "${repoRoot}/dotfiles/fuzzel";
        "fastfetch".source = mkSymlink "${repoRoot}/dotfiles/fastfetch";
        "btop".source = mkSymlink "${repoRoot}/dotfiles/btop";
        "cava".source = mkSymlink "${repoRoot}/dotfiles/cava";
        "chrome-flags.conf".source = mkSymlink "${repoRoot}/dotfiles/chrome-flags.conf";
        "feh".source = mkSymlink "${repoRoot}/dotfiles/feh";
        "gold-price/gold-price-watch.conf".source =
            mkSymlink "${repoRoot}/dotfiles/gold-price/gold-price-watch.conf";
        "kdeglobals".source = mkSymlink "${repoRoot}/dotfiles/kdeglobals";
        "kcminputrc".source = mkSymlink "${repoRoot}/dotfiles/kcminputrc";
        "kxkbrc".source = mkSymlink "${repoRoot}/dotfiles/kxkbrc";
        "nwg-look".source = mkSymlink "${repoRoot}/dotfiles/nwg-look";
        "plasma-workspace/env/10-unset-qt-platformtheme.sh".source =
            mkSymlink "${repoRoot}/dotfiles/plasma-workspace/env/10-unset-qt-platformtheme.sh";
        "qt6ct".source = mkSymlink "${repoRoot}/dotfiles/qt6ct";
        "zathura".source = mkSymlink "${repoRoot}/dotfiles/zathura";

        "fcitx5/config".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/config";
        "fcitx5/profile".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/profile";
        "fcitx5/conf/clipboard.conf".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/clipboard.conf";
        "fcitx5/conf/quickphrase.conf".source =
            mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/quickphrase.conf";
        "fcitx5/conf/classicui.conf".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/classicui.conf";
        "fcitx5/conf/notifications.conf".source =
            mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/notifications.conf";
        "fcitx5/conf/rime.conf".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/conf/rime.conf";
    }
    // lib.optionalAttrs (hasSecret "gold-price-history.conf") {
        "gold-price/gold-price-history.conf" = {
            source = mkSymlink osConfig.age.secrets."gold-price-history.conf".path;
        };
    }
    // lib.optionalAttrs (hasSecret "nix-user.conf") {
        "nix/nix.conf" = {
            source = mkSymlink osConfig.age.secrets."nix-user.conf".path;
        };
    };

    xdg.dataFile = {
        "konsole".source = mkSymlink "${repoRoot}/dotfiles/konsole";
        "fcitx5/rime".source = mkSymlink "${repoRoot}/dotfiles/fcitx5/rime";
    };

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
