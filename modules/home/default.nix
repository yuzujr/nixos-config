{
    vars,
    ...
}:
{
    imports = [
        ./desktop
        ./dotfiles
        ./services
    ];

    home = {
        inherit (vars) username;
        stateVersion = "26.05";
    };
}
