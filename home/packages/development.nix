{ pkgs, vars, ... }:
{
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };

    programs.git = {
        enable = true;
        settings = {
            user = {
                email = vars.git.email;
                name = vars.git.name;
            };
            core.quotepath = false;
            init.defaultBranch = "main";
        };
    };

    programs.delta = {
        enable = true;
        enableGitIntegration = true;
    };

    home.packages =
        with pkgs;
        let
            ai = [
                codex
            ];

            editors = [
                emacs-pgtk
                neovim
                vscode
            ];

            buildTools = [
                python3
                gcc
                gnumake
                binutils
            ];
        in
        ai ++ editors ++ buildTools;
}
