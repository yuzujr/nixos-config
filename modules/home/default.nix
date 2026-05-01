{
    lib,
    vars,
    userSystemdServicesEnabled,
    ...
}:
{
    imports = [
        ./desktop
        ./development
        ./dotfiles.nix
        ./editors
        ./shell
    ]
    ++ lib.optionals userSystemdServicesEnabled [
        ./services
    ];

    fonts.fontconfig.enable = false;
    services.mpris-proxy.enable = true;

    home = {
        inherit (vars) username;
        stateVersion = "26.05";
    };
}
