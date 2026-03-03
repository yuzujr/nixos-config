{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/packages.nix
  ];

  networking.hostName = "nixos";

  system.stateVersion = "25.11";
}
