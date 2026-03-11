{
  config,
  myvars,
  ...
}:
let
  repoRoot = myvars.repoRoot;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
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
  };

  xdg.dataFile."applications".source =
    mkSymlink "${repoRoot}/home/linux/gui/local/applications";

  home.file.".local/bin".source = mkSymlink "${repoRoot}/home/linux/gui/local/bin";
}
