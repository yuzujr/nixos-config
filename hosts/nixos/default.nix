{ ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../modules/nixos
    ];

    system.stateVersion = "25.11";
}
