{
  lib,
  pkgs,
  coomerPkg,
  drcomClientPkg,
  ani2xcursorPkg,
  ...
}:
let
  cliPackages = import ./userPackages/cli.nix {
    inherit lib pkgs;
  };
  devPackages = import ./userPackages/dev.nix {
    inherit lib pkgs;
  };
  desktopPackages = import ./userPackages/desktop.nix {
    inherit lib pkgs;
  };
  customPackages = import ./userPackages/custom.nix {
    inherit coomerPkg drcomClientPkg ani2xcursorPkg;
  };
in
{
  home.packages = lib.concatLists [
    cliPackages
    devPackages
    desktopPackages
    customPackages
  ];
}
