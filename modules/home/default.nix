{
    vars,
    ...
}:
{
    imports = [
        ./dotfiles
        ./services
        ./user
    ];

    home = {
        inherit (vars) username;
        stateVersion = "26.05";
        enableNixpkgsReleaseCheck = false;
    };
}
