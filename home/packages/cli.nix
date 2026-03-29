{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    let
      shellWorkflow = [
        eza
        fd
        fzf
        ripgrep
        starship
        yazi
        zoxide
      ];

      terminalInspection = [
        btop
        csvlens
        duf
        dust
        fastfetch
      ];

      noveltyTools = [
        cmatrix
        nyancat
      ];
    in
    shellWorkflow ++ terminalInspection ++ noveltyTools;
}
