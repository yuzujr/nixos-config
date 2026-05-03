{
    hostname,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
        ../../modules/nixos
    ];

    networking.hostName = hostname;

    system.stateVersion = "25.11";
}
