{ ... }:
{
    imports = [
        ./locale.nix
        ./nix.nix
        ./system-packages.nix
        ./users.nix
        ./desktop.nix
        ./hardware.nix
        ./networking.nix
        ./virtualization.nix
    ];
}
