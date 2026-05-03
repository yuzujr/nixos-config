{ ... }:
{
    imports = [
        ./direnv.nix
        ./emacs.nix
        ./git.nix
        ./mpv.nix
        ./packages.nix
        ./xdg.nix
    ];

    fonts.fontconfig.enable = false;
}
