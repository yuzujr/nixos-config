{ pkgs, vars, ... }:
{
    programs.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
        extraPackages =
            epkgs: with epkgs; [
                ace-window
                benchmark-init
                consult
                consult-dir
                corfu
                corfu-prescient
                direnv
                eldoc-box
                embark
                embark-consult
                glsl-mode
                helpful
                kdl-mode
                magit
                marginalia
                markdown-mode
                move-text
                multiple-cursors
                nix-ts-mode
                orderless
                prescient
                rust-mode
                solarized-theme
                sudo-edit
                treesit-auto
                vertico
                vertico-prescient
                which-key
                yasnippet
                yasnippet-snippets
            ];
    };

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
                neovim
                vscode
            ];

            buildTools = [
                binutils
                gcc
                gnumake
                python3
                nodejs
            ];
        in
        ai ++ editors ++ buildTools;
}
