{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/gpu.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/input-method.nix
    ../../modules/nixos/session.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/programs.nix
    ../../modules/nixos/mihomo.nix
  ];

  networking.hostName = "nixos";

  system.stateVersion = "25.11";
}
