{
  pkgs,
  coomerPkg,
  drcomClientPkg,
  ani2xcursorPkg,
  ...
}:
let
  cliPackages = import ./userPackages/cli.nix { inherit pkgs; };
  devPackages = import ./userPackages/dev.nix { inherit pkgs; };
  desktopPackages = import ./userPackages/desktop.nix { inherit pkgs; };
  customPackages = import ./userPackages/custom.nix {
    inherit coomerPkg drcomClientPkg ani2xcursorPkg;
  };
in
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages =
    cliPackages
    ++ devPackages
    ++ desktopPackages
    ++ customPackages;
}
