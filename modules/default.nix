{ ... }:
{
    imports = [
        ./locale.nix
        ./nix.nix
        ./system-packages.nix
        ./user.nix
        ./desktop.nix
        ./hardware.nix
        ./networking.nix
        ./virtualization.nix
    ];
}
