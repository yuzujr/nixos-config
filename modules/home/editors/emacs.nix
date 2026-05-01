{ pkgs, ... }:
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
}
