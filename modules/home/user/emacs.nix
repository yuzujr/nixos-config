{ pkgs, ... }:
{
    home.packages = [ pkgs.cmark-gfm ];

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
                diff-hl
                eat
                expand-region
                glsl-mode
                helpful
                kdl-mode
                magit
                marginalia
                markdown-mode
                move-text
                multiple-cursors
                nix-ts-mode
                olivetti
                orderless
                prescient
                projectile
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
