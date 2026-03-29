{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    let
      ai = [
        codex
      ];

      editors = [
        emacs-pgtk
        emacsPackages.vterm
        neovim
        vscode
      ];

      tools = [
        nixd
        nixfmt
      ];
    in
    ai ++ editors ++ tools;
}
