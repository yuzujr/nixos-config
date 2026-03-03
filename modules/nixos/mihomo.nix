{ lib, pkgs, ... }:

{
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = ../../home/yuzujr/dotfiles/.config/mihomo/config.yaml;
  };

  # Don't block boot on NetworkManager-wait-online.
  # systemd.services.mihomo = {
  #   requires = lib.mkForce [ "network.target" ];
  #   after = lib.mkForce [ "network.target" ];
  # };
}
