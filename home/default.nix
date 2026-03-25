{
  lib,
  myvars,
  userSystemdServicesEnabled,
  ...
}:
{
  imports = [
    ./dotfiles.nix
    ./userPackages.nix
  ]
  ++ lib.optionals userSystemdServicesEnabled [
    ./systemd-user.nix
  ];

  fonts.fontconfig.enable = false;

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
