{ pkgs, ... }:
{
    programs.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
        extraPackages =
            epkgs: with epkgs; [
                ace-window
                avy
                consult
                corfu
                corfu-prescient
                direnv
                eat
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
                sideline
                sideline-flymake
                solarized-theme
                treesit-auto
                vertico
                vertico-prescient
                which-key
                yasnippet
            ];
    };
}
