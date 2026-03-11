{ myvars, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos
  ];

  networking.hostName = lib.mkDefault myvars.hostname;

  modules.desktop.mihomo.enable = lib.mkDefault true;

  system.stateVersion = "25.11";
}
