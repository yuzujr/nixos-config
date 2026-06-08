{
    ani2xcursorPkg,
    coomerPkg,
    drcomClientPkg,
    home-manager,
    noctaliaPkg,
    rosePineDoomEmacsSrc,
    vars,
    ...
}:
{
    imports = [
        home-manager.nixosModules.home-manager
    ];

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "home-manager.backup";
        extraSpecialArgs = {
            inherit
                ani2xcursorPkg
                coomerPkg
                drcomClientPkg
                noctaliaPkg
                rosePineDoomEmacsSrc
                vars
                ;
        };
        users.${vars.username}.imports = [
            ../../home
        ];
    };
}
