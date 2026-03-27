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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home = {
    inherit (myvars) username;
    stateVersion = "24.11";
  };
}
