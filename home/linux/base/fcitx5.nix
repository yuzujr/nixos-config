{
  config,
  lib,
  osConfig ? { },
  ...
}:
let
  secretsEnabled = osConfig.modules.secrets.enable or false;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile = {
    "fcitx5/conf/clipboard.conf".source = ./fcitx5/conf/clipboard.conf;
    "fcitx5/conf/quickphrase.conf".source = ./fcitx5/conf/quickphrase.conf;
  } // lib.optionalAttrs secretsEnabled {
    "fcitx5/config".source = mkSymlink "/etc/agenix/fcitx5-config";
    "fcitx5/profile" = {
      source = mkSymlink "/etc/agenix/fcitx5-profile";
      force = true;
    };

    "fcitx5/conf/classicui.conf".source =
      mkSymlink "/etc/agenix/fcitx5-classicui.conf";
    "fcitx5/conf/notifications.conf".source =
      mkSymlink "/etc/agenix/fcitx5-notifications.conf";
    "fcitx5/conf/rime.conf".source =
      mkSymlink "/etc/agenix/fcitx5-rime.conf";
  };
}
