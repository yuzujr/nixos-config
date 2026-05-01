{ pkgs, ... }:
{
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };

    home.packages = with pkgs; [
        binutils
        gcc
        gnumake
        nodejs
        python3
    ];
}
