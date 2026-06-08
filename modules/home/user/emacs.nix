{
    pkgs,
    rosePineDoomEmacsSrc,
    ...
}:
{
    home.packages = [ pkgs.cmark-gfm ];

    xdg.dataFile."emacs/themes/rose-pine-doom-emacs".source = rosePineDoomEmacsSrc;

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
                doom-themes
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
                treesit-auto
                vertico
                vertico-prescient
                which-key
                yasnippet
            ];
    };
}
