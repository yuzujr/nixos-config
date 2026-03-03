{ ... }:

{
  imports = [
    ./modules/base.nix
    ./modules/session.nix
    ./modules/noctalia.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/files.nix
    ./modules/services.nix
  ];
}
