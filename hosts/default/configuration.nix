{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/base.nix
    ../../modules/hardware.nix
    ../../modules/desktop.nix
    ../../modules/packages.nix
  ];

  networking.hostName = "nixos";

  system.stateVersion = "25.11";
}
