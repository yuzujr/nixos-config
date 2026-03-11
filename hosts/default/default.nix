{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  system.stateVersion = "25.11";
}
