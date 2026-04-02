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
  services.mpris-proxy.enable = true;

  home = {
    inherit (myvars) username;
    stateVersion = "26.05";
  };
}
