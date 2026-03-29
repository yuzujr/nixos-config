{
  lib,
  myvars,
  userSystemdServicesEnabled,
  ...
}:
{
  imports = [
    ./dotfiles
    ./packages
    ./xdg
  ]
  ++ lib.optionals userSystemdServicesEnabled [
    ./systemd-user
  ];

  fonts.fontconfig.enable = false;

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
